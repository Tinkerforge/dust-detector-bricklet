#!/usr/bin/env python
# -*- coding: utf-8 -*-

HOST = "localhost"
PORT = 4223
UID = "XYZ" # Change XYZ to the UID of your Dust Detector Bricklet

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_dust_detector import BrickletDustDetector

# Callback function for dust density reached callback
def cb_dust_density_reached(dust_density):
    print("Dust Density: " + str(dust_density) + " µg/m³")

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    dd = BrickletDustDetector(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    dd.set_debounce_period(10000)

    # Register dust density reached callback to function cb_dust_density_reached
    dd.register_callback(dd.CALLBACK_DUST_DENSITY_REACHED, cb_dust_density_reached)

    # Configure threshold for dust density "greater than 10 µg/m³"
    dd.set_dust_density_callback_threshold(">", 10, 0)

    raw_input("Press key to exit\n") # Use input() in Python 3
    ipcon.disconnect()
