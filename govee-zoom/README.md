# govee-zoom

Turns a Govee light red while you're in a Zoom call and warm white when you're not,
so the people you live with can tell at a glance.

## Setup

Requires [uv](https://docs.astral.sh/uv/) and macOS (detection shells out to `lsof`).

Create `.env` next to the script:

```
GOVEE_API_KEY=your-key-here
GOVEE_DEVICE=22:F4:D0:C9:07:00:23:A8
GOVEE_MODEL=H6008
```

`.env` is gitignored. Keep the key out of tracked files — this repo is public, and an
earlier version of this script had the key hardcoded, so anything committed here is
permanently readable in history.

Get a key from the Govee Home app: Profile → About Us → Apply for API Key. It arrives
by email. Then list your devices to find the id and model:

```sh
curl -sS -H "Govee-API-Key: $GOVEE_API_KEY" \
  https://developer-api.govee.com/v1/devices | python3 -m json.tool
```

```json
{
  "device": "22:F4:D0:C9:07:00:23:A8",
  "model": "H6008",
  "deviceName": "Executive Suite Stairs",
  "supportCmds": ["turn", "brightness", "color", "colorTem"]
}
```

## Running

```sh
uv run --env-file .env govee-zoom.py
```

It runs in the foreground and logs every decision. Ctrl-C to stop.

```
10:10:30 watching zoom, driving H6008 22:F4:D0:C9:07:00:23:A8
10:10:32 zoom active 4s -> BUSY
10:10:32 color: 200, 9 left this minute
10:10:33 brightness: 200, 8 left this minute
```

To check the light's current state without changing anything:

```sh
uv run --env-file .env govee-zoom-test.py
```

Note that `govee-zoom.py` is the whole program. `src/govee_zoom/` is leftover scaffolding
from `uv init` and does nothing, so `uv run govee-zoom` (no `.py`) just prints a stub
greeting.

## How it decides you're in a call

It looks for a Zoom UDP socket **connected** to a remote media server:

```
UDP 192.168.9.128:49624->206.247.10.158:8801     in a call
```

The connection matters. Between calls Zoom periodically binds one *unconnected* socket
per network interface for about six seconds to probe reachability:

```
UDP 172.30.1.0:57478                              not in a call
UDP 169.254.79.110:49158                          not in a call
```

An earlier version counted sockets instead, which made the light flash red every minute
or so while idle. Requiring a connected peer tells the two cases apart with no guesswork.
A reading also has to repeat once before it's acted on, so the light responds about four
seconds after you join or leave.

Two details worth preserving if you edit `zoom_is_active()`:

- The `lsof -c zoom` filter is **case-sensitive on purpose**. It matches `zoom.us` but not
  `ZoomCefHelper`, which holds connected UDP sockets to the open web for Zoom's embedded
  browser. Matching case-insensitively turns the light red whenever that loads a page.
- Zoom keeps one self-connected loopback socket (`127.0.0.1:x->127.0.0.1:x`) open forever
  for IPC. It's connected, so it has to be excluded by address.

## Rate limits

Govee allows **10 requests per minute** and 10,000 per day per key, and its edge *refuses
TCP connections* rather than returning 429 when you exceed the minute budget — which reads
as a confusing `Connection refused` traceback.

The script sends 2 requests per transition (never on a poll), paces itself against the
limit, and honors the `API-RateLimit-Remaining` / `-Reset` headers, since the same key may
be in use elsewhere. Failed requests are retried with backoff and never crash the loop; a
transition that can't be applied is retried on the next poll.

## Tuning

| Constant | Default | Effect |
| --- | --- | --- |
| `POLL_SECONDS` | `2` | How often `lsof` runs. Costs no API budget, ~2.5% of a core. |
| `CONFIRM_POLLS` | `2` | Agreeing polls before acting. `1` reacts instantly but trusts a single reading. |
| `MAX_ATTEMPTS` | `4` | Retries per command, with 1s/2s/4s backoff. |
| `RATE_LIMIT` | `9` | Self-imposed per-minute ceiling, one below Govee's, to leave room for manual calls. |

Colors are in `apply_state()`: red at brightness 1 for busy, 3000K at brightness 100 otherwise.

## Troubleshooting

| Symptom | Cause |
| --- | --- |
| `Connection refused` / `ConnectionError` in the log | Rate limit or a Govee blip. It retries; not fatal. |
| `429 Rate limit exceeded, retry in Ns` | Something else is spending the same key's budget. |
| `401` | Bad or revoked `GOVEE_API_KEY`. |
| Light never turns red | Check `lsof -nP -a -c zoom -i 4UDP` during a call and confirm a line with `->` in it. |
| Light turns red at random | A non-call connected socket is matching. Capture the same command's output while idle. |
