#!/usr/bin/perl

use strict;
use Tinkerforge::IPConnection;
use Tinkerforge::BrickletDustDetector;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change XYZ to the UID of your Dust Detector Bricklet

# Callback subroutine for dust density reached callback
sub cb_dust_density_reached
{
    my ($dust_density) = @_;

    print "Dust Density: $dust_density µg/m³\n";
}

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $dd = Tinkerforge::BrickletDustDetector->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$dd->set_debounce_period(10000);

# Register dust density reached callback to subroutine cb_dust_density_reached
$dd->register_callback($dd->CALLBACK_DUST_DENSITY_REACHED, 'cb_dust_density_reached');

# Configure threshold for dust density "greater than 10 µg/m³"
$dd->set_dust_density_callback_threshold('>', 10, 0);

print "Press key to exit\n";
<STDIN>;
$ipcon->disconnect();
