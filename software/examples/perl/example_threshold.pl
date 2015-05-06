#!/usr/bin/perl  

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletDustDetector;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'ABC'; # Change to your UID

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $dd = Tinkerforge::BrickletDustDetector->new(&UID, $ipcon); # Create device object

# Callback for dust density greater than 10 µg/cm^3
sub cb_reached
{
    my ($dust_density) = @_;

    print "Dust Density: ".$dust_density." µg/cm^3\n";
}

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$dd->set_debounce_period(10000);

# Register threshold reached callback to function cb_reached
$dd->register_callback($dd->CALLBACK_DUST_DENSITY_REACHED, 'cb_reached');

# Configure threshold for "greater than 10 µg/cm^3"
$dd->set_dust_density_callback_threshold('>', 10, 0);

print "Press any key to exit...\n";
<STDIN>;
$ipcon->disconnect();
