#!/bin/sh
# connects to localhost:4223 by default, use --host and --port to change it

# change to your UID
uid=ABC

# get current dust density (unit is µg/m³)
tinkerforge call dust-detector-bricklet $uid get-dust-density
