function octave_example_threshold()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "ABC"; % Change to your UID

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    dd = java_new("com.tinkerforge.BrickletDustDetector", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Set threshold callbacks with a debounce time of 10 seconds (10000ms)
    dd.setDebouncePeriod(10000);

    % Configure threshold for "greater than 10 µg/cm^3"
    dd.setDustDensityCallbackThreshold(dd.THRESHOLD_OPTION_GREATER, 10, 0);
    
    % Register threshold reached callback to function cb_reached
    dd.addDustDensityReachedCallback(@cb_reached);

    input("Press any key to exit...\n", "s");
    ipcon.disconnect();
end

% Callback function for distance callback (parameter has unit µg/cm^3)
function cb_reached(e)
    fprintf("Dust Density: %g µg/cm^3\n", e.dustDensity);
end
