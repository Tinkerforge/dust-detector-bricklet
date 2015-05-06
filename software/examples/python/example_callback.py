#!/usr/bin/env python
# -*- coding: utf-8 -*-  

HOST = "localhost"
PORT = 4223
UID = "ABC" # Change to your UID

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_dust_detector import DustDetector

# Callback function for dust density callback (parameter has unit µg/cm^3)
def cb_dust_density(dust_density):
    print('Dust Density: ' + str(dust_density) + ' µg/cm^3')

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    dd = DustDetector(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Set Period for dust density callback to 1s (1000ms)
    # Note: The dust density callback is only called every second if the 
    #       dust density has changed since the last call!
    dd.set_dust_density_callback_period(1000)

    # Register dust density callback to function cb_dust_density
    dd.register_callback(dd.CALLBACK_DUST_DENSITY, cb_dust_density)

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.disconnect()
