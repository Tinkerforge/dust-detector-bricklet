<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletDustDetector.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletDustDetector;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'ABC'; // Change to your UID

// Callback function for dust density callback (parameter has unit µg/cm^3)
function cb_dust_density($dust_density)
{
    echo "Dust Density: " . $dust_density . " µg/cm^3\n";
}

$ipcon = new IPConnection(); // Create IP connection
$dd = new BrickletDustDetector(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Set Period for dust density callback to 1s (1000ms)
// Note: The dust density callback is only called every second if the
//       dust density has changed since the last call!
$dd->setDustDensityCallbackPeriod(1000);

// Register dust density callback to function cb_dust density
$dd->registerCallback(BrickletDustDetector::CALLBACK_DUST_DENSITY, 'cb_dust_density');

echo "Press ctrl+c to exit\n";
$ipcon->dispatchCallbacks(-1); // Dispatch callbacks forever

?>
