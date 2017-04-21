#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change XYZ to the UID of your Dust Detector Bricklet

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
tinkerforge call dust-detector-bricklet $uid set-debounce-period 10000

# Handle incoming dust density reached callbacks (parameter has unit µg/m³)
tinkerforge dispatch dust-detector-bricklet $uid dust-density-reached &

# Configure threshold for dust density "greater than 10 µg/m³" (unit is µg/m³)
tinkerforge call dust-detector-bricklet $uid set-dust-density-callback-threshold threshold-option-greater 10 0

echo "Press key to exit"; read dummy

kill -- -$$ # Stop callback dispatch in background
