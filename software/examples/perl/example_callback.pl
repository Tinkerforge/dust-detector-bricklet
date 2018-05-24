#!/usr/bin/perl

use strict;
use Tinkerforge::IPConnection;
use Tinkerforge::BrickletDustDetector;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change XYZ to the UID of your Dust Detector Bricklet

# Callback subroutine for dust density callback
sub cb_dust_density
{
    my ($dust_density) = @_;

    print "Dust Density: $dust_density µg/m³\n";
}

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $dd = Tinkerforge::BrickletDustDetector->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Register dust density callback to subroutine cb_dust_density
$dd->register_callback($dd->CALLBACK_DUST_DENSITY, 'cb_dust_density');

# Set period for dust density callback to 1s (1000ms)
# Note: The dust density callback is only called every second
#       if the dust density has changed since the last call!
$dd->set_dust_density_callback_period(1000);

print "Press key to exit\n";
<STDIN>;
$ipcon->disconnect();
