var Tinkerforge = require('tinkerforge');

var HOST = 'localhost';
var PORT = 4223;
var UID = 'ABC'; // Change to your UID

var ipcon = new Tinkerforge.IPConnection(); // Create IP connection
var dd = new Tinkerforge.BrickletDustDetector(UID, ipcon); // Create device object

ipcon.connect(HOST, PORT,
    function(error) {
        console.log('Error: '+error);
    }
); // Connect to brickd
// Don't use device before ipcon is connected

ipcon.on(Tinkerforge.IPConnection.CALLBACK_CONNECTED,
    function(connectReason) {
        // Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        dd.setDebouncePeriod(10000);
        // Configure threshold for "greater than 10 µg/cm^3"
        dd.setDustDensityCallbackThreshold('>', 10, 0);
    }
);

// Register threshold reached callback to function cb_reached
dd.on(Tinkerforge.BrickletDustDetector.CALLBACK_DUST_DENSITY_REACHED,
    // Callback for dust density greater than 10 µg/cm^3
    function(dustDensity) {
        console.log('Dust Density ' + dustDensity + ' µg/cm^3.');
    }
);

console.log("Press any key to exit ...");
process.stdin.on('data',
    function(data) {
        ipcon.disconnect();
        process.exit(0);
    }
);
