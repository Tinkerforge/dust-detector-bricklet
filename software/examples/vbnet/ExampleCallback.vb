Imports Tinkerforge

Module ExampleCallback
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "ABC" ' Change to your UID

    ' Callback function for dust density callback (parameter has unit µg/m³)
    Sub DustDensityCB(ByVal sender As BrickletDustDetector, ByVal dustDensity As Integer)
        System.Console.WriteLine("Dust Density: " + dustDensity.ToString() + " µg/m³")
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim dd As New BrickletDustDetector(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Set Period for dust density callback to 1s (1000ms)
        ' Note: The dust density callback is only called every second if the
        '       dust density has changed since the last call!
        dd.SetDustDensityCallbackPeriod(1000)

        ' Register dust density callback to function Dust DensityCB
        AddHandler dd.DustDensity, AddressOf DustDensityCB

        System.Console.WriteLine("Press key to exit")
        System.Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
