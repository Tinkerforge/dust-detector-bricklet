using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "ABC"; // Change to your UID

	// Callback for dust density greater than 10 µg/cm^3
	static void ReachedCB(BrickletDustDetector sender, int dustDensity)
	{
		System.Console.WriteLine("Dust Density " + dustDensity + " µg/cm^3.");
	}

	static void Main() 
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletDustDetector dd = new BrickletDustDetector(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		dd.SetDebouncePeriod(10000);

		// Register threshold reached callback to function ReachedCB
		dd.DustDensityReached += ReachedCB;

		// Configure threshold for "greater than 10 µg/cm^3"
		dd.SetDustDensityCallbackThreshold('>', 10, 0);

		System.Console.WriteLine("Press enter to exit");
		System.Console.ReadLine();
		ipcon.Disconnect();
	}
}
