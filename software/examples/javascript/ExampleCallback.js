var Tinkerforge = require('tinkerforge');

var HOST = 'localhost';
var PORT = 4223;
var UID = 'XYZ'; // Change XYZ to the UID of your Dust Detector Bricklet

var ipcon = new Tinkerforge.IPConnection(); // Create IP connection
var dd = new Tinkerforge.BrickletDustDetector(UID, ipcon); // Create device object

ipcon.connect(HOST, PORT,
    function (error) {
        console.log('Error: ' + error);
    }
); // Connect to brickd
// Don't use device before ipcon is connected

ipcon.on(Tinkerforge.IPConnection.CALLBACK_CONNECTED,
    function (connectReason) {
        // Set period for dust density callback to 1s (1000ms)
        // Note: The dust density callback is only called every second
        //       if the dust density has changed since the last call!
        dd.setDustDensityCallbackPeriod(1000);
    }
);

// Register dust density callback
dd.on(Tinkerforge.BrickletDustDetector.CALLBACK_DUST_DENSITY,
    // Callback function for dust density callback
    function (dustDensity) {
        console.log('Dust Density: ' + dustDensity + ' µg/m³');
    }
);

console.log('Press key to exit');
process.stdin.on('data',
    function (data) {
        ipcon.disconnect();
        process.exit(0);
    }
);
