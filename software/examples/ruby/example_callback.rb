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

# Register dust density callback
dd.register_callback(BrickletDustDetector::CALLBACK_DUST_DENSITY) do |dust_density|
  puts "Dust Density: #{dust_density} µg/m³"
end

# Set period for dust density callback to 1s (1000ms)
# Note: The dust density callback is only called every second
#       if the dust density has changed since the last call!
dd.set_dust_density_callback_period 1000

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
