Imports System
Imports Tinkerforge

Module ExampleSimple
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change XYZ to the UID of your Dust Detector Bricklet

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim dd As New BrickletDustDetector(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get current dust density
        Dim dustDensity As Integer = dd.GetDustDensity()
        Console.WriteLine("Dust Density: " + dustDensity.ToString() + " µg/m³")

        Console.WriteLine("Press key to exit")
        Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
