package main

import (
	"fmt"
	"github.com/Tinkerforge/go-api-bindings/dust_detector_bricklet"
	"github.com/Tinkerforge/go-api-bindings/ipconnection"
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

	// Get current dust density.
	dustDensity, _ := dd.GetDustDensity()
	fmt.Printf("Dust Density: %d µg/m³\n", dustDensity)

	fmt.Print("Press enter to exit.")
	fmt.Scanln()
}
