import requests
import subprocess
from time import sleep

url = 'https://developer-api.govee.com/v1/devices/control'

headers = {
    'Govee-API-Key': 'REDACTED',
    'accept': 'application/json',
    'content-type': 'application/json'
}

def change_color(is_busy: bool):
    color_cmd = {
        "cmd": {
            "name": "color",
            "value": {
                "name": "Color",
                "r": 255,
                "g": 0 if is_busy else 220,
                "b": 0 if is_busy else 110
            }
        }
    }
    brightness_cmd = {
        "cmd": {
            "name": "brightness",
            "value": 1 if is_busy else 100
        }
    }
    data = {
        "device": "REDACTED",
        "model": "H6008",
    }

    session = requests.Session()
    session.headers.clear()  # Clear all default headers

    """
    data.pop("cmd")
    response = requests.get('https://developer-api.govee.com/v1/devices', headers=headers)
    """
    response = session.put(url, headers=headers, json=data | color_cmd)
    response = session.put(url, headers=headers, json=data | brightness_cmd)
    response = requests.get('https://developer-api.govee.com/v1/devices/state', params=data, headers=headers)

    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.text}")

prev_output = 0
cmd = "lsof -i 4UDP | grep zoom | awk 'END{print NR}'"

while (True):
    sleep(5)
    output = subprocess.run(cmd, shell=True, capture_output=True, text=True).stdout

    if prev_output != output:
        prev_output = output
        change_color(int(output) > 1)