#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_dust_detector'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'ABC' # Change to your UID

ipcon = IPConnection.new # Create IP connection
dd = BrickletDustDetector.new UID, ipcon # Create device object

ipcon.connect HOST, PORT # Connect to brickd
# Don't use device before ipcon is connected

# Set Period for dust density callback to 1s (1000ms)
# Note: The dust density callback is only called every second if the 
#       dust density has changed since the last call!
dd.set_dust_density_callback_period 1000

# Register dust density callback (parameter has unit µg/cm^3)
dd.register_callback(BrickletDustDetector::CALLBACK_DUST_DENSITY) do |dust_density|
  puts "Dust Density: #{dust_density} µg/cm^3"
end

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
