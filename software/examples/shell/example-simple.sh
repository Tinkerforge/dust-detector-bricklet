#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change to your UID

# Get current dust density (unit is µg/m³)
tinkerforge call dust-detector-bricklet $uid get-dust-density
