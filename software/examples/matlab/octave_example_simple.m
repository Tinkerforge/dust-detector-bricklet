function octave_example_simple()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change XYZ to the UID of your Dust Detector Bricklet

    ipcon = javaObject("com.tinkerforge.IPConnection"); % Create IP connection
    dd = javaObject("com.tinkerforge.BrickletDustDetector", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current dust density (unit is µg/m³)
    dustDensity = dd.getDustDensity();
    fprintf("Dust Density: %d µg/m³\n", dustDensity);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end
