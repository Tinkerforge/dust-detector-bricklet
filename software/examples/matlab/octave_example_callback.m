function octave_example_callback()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change XYZ to the UID of your Dust Detector Bricklet

    ipcon = javaObject("com.tinkerforge.IPConnection"); % Create IP connection
    dd = javaObject("com.tinkerforge.BrickletDustDetector", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Register dust density callback to function cb_dust_density
    dd.addDustDensityCallback(@cb_dust_density);

    % Set period for dust density callback to 1s (1000ms)
    % Note: The dust density callback is only called every second
    %       if the dust density has changed since the last call!
    dd.setDustDensityCallbackPeriod(1000);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end

% Callback function for dust density callback (parameter has unit µg/m³)
function cb_dust_density(e)
    fprintf("Dust Density: %d µg/m³\n", e.dustDensity);
end
