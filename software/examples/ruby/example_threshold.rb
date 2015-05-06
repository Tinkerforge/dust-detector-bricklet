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

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
dd.set_debounce_period 10000

# Register threshold reached callback for dust density greater than 10 µg/cm^3
dd.register_callback(BrickletDustDetector::CALLBACK_DUST_DENSITY_REACHED) do |dust_density|
  puts "Dust Density #{dust_density} µg/cm^3."
end

# Configure threshold for "greater than 10 µg/cm^3"
dd.set_dust_density_callback_threshold '>', 10, 0

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect