# Sanity
# From: https://tech.davis-hansson.com/p/make/

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

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
.PHONY: help

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
