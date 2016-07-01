#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change XYZ to the UID of your Dust Detector Bricklet

# Handle incoming dust density callbacks (parameter has unit µg/m³)
tinkerforge dispatch dust-detector-bricklet $uid dust-density &

# Set period for dust density callback to 1s (1000ms)
# Note: The dust density callback is only called every second
#       if the dust density has changed since the last call!
tinkerforge call dust-detector-bricklet $uid set-dust-density-callback-period 1000

echo "Press key to exit"; read dummy

kill -- -$$ # Stop callback dispatch in background
