#!/bin/sh
# connects to localhost:4223 by default, use --host and --port to change it

# change to your UID
uid=ABC

# set period for dust density callback to 1s (1000ms)
# note: the dust density callback is only called every second if the
#       dust density has changed since the last call!
tinkerforge call dust-detector-bricklet $uid set-dust-density-callback-period 1000

# handle incoming dust density callbacks (unit is µg/cm^3)
tinkerforge dispatch dust-detector-bricklet $uid dust-density
