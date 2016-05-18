#include <stdio.h>

#include "ip_connection.h"
#include "bricklet_dust_detector.h"

#define HOST "localhost"
#define PORT 4223
#define UID "XYZ" // Change to your UID

// Callback function for dust density reached callback (parameter has unit µg/m³)
void cb_dust_density_reached(uint16_t dust_density, void *user_data) {
	(void)user_data; // avoid unused parameter warning

	printf("Dust Density: %d µg/m³\n", dust_density);
}

int main(void) {
	// Create IP connection
	IPConnection ipcon;
	ipcon_create(&ipcon);

	// Create device object
	DustDetector dd;
	dust_detector_create(&dd, UID, &ipcon);

	// Connect to brickd
	if(ipcon_connect(&ipcon, HOST, PORT) < 0) {
		fprintf(stderr, "Could not connect\n");
		return 1;
	}
	// Don't use device before ipcon is connected

	// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
	dust_detector_set_debounce_period(&dd, 10000);

	// Register dust density reached callback to function cb_dust_density_reached
	dust_detector_register_callback(&dd,
	                                DUST_DETECTOR_CALLBACK_DUST_DENSITY_REACHED,
	                                (void *)cb_dust_density_reached,
	                                NULL);

	// Configure threshold for dust density "greater than 10 µg/m³" (unit is µg/m³)
	dust_detector_set_dust_density_callback_threshold(&dd, '>', 10, 0);

	printf("Press key to exit\n");
	getchar();
	dust_detector_destroy(&dd);
	ipcon_destroy(&ipcon); // Calls ipcon_disconnect internally
	return 0;
}
