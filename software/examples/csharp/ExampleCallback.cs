using System;
using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change XYZ to the UID of your Dust Detector Bricklet

	// Callback function for dust density callback (parameter has unit µg/m³)
	static void DustDensityCB(BrickletDustDetector sender, int dustDensity)
	{
		Console.WriteLine("Dust Density: " + dustDensity + " µg/m³");
	}

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletDustDetector dd = new BrickletDustDetector(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Register dust density callback to function DustDensityCB
		dd.DustDensityCallback += DustDensityCB;

		// Set period for dust density callback to 1s (1000ms)
		// Note: The dust density callback is only called every second
		//       if the dust density has changed since the last call!
		dd.SetDustDensityCallbackPeriod(1000);

		Console.WriteLine("Press enter to exit");
		Console.ReadLine();
		ipcon.Disconnect();
	}
}
