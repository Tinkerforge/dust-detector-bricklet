function octave_example_simple()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "ABC"; % Change to your UID

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    dd = java_new("com.tinkerforge.BrickletDustDetector", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current dust density
    dust_density = dd.getDustDensity();

    fprintf("Dust Density: %g µg/m³\n", dust_density);

    input("Press any key to exit...\n", "s");
    ipcon.disconnect();
end
