Imports Tinkerforge

Module ExampleThreshold
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "ABC" ' Change to your UID

    ' Callback for dust density greater than 10 µg/cm^3
    Sub ReachedCB(ByVal sender As BrickletDustDetector, ByVal dustDensity As Integer)
        System.Console.WriteLine("Dust Density " + dustDensity.ToString() + " µg/cm^3.")
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim dd As New BrickletDustDetector(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        dd.SetDebouncePeriod(10000)

        ' Register threshold reached callback to function ReachedCB
        AddHandler dd.DustDensityReached, AddressOf ReachedCB

        ' Configure threshold for "greater than 10 µg/cm^3"
        dd.SetDustDensityCallbackThreshold(">"C, 10, 0)

        System.Console.WriteLine("Press key to exit")
        System.Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
