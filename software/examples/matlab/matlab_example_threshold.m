function matlab_example_threshold()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletDustDetector;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'ABC'; % Change to your UID

    ipcon = IPConnection(); % Create IP connection
    dd = BrickletDustDetector(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Set threshold callbacks with a debounce time of 10 seconds (10000ms)
    dd.setDebouncePeriod(10000);

    % Register threshold reached callback to function cb_reached
    set(dd, 'DustDensityReachedCallback', @(h, e) cb_reached(e));

    % Configure threshold for "greater than 10 µg/cm^3"
    dd.setDustDensityCallbackThreshold('>', 10, 0);

    input('Press any key to exit...\n', 's');
    ipcon.disconnect();
end

% Callback for distance greater than 20 cm
function cb_reached(e)
    fprintf('Dust Density: %g µg/cm^3\n', e.dustDensity);
end
