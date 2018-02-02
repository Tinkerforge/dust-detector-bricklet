Imports System
Imports Tinkerforge

Module ExampleThreshold
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change XYZ to the UID of your Dust Detector Bricklet

    ' Callback subroutine for dust density reached callback
    Sub DustDensityReachedCB(ByVal sender As BrickletDustDetector, _
                             ByVal dustDensity As Integer)
        Console.WriteLine("Dust Density: " + dustDensity.ToString() + " µg/m³")
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim dd As New BrickletDustDetector(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        dd.SetDebouncePeriod(10000)

        ' Register dust density reached callback to subroutine DustDensityReachedCB
        AddHandler dd.DustDensityReachedCallback, AddressOf DustDensityReachedCB

        ' Configure threshold for dust_density "greater than 10 µg/m³"
        dd.SetDustDensityCallbackThreshold(">"C, 10, 0)

        Console.WriteLine("Press key to exit")
        Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
