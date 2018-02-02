#!/usr/bin/env python
# -*- coding: utf-8 -*-

HOST = "localhost"
PORT = 4223
UID = "XYZ" # Change XYZ to the UID of your Dust Detector Bricklet

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_dust_detector import BrickletDustDetector

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    dd = BrickletDustDetector(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Get current dust density
    dust_density = dd.get_dust_density()
    print("Dust Density: " + str(dust_density) + " µg/m³")

    raw_input("Press key to exit\n") # Use input() in Python 3
    ipcon.disconnect()
