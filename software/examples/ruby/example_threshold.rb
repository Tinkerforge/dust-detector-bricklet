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

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
dd.set_debounce_period 10000

# Register dust density reached callback (parameter has unit µg/m³)
dd.register_callback(BrickletDustDetector::CALLBACK_DUST_DENSITY_REACHED) do |dust_density|
  puts "Dust Density: #{dust_density} µg/m³"
end

# Configure threshold for dust density "greater than 10 µg/m³" (unit is µg/m³)
dd.set_dust_density_callback_threshold '>', 10, 0

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
