<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletDustDetector.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletDustDetector;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'XYZ'; // Change XYZ to the UID of your Dust Detector Bricklet

// Callback function for dust density callback (parameter has unit µg/m³)
function cb_dustDensity($dust_density)
{
    echo "Dust Density: $dust_density µg/m³\n";
}

$ipcon = new IPConnection(); // Create IP connection
$dd = new BrickletDustDetector(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Register dust density callback to function cb_dustDensity
$dd->registerCallback(BrickletDustDetector::CALLBACK_DUST_DENSITY, 'cb_dustDensity');

// Set period for dust density callback to 1s (1000ms)
// Note: The dust density callback is only called every second
//       if the dust density has changed since the last call!
$dd->setDustDensityCallbackPeriod(1000);

echo "Press ctrl+c to exit\n";
$ipcon->dispatchCallbacks(-1); // Dispatch callbacks forever

?>
