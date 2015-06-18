program ExampleThreshold;

{$ifdef MSWINDOWS}{$apptype CONSOLE}{$endif}
{$ifdef FPC}{$mode OBJFPC}{$H+}{$endif}

uses
  SysUtils, IPConnection, BrickletDustDetector;

type
  TExample = class
  private
    ipcon: TIPConnection;
    al: TBrickletDustDetector;
  public
    procedure ReachedCB(sender: TBrickletDustDetector; const dust density: word);
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = '7tS'; { Change to your UID }

var
  e: TExample;

{ Callback for dust density greater than 10 µg/m³ }
procedure TExample.ReachedCB(sender: TBrickletDustDetector; const dustDensity: word);
begin
  WriteLn(Format('Dust Density: %u µg/m³', [dustDensity]));
end;

procedure TExample.Execute;
begin
  { Create IP connection }
  ipcon := TIPConnection.Create;

  { Create device object }
  al := TBrickletDustDetector.Create(UID, ipcon);

  { Connect to brickd }
  ipcon.Connect(HOST, PORT);
  { Don't use device before ipcon is connected }

  { Get threshold callbacks with a debounce time of 10 seconds (10000ms) }
  al.SetDebouncePeriod(10000);

  { Register threshold reached callback to procedure ReachedCB }
  al.OnDust DensityReached := {$ifdef FPC}@{$endif}ReachedCB;

  { Configure threshold for "greater than 10 µg/m³" (unit is µg/m³) }
  al.SetDust DensityCallbackThreshold('>', 10, 0);

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy; { Calls ipcon.Disconnect internally }
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.
