#!/usr/bin/perl  

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletDustDetector;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'ABC'; # Change to your UID

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $dd = Tinkerforge::BrickletDustDetector->new(&UID, $ipcon); # Create device object

# Callback function for dust density callback (parameter has unit µg/cm^3)
sub cb_dust_density
{
    my ($dust_density) = @_;

    print "Dust Density: ".$dust_density." µg/cm^3\n";
}

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Set Period for dust density callback to 1s (1000ms)
# Note: The dust density callback is only called every second if the 
#       dust density has changed since the last call!
$dd->set_dust_density_callback_period(1000);

# Register dust density callback to function cb_dust_density
$dd->register_callback($dd->CALLBACK_DUST_DENSITY, 'cb_dust_density');

print "Press any key to exit...\n";
<STDIN>;
$ipcon->disconnect();