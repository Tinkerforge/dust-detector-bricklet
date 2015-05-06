function matlab_example_simple()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletDustDetector;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'ABC'; % Change to your UID

    ipcon = IPConnection(); % Create IP connection
    dd = BrickletDustDetector(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

	% Get current dust density
	dust_density = dd.getDustDensity();
    
    fprintf('Dust Density: %g µg/cm^3\n', dust_density);

    input('Press any key to exit...\n', 's');
    ipcon.disconnect();
end