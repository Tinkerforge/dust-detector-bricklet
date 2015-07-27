import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletDustDetector;

public class ExampleCallback {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;
	private static final String UID = "XYZ"; // Change to your UID

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions you
	//       might normally want to catch are described in the documentation
	public static void main(String args[]) throws Exception {
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletDustDetector dd = new BrickletDustDetector(UID, ipcon); // Create device object

		ipcon.connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Set period for dust density callback to 1s (1000ms)
		// Note: The dust density callback is only called every second
		//       if the dust density has changed since the last call!
		dd.setDustDensityCallbackPeriod(1000);

		// Add dust density listener (parameter has unit µg/m³)
		dd.addDustDensityListener(new BrickletDustDetector.DustDensityListener() {
			public void dustDensity(int dustDensity) {
				System.out.println("Dust Density: " + dustDensity + " µg/m³");
			}
		});

		System.out.println("Press key to exit"); System.in.read();
		ipcon.disconnect();
	}
}
