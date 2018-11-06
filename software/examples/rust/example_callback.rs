use std::{error::Error, io, thread};
use tinkerforge::{dust_detector_bricklet::*, ipconnection::IpConnection};

const HOST: &str = "127.0.0.1";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your Dust Detector Bricklet

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection
    let dust_detector_bricklet = DustDetectorBricklet::new(UID, &ipcon); // Create device object

    ipcon.connect(HOST, PORT).recv()??; // Connect to brickd
                                        // Don't use device before ipcon is connected

    //Create listener for dust density events.
    let dust_density_listener = dust_detector_bricklet.get_dust_density_receiver();
    // Spawn thread to handle received events. This thread ends when the dust_detector_bricklet
    // is dropped, so there is no need for manual cleanup.
    thread::spawn(move || {
        for event in dust_density_listener {
            println!("Dust Density: {}{}", event, " µg/m³");
        }
    });

    // Set period for dust density listener to 1s (1000ms)
    // Note: The dust density callback is only called every second
    //       if the dust density has changed since the last call!
    dust_detector_bricklet.set_dust_density_callback_period(1000);

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
