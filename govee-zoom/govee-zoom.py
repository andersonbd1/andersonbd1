"""Turn a Govee light red while Zoom is in a call, warm white otherwise."""

import os
import subprocess
import sys
from collections import deque
from time import monotonic, sleep, strftime, time

import requests

URL = 'https://developer-api.govee.com/v1/devices/control'
DEVICE = os.environ.get('GOVEE_DEVICE', '22:F4:D0:C9:07:00:23:A8')
MODEL = os.environ.get('GOVEE_MODEL', 'H6008')

POLL_SECONDS = 2
CONFIRM_POLLS = 2  # only to ride out a one-off odd reading; the socket test below
                   # is what rules out Zoom's interface probing
MAX_ATTEMPTS = 4  # 1s + 2s + 4s of backoff before giving up on a command
RATE_LIMIT = 9    # Govee allows 10 requests/minute per key; keep one in reserve
RATE_WINDOW = 60.0

api_key = os.environ.get('GOVEE_API_KEY')
if not api_key:
    sys.exit('GOVEE_API_KEY is not set. Try: uv run --env-file .env govee-zoom.py')

session = requests.Session()
session.headers.clear()  # Clear all default headers
session.headers.update({
    'Govee-API-Key': api_key,
    'accept': 'application/json',
    'content-type': 'application/json',
})

sent = deque()        # monotonic timestamps of our own recent requests
budget_left = None    # API-RateLimit-Remaining from the last response
budget_reset = 0.0    # unix epoch when that budget refills


def log(message):
    print(f"{strftime('%H:%M:%S')} {message}", flush=True)


def record_budget(response):
    """Remember what Govee said is left, whatever the status code."""
    global budget_left, budget_reset
    remaining = response.headers.get('API-RateLimit-Remaining', '')
    reset = response.headers.get('API-RateLimit-Reset', '')
    if remaining.isdigit():
        budget_left = int(remaining)
    if reset.isdigit():
        budget_reset = int(reset)


def throttle():
    """Block until another request fits inside Govee's per-minute budget."""
    global budget_left
    # Our own request log is not the whole story: the key is shared with any
    # other caller, so trust Govee's own count once we have seen it.
    if budget_left == 0:
        wait = budget_reset - time()
        if wait > 0:
            log(f'budget spent, waiting {wait:.0f}s for the reset')
            sleep(min(wait, RATE_WINDOW))
        budget_left = None
    while len(sent) >= RATE_LIMIT:
        wait = RATE_WINDOW - (monotonic() - sent[0])
        if wait <= 0:
            sent.popleft()
            continue
        log(f'holding {wait:.0f}s for the rate limit')
        sleep(wait)
    sent.append(monotonic())


def retry_after(response):
    """Seconds to wait after a 429, from whichever header Govee sent."""
    header = response.headers.get('Retry-After', '')
    if header.isdigit():
        return min(int(header), RATE_WINDOW)
    reset = response.headers.get('API-RateLimit-Reset', '')
    if reset.isdigit():
        return max(0.0, min(int(reset) - time(), RATE_WINDOW))
    return RATE_WINDOW


def send_command(cmd):
    """PUT one command, retrying transient failures. True if the light accepted it."""
    name = cmd['cmd']['name']
    data = {'device': DEVICE, 'model': MODEL} | cmd
    for attempt in range(1, MAX_ATTEMPTS + 1):
        throttle()
        try:
            response = session.put(URL, json=data, timeout=10)
        except requests.RequestException as e:
            # Govee's edge refuses connections outright when it sheds load, so a
            # dead socket is expected here and must not take the watcher down.
            log(f'{name}: {type(e).__name__} on attempt {attempt}')
        else:
            record_budget(response)
            if response.ok:
                log(f'{name}: {response.status_code}, {budget_left} left this minute')
                return True
            log(f'{name}: {response.status_code} {response.text.strip()[:120]}')
            if response.status_code == 429:
                sleep(retry_after(response))
                continue
            if 400 <= response.status_code < 500:
                return False  # bad key, device or payload; retrying won't help
        if attempt < MAX_ATTEMPTS:
            sleep(2 ** (attempt - 1))
    return False


def apply_state(is_busy):
    """Push the busy/free look to the light. True only if every command landed."""
    # color and colorTem are mutually exclusive modes on this light, so send one
    # or the other. Requests are the scarce resource here; don't waste one being
    # overwritten by the next command.
    if is_busy:
        commands = [{'cmd': {'name': 'color', 'value': {
            'name': 'Color', 'r': 255, 'g': 0, 'b': 0,
        }}}]
    else:
        commands = [{'cmd': {'name': 'colorTem', 'value': 3000}}]
    commands.append({'cmd': {'name': 'brightness', 'value': 1 if is_busy else 100}})

    for cmd in commands:
        if not send_command(cmd):
            return False
    return True


def zoom_is_active():
    """True if Zoom has a UDP socket open to a media server. None if lsof failed.

    In a call Zoom connects several UDP sockets straight to a media server:
        UDP 192.168.9.128:49624->206.247.10.158:8801
    Between calls it periodically binds one *unconnected* socket per network
    interface for about six seconds to probe reachability:
        UDP 172.30.1.0:57478
        UDP 169.254.79.110:49158
    Counting sockets confuses the two, which is what used to turn the light red
    at random. Requiring a connected remote peer separates them outright.
    """
    try:
        # -c zoom is deliberately case sensitive: it matches the zoom.us process
        # but not ZoomCefHelper, whose QUIC traffic to the web has no bearing on
        # whether a meeting is running. Narrowing to one command also keeps this
        # near 50ms, cheap enough to poll often.
        result = subprocess.run(
            ['lsof', '-nP', '-a', '-c', 'zoom', '-i', '4UDP'],
            capture_output=True, text=True, timeout=10,
        )
    except (subprocess.TimeoutExpired, OSError) as e:
        log(f'lsof failed: {e}')
        return None
    for line in result.stdout.splitlines():
        _, arrow, remote = line.partition('->')
        # Skip the self-connected loopback socket Zoom keeps open for IPC.
        if arrow and not remote.startswith('127.'):
            return True
    return False


def main():
    log(f'watching zoom, driving {MODEL} {DEVICE}')
    applied = None  # what the light is currently showing
    pending = None  # reading waiting to be confirmed
    agree = 0       # consecutive polls that agreed on it
    while True:
        active = zoom_is_active()
        if active is None:
            # An unreadable state is not the same as "no call". Leave the light
            # alone and start the count over.
            pending, agree = None, 0
        else:
            if active == pending:
                agree += 1
            else:
                pending, agree = active, 1
            # Only act on a reading that has held still. A momentary blip is
            # Zoom counting its interfaces, not a meeting.
            if agree >= CONFIRM_POLLS and pending != applied:
                log(f"zoom {'active' if pending else 'idle'} "
                    f"{agree * POLL_SECONDS}s -> {'BUSY' if pending else 'free'}")
                if apply_state(pending):
                    applied = pending  # only commit once the light agrees
                else:
                    log('light did not update, retrying next poll')
        sleep(POLL_SECONDS)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        log('stopped')
