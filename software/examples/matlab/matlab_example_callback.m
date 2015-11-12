function matlab_example_callback()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletDustDetector;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'XYZ'; % Change to your UID

    ipcon = IPConnection(); % Create IP connection
    dd = handle(BrickletDustDetector(UID, ipcon), 'CallbackProperties'); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Register dust density callback to function cb_dust_density
    set(dd, 'DustDensityCallback', @(h, e) cb_dust_density(e));

    % Set period for dust density callback to 1s (1000ms)
    % Note: The dust density callback is only called every second
    %       if the dust density has changed since the last call!
    dd.setDustDensityCallbackPeriod(1000);

    input('Press key to exit\n', 's');
    ipcon.disconnect();
end

% Callback function for dust density callback (parameter has unit µg/m³)
function cb_dust_density(e)
    fprintf('Dust Density: %i µg/m³\n', e.dustDensity);
end
