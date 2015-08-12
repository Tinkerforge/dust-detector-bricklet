#include <stdio.h>

#include "ip_connection.h"
#include "bricklet_dust_detector.h"

#define HOST "localhost"
#define PORT 4223
#define UID "XYZ" // Change to your UID

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

	// Get current dust density (unit is µg/m³)
	uint16_t dust_density;
	if(dust_detector_get_dust_density(&dd, &dust_density) < 0) {
		fprintf(stderr, "Could not get dust density, probably timeout\n");
		return 1;
	}

	printf("Dust Density: %d µg/m³\n", dust_density);

	printf("Press key to exit\n");
	getchar();
	ipcon_destroy(&ipcon); // Calls ipcon_disconnect internally
	return 0;
}
