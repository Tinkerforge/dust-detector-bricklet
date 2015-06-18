import com.tinkerforge.BrickletDustDetector;
import com.tinkerforge.IPConnection;

public class ExampleSimple {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;
	private static final String UID = "ABC"; // Change to your UID

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions you
	//       might normally want to catch are described in the documentation
	public static void main(String args[]) throws Exception {
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletDustDetector dd = new BrickletDustDetector(UID, ipcon); // Create device object

		ipcon.connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get current dust density (unit is µg/m³)
		int dustDensity = dd.getDustDensity(); // Can throw com.tinkerforge.TimeoutException

		System.out.println("Dust Density: " + dustDensity + " µg/m³");

		System.out.println("Press key to exit"); System.in.read();
		ipcon.disconnect();
	}
}
