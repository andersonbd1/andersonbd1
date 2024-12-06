import requests
import subprocess
from time import sleep

url = 'https://developer-api.govee.com/v1/devices/control'

headers = {
    'Govee-API-Key': 'e1ec4b9b-6387-4ed0-8ec7-53cb914f8625',
    'accept': 'application/json',
    'content-type': 'application/json'
}

data = {
    "device": "22:F4:D0:C9:07:00:23:A8",
    "model": "H6008",
    "cmd": {
        "name": "colorTem",
        "value": 3000
    }
}

session = requests.Session()
session.headers.clear()  # Clear all default headers

#response = session.put(url, headers=headers, json=data)
response = requests.get('https://developer-api.govee.com/v1/devices/state', params=data, headers=headers)

print(f"Status Code: {response.status_code}")
print(f"Response: {response.text}")
