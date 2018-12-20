use std::{io, error::Error};
use std::thread;
use tinkerforge::{ip_connection::IpConnection, 
                  dust_detector_bricklet::*};


const HOST: &str = "localhost";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your Dust Detector Bricklet.

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection.
    let dd = DustDetectorBricklet::new(UID, &ipcon); // Create device object.

    ipcon.connect((HOST, PORT)).recv()??; // Connect to brickd.
    // Don't use device before ipcon is connected.

		// Get threshold receivers with a debounce time of 10 seconds (10000ms).
		dd.set_debounce_period(10000);

     let dust_density_reached_receiver = dd.get_dust_density_reached_callback_receiver();

        // Spawn thread to handle received callback messages. 
        // This thread ends when the `dd` object
        // is dropped, so there is no need for manual cleanup.
        thread::spawn(move || {
            for dust_density_reached in dust_density_reached_receiver {           
                		println!("Dust Density: {} µg/m³", dust_density_reached);
            }
        });

		// Configure threshold for dust density "greater than 10 µg/m³".
		dd.set_dust_density_callback_threshold('>', 10, 0);

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
