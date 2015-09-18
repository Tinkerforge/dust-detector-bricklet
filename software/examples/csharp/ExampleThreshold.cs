using System;
using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change to your UID

	// Callback function for dust density reached callback (parameter has unit µg/m³)
	static void DustDensityReachedCB(BrickletDustDetector sender, int dustDensity)
	{
		Console.WriteLine("Dust Density: " + dustDensity + " µg/m³");
	}

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletDustDetector dd = new BrickletDustDetector(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		dd.SetDebouncePeriod(10000);

		// Register dust density reached callback to function DustDensityReachedCB
		dd.DustDensityReached += DustDensityReachedCB;

		// Configure threshold for dust density "greater than 10 µg/m³" (unit is µg/m³)
		dd.SetDustDensityCallbackThreshold('>', 10, 0);

		Console.WriteLine("Press enter to exit");
		Console.ReadLine();
		ipcon.Disconnect();
	}
}
