package main

import (
	"fmt"
	"tinkerforge/dust_detector_bricklet"
	"tinkerforge/ipconnection"
)

const ADDR string = "localhost:4223"
const UID string = "XYZ" // Change XYZ to the UID of your Dust Detector Bricklet.

func main() {
	ipcon := ipconnection.New()
	defer ipcon.Close()
	dd, _ := dust_detector_bricklet.New(UID, &ipcon) // Create device object.

	ipcon.Connect(ADDR) // Connect to brickd.
	defer ipcon.Disconnect()
	// Don't use device before ipcon is connected.

	dd.RegisterDustDensityCallback(func(dustDensity uint16) {
		fmt.Printf("Dust Density: %d µg/m³\n", dustDensity)
	})

	// Set period for dust density receiver to 1s (1000ms).
	// Note: The dust density callback is only called every second
	//       if the dust density has changed since the last call!
	dd.SetDustDensityCallbackPeriod(1000)

	fmt.Print("Press enter to exit.")
	fmt.Scanln()

}
