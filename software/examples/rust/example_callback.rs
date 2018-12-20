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

     let dust_density_receiver = dd.get_dust_density_callback_receiver();

        // Spawn thread to handle received callback messages. 
        // This thread ends when the `dd` object
        // is dropped, so there is no need for manual cleanup.
        thread::spawn(move || {
            for dust_density in dust_density_receiver {           
                		println!("Dust Density: {} µg/m³", dust_density);
            }
        });

		// Set period for dust density receiver to 1s (1000ms).
		// Note: The dust density callback is only called every second
		//       if the dust density has changed since the last call!
		dd.set_dust_density_callback_period(1000);

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
