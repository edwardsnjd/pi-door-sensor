pi-door-sensor
==============

This is a simple door sensor integrating with HomeAssistant.

Usage
-----

Install dependencies: `make install`

Check dependencies: `make check`

Set required configuration via environment variables:
```bash
cp .env.sh.example .env.sh
$EDITOR .env.sh    # edit to supply your specific configuration
source .env.sh
```

Start the monitor: `make start`

Tech
----

Python script using `gpiozero` to monitor a GPIO pin and using the HomeAssistant `http` integration to publish state changes.
