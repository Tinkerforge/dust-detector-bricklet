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

	// Get threshold receivers with a debounce time of 10 seconds (10000ms).
	dd.SetDebouncePeriod(10000)

	dd.RegisterDustDensityReachedCallback(func(dustDensity uint16) {
		fmt.Printf("Dust Density: %d µg/m³\n", dustDensity)
	})

	// Configure threshold for dust density "greater than 10 µg/m³".
	dd.SetDustDensityCallbackThreshold('>', 10, 0)

	fmt.Print("Press enter to exit.")
	fmt.Scanln()

}
