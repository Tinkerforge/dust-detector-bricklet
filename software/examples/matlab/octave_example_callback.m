function octave_example_callback()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "ABC"; % Change to your UID

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    dd = java_new("com.tinkerforge.BrickletDustDetector", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Set Period for dust density callback to 1s (1000ms)
    % Note: The callback is only called every second if the
    %       dust density has changed since the last call!
    dd.setDustDensityCallbackPeriod(1000);

    % Register dust density callback to function cb_dust_density
    dd.addDustDensityCallback(@cb_dust_density);

    input("Press any key to exit...\n", "s");
    ipcon.disconnect();
end

% Callback function for distance callback (parameter has unit µg/cm^3)
function cb_dust_density(e)
    fprintf("Dust Density: %g µg/cm^3\n", e.dustDensity);
end
