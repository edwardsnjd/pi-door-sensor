# Sanity
# From: https://tech.davis-hansson.com/p/make/

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# SystemD

PWD := $(shell pwd)
SERVICE_UNIT_FILE := pi-door-sensor.service

# Targets

start:
	@echo "Starting door monitor"
	@./run.py
.PHONY: start

help:
	@echo "Targets:"
	@echo "- start (default) = start the monitor"
	@echo "- help = print this help"
	@echo "- check = check dependencies are available"
	@echo "- install = install all dependencies"
	@echo "- service-status = check systemd service status"
	@echo "- service-install = install systemd service"
	@echo "- service-start = start systemd service"
	@echo "- service-stop = stop systemd service"
	@echo "- service-uninstall = uninstall systemd service"
.PHONY: help

# Application dependencies

check:
	@echo "Checking dependencies"
	@which python3 > /dev/null && {
		@echo "OK: 'python3'"
	} || {
		@echo "ERROR: Missing 'python3'"
		@exit
	}
	@which pip3 > /dev/null  && {
		@echo "OK: 'pip3'"
	} || {
		@echo "ERROR: Missing 'pip3'"
		@exit
	}
	@pip3 show gpiozero > /dev/null  && {
		@echo "OK: 'gpiozero'"
	} || {
		@echo "ERROR: Missing package 'gpiozero'"
		@exit
	}
	@pip3 show requests > /dev/null  && {
		@echo "OK: 'requests'"
	} || {
		@echo "ERROR: Missing package 'requests'"
		@exit
	}
.PHONY: check

install:
	@echo "Installing dependencies"
	@sudo apt-get update
	@which python3 > /dev/null && {
		@echo "OK: 'python3'"
	} || {
		@echo "Installing: python3"
		sudo apt-get install python3
	}
	@which pip3 > /dev/null  && {
		@echo "OK: 'pip3'"
	} || {
		@echo "Installing: pip3"
		sudo apt-get install python3-pip
	}
	@pip3 show gpiozero > /dev/null  && {
		@echo "OK: 'gpiozero'"
	} || {
		@echo "Installing: gpiozero"
		sudo apt-get install python3-gpiozero
	}
	@pip3 show requests > /dev/null  && {
		@echo "OK: 'requests'"
	} || {
		@echo "Installing: requests"
		sudo apt-get install python3-requests
	}
.PHONY: install

# SystemD service

service-status:
	sudo systemctl status ${SERVICE_UNIT_FILE}
.PHONY: service-status

service-install:
	sudo systemctl link ${PWD}/${SERVICE_UNIT_FILE}
	sudo systemctl enable ${SERVICE_UNIT_FILE}
.PHONY: service-install

service-start:
	sudo systemctl start ${SERVICE_UNIT_FILE}
.PHONY: service-start

service-stop:
	sudo systemctl stop ${SERVICE_UNIT_FILE}
.PHONY: service-disable

service-uninstall:
	sudo systemctl disable ${SERVICE_UNIT_FILE}
.PHONY: service-uninstall
