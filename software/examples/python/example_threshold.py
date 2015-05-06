#!/usr/bin/env python
# -*- coding: utf-8 -*-  

HOST = "localhost"
PORT = 4223
UID = "ABC" # Change to your UID

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_dust_detector import DustDetector

# Callback for dust density greater than 10 µg/cm^3
def cb_reached(dust_density):
    print('Dust Density ' + str(dust_density) + ' µg/cm^3.')

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    dd = DustDetector(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    dd.set_debounce_period(10000)

    # Register threshold reached callback to function cb_reached
    dd.register_callback(dd.CALLBACK_DUST_DENSITY_REACHED, cb_reached)

    # Configure threshold for "greater than 10 µg/cm^3"
    dd.set_dust_density_callback_threshold('>', 10, 0)

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.disconnect()
