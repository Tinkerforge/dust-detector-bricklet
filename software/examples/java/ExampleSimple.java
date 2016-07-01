import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletDustDetector;

public class ExampleSimple {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;

	// Change XYZ to the UID of your Dust Detector Bricklet
	private static final String UID = "XYZ";

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions
	//       you might normally want to catch are described in the documentation
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
