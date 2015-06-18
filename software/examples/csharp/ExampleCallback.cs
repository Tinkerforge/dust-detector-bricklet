using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "ABC"; // Change to your UID

	// Callback function for dust density callback (parameter has unit µg/m³)
	static void DustDensityCB(BrickletDustDetector sender, int dustDensity)
	{
		System.Console.WriteLine("Dust Density: " + dustDensity + " µg/m³");
	}

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletDustDetector dd = new BrickletDustDetector(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Set Period for dust density callback to 1s (1000ms)
		// Note: The dust density callback is only called every second if the
		//       dust density has changed since the last call!
		dd.SetDustDensityCallbackPeriod(1000);

		// Register dust density callback to function Dust DensityCB
		dd.DustDensity += DustDensityCB;

		System.Console.WriteLine("Press enter to exit");
		System.Console.ReadLine();
		ipcon.Disconnect();
	}
}
