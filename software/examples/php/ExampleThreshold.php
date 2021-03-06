<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletDustDetector.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletDustDetector;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'XYZ'; // Change XYZ to the UID of your Dust Detector Bricklet

// Callback function for dust density reached callback
function cb_dustDensityReached($dust_density)
{
    echo "Dust Density: $dust_density µg/m³\n";
}

$ipcon = new IPConnection(); // Create IP connection
$dd = new BrickletDustDetector(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$dd->setDebouncePeriod(10000);

// Register dust density reached callback to function cb_dustDensityReached
$dd->registerCallback(BrickletDustDetector::CALLBACK_DUST_DENSITY_REACHED,
                      'cb_dustDensityReached');

// Configure threshold for dust density "greater than 10 µg/m³"
$dd->setDustDensityCallbackThreshold('>', 10, 0);

echo "Press ctrl+c to exit\n";
$ipcon->dispatchCallbacks(-1); // Dispatch callbacks forever

?>
