#!/usr/bin/env python
# -*- coding: utf-8 -*-  

HOST = "localhost"
PORT = 4223
UID = "XYZ" # Change to your UID

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_dust_detector import DustDetector

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    dd = DustDetector(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Get current dust density (unit is µg/m³)
    dust_density = dd.get_dust_density()

    print('Dust Density: ' + str(dust_density) + ' µg/m³')

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.disconnect()
