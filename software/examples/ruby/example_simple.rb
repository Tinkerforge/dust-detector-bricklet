#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_dust_detector'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'XYZ' # Change XYZ to the UID of your Dust Detector Bricklet

ipcon = IPConnection.new # Create IP connection
dd = BrickletDustDetector.new UID, ipcon # Create device object

ipcon.connect HOST, PORT # Connect to brickd
# Don't use device before ipcon is connected

# Get current dust density (unit is µg/m³)
dust_density = dd.get_dust_density
puts "Dust Density: #{dust_density} µg/m³"

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
