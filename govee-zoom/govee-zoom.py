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

POLL_SECONDS = 5
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


def zoom_socket_count():
    """Zoom's open UDP sockets, or None if lsof didn't answer."""
    try:
        result = subprocess.run(
            ['lsof', '-i', '4UDP'], capture_output=True, text=True, timeout=10
        )
    except (subprocess.TimeoutExpired, OSError) as e:
        log(f'lsof failed: {e}')
        return None
    return sum(1 for line in result.stdout.splitlines() if 'zoom' in line)


def main():
    log(f'watching zoom, driving {MODEL} {DEVICE}')
    prev_busy = None
    while True:
        count = zoom_socket_count()
        # An unreadable count is not the same as "no call" -- leave the light alone.
        if count is not None:
            is_busy = count > 1
            # Compare the busy flag, not the raw socket count: Zoom opens and
            # closes sockets throughout a call, and re-sending on every wobble
            # burns through the rate limit in seconds.
            if is_busy != prev_busy:
                log(f"{count} zoom sockets -> {'BUSY' if is_busy else 'free'}")
                if apply_state(is_busy):
                    prev_busy = is_busy  # only commit once the light agrees
                else:
                    log('light did not update, retrying next poll')
        sleep(POLL_SECONDS)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        log('stopped')
