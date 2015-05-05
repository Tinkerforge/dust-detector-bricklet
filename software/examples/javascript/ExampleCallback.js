var Tinkerforge = require('tinkerforge');

var HOST = 'localhost';
var PORT = 4223;
var UID = 'ABC'; // Change to your UID

var ipcon = new Tinkerforge.IPConnection(); // Create IP connection
var al = new Tinkerforge.BrickletDustDetector(UID, ipcon); // Create device object

ipcon.connect(HOST, PORT,
    function(error) {
        console.log('Error: '+error);
    }
); // Connect to brickd
// Don't use device before ipcon is connected

ipcon.on(Tinkerforge.IPConnection.CALLBACK_CONNECTED,
    function(connectReason) {
        // Set Period for dust density callback to 1s (1000ms)
        // Note: The dust density callback is only called every second if the
        // dust density has changed since the last call!
        al.setDustDensityCallbackPeriod(1000);
    }
);

// Register position callback
al.on(Tinkerforge.BrickletDustDetector.CALLBACK_DUST_DENSITY,
    // Callback function for dust density callback (parameter has unit µg/cm^3)
    function(dustDensity) {
        console.log('Dust Density: '+dustDensity+' µg/cm^3');
    }
);

console.log("Press any key to exit ...");
process.stdin.on('data',
    function(data) {
        ipcon.disconnect();
        process.exit(0);
    }
);
