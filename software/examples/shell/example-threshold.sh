#!/bin/sh
# connects to localhost:4223 by default, use --host and --port to change it

# change to your UID
uid=ABC

# get threshold callbacks with a debounce time of 10 seconds (10000ms)
tinkerforge call dust-detector-bricklet $uid set-debounce-period 10000

# configure threshold for "greater than 10 µg/cm^3"
tinkerforge call dust-detector-bricklet $uid set-dust-density-callback-threshold greater 10 0

# handle incoming dust density-reached callbacks (unit is µg/cm^3)
tinkerforge dispatch dust-detector-bricklet $uid dust-density-reached\
 --execute "echo Dust Density: {dust-density} µg/cm^3"
