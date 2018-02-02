function octave_example_threshold()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change XYZ to the UID of your Dust Detector Bricklet

    ipcon = javaObject("com.tinkerforge.IPConnection"); % Create IP connection
    dd = javaObject("com.tinkerforge.BrickletDustDetector", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    dd.setDebouncePeriod(10000);

    % Register dust density reached callback to function cb_dust_density_reached
    dd.addDustDensityReachedCallback(@cb_dust_density_reached);

    % Configure threshold for dust density "greater than 10 µg/m³"
    dd.setDustDensityCallbackThreshold(">", 10, 0);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end

% Callback function for dust density reached callback
function cb_dust_density_reached(e)
    fprintf("Dust Density: %d µg/m³\n", e.dustDensity);
end
