#!/usr/bin/env python3

"""
A handy util script that assumes there are buttons on all GPIO pins
and logs whenever they are opened or closed.  This is handy because
you can connect a wire directly from any ground pin to each GPIO pin
in turn to confirm that the pin is working by watching for the output
to show a change in the corresponding button.
"""

from gpiozero import Button
from signal import pause
from datetime import datetime


def main():
    pin_numbers = ["GPIO{}".format(id) for id in range(0, 27+1)]
    for pin_number in pin_numbers:
        button = Button(pin_number)
        add_handlers(button)

    pause()


def add_handlers(button):
    button.when_pressed = on_closed
    button.when_released = on_opened

    if button.is_pressed:
        on_closed(button)
    else:
        on_opened(button)


def on_closed(button):
    print("✅ {} {}".format(button.pin.number, datetime.now()))


def on_opened(button):
    print("❌ {} {}".format(button.pin.number, datetime.now()))


if __name__ == '__main__':
    main()
