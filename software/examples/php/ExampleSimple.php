<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletDustDetector.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletDustDetector;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'XYZ'; // Change to your UID

$ipcon = new IPConnection(); // Create IP connection
$dd = new BrickletDustDetector(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Get current dust density (unit is µg/m³)
$dust_density = $dd->getDustDensity();
echo "Dust Density: $dust_density µg/m³\n";

echo "Press key to exit\n";
fgetc(fopen('php://stdin', 'r'));
$ipcon->disconnect();

?>
