function matlab_example_simple()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletDustDetector;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'XYZ'; % Change XYZ to the UID of your Dust Detector Bricklet

    ipcon = IPConnection(); % Create IP connection
    dd = handle(BrickletDustDetector(UID, ipcon), 'CallbackProperties'); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current dust density
    dustDensity = dd.getDustDensity();
    fprintf('Dust Density: %i µg/m³\n', dustDensity);

    input('Press key to exit\n', 's');
    ipcon.disconnect();
end
