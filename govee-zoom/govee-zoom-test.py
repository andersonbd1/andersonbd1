"""One-shot probe: print the current state of the Govee device."""

import os
import sys

import requests

api_key = os.environ.get('GOVEE_API_KEY')
if not api_key:
    sys.exit('GOVEE_API_KEY is not set. Try: uv run --env-file .env govee-zoom-test.py')

headers = {
    'Govee-API-Key': api_key,
    'accept': 'application/json',
    'content-type': 'application/json',
}

params = {
    'device': os.environ.get('GOVEE_DEVICE', '22:F4:D0:C9:07:00:23:A8'),
    'model': os.environ.get('GOVEE_MODEL', 'H6008'),
}

response = requests.get(
    'https://developer-api.govee.com/v1/devices/state',
    params=params,
    headers=headers,
    timeout=10,
)

print(f'Status Code: {response.status_code}')
print(f'Response: {response.text}')
print(f"Rate limit left this minute: {response.headers.get('API-RateLimit-Remaining', '?')}")
