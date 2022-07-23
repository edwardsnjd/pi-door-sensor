pi-door-sensor
==============

This is a simple door sensor integrating with HomeAssistant.

Usage
-----

Install dependencies: `make install`

Check dependencies: `make check`

Set required configuration via enviroment variables:
```bash
export HA_API_TOKEN=""               # long lived API token from HA
export HA_DEVICE_NAME="garage_door"  # hyphens not permitted
export HA_DEVICE_FRIENDLY_NAME="Garage door sensor"
```

Start the monitor: `make start`

Tech
----

Python script using `gpiozero` to monitor a GPIO pin and using the HomeAssistant `http` integration to publish state changes.
