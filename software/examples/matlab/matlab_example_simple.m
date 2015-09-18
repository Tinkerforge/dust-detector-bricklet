function matlab_example_simple()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletDustDetector;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'XYZ'; % Change to your UID

    ipcon = IPConnection(); % Create IP connection
    dd = BrickletDustDetector(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current dust density (unit is µg/m³)
    dustDensity = dd.getDustDensity();
    fprintf('Dust Density: %i µg/m³\n', dustDensity);

    input('Press key to exit\n', 's');
    ipcon.disconnect();
end
