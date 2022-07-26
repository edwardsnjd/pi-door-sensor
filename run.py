#!/usr/bin/python3 -u

"""
A script to monitor a switch connected on a particular pin, notifying
HomeAssistant (via an HTTP request) whenever that switch state changes.

This is useful as a door sensor if the attached switch is some sort of
contact or Hall sensor.
"""


from datetime import datetime
from gpiozero import Button
from json import dumps
from os import environ
from requests import post
from signal import pause
from sys import exit


# Read env variables
HA_BASE_URL = environ.get('HA_BASE_URL')
HA_API_TOKEN = environ.get('HA_API_TOKEN')
HA_DEVICE_NAME = environ.get('HA_DEVICE_NAME')
HA_DEVICE_FRIENDLY_NAME = environ.get('HA_DEVICE_FRIENDLY_NAME')
PIN_NUMBER = environ.get('PIN_NUMBER')


# Validate env variables
if  not HA_BASE_URL or \
    not HA_DEVICE_FRIENDLY_NAME or \
    not HA_DEVICE_NAME or \
    not HA_DEVICE_FRIENDLY_NAME or \
    not PIN_NUMBER:
    """Print error and fail"""

    label = lambda value: "✅" if value else "❌"

    print("Error: Missing one or more required environment variables")
    print("HA_BASE_URL: {}".format(label(HA_BASE_URL)))
    print("HA_API_TOKEN: {}".format(label(HA_API_TOKEN)))
    print("HA_DEVICE_NAME: {}".format(label(HA_DEVICE_NAME)))
    print("HA_DEVICE_FRIENDLY_NAME: {}".format(label(HA_DEVICE_FRIENDLY_NAME)))
    print("PIN_NUMBER: {}".format(label(PIN_NUMBER)))

    exit(1)


# Derived constants
URL = "{}/api/states/binary_sensor.{}".format(HA_BASE_URL, HA_DEVICE_NAME)
AUTHORIZATION = "Bearer {}".format(HA_API_TOKEN)


# GPIO wiring

def main():
    button = Button(PIN_NUMBER)

    button.when_pressed = on_closed
    button.when_released = on_opened

    if button.is_pressed:
        on_closed()
    else:
        on_opened()

    pause()


def on_closed():
    print("✅ {}".format(datetime.now()))
    update_homeassistant(True)


def on_opened():
    print("❌ {}".format(datetime.now()))
    update_homeassistant(False)


# HomeAssistant

def update_homeassistant(is_shut):
    payload = build_payload(is_shut)
    response = post(
        URL,
        headers={
            "Authorization": AUTHORIZATION,
            "content-type": "application/json",
        },
        data=dumps(payload),
    )


def build_payload(is_shut):
    state = "on" if is_shut else "off"
    return {
        "state": state,
        "attributes": {
            "friendly_name": HA_DEVICE_FRIENDLY_NAME,
        },
    }


# Entrypoint

if __name__ == '__main__':
    main()
