#!/usr/bin/perl  

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletDustDetector;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'ABC'; # Change to your UID

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $dd = Tinkerforge::BrickletDustDetector->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get current dust density (unit is µg/cm^3)
my $dust_density = $dd->get_dust_density();
print "Dust Density: $dust_density µg/cm^3\n";

print "Press any key to exit...\n";
<STDIN>;
$ipcon->disconnect();
