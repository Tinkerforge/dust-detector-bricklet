program ExampleSimple;

{$ifdef MSWINDOWS}{$apptype CONSOLE}{$endif}
{$ifdef FPC}{$mode OBJFPC}{$H+}{$endif}

uses
  SysUtils, IPConnection, BrickletDustDetector;

type
  TExample = class
  private
    ipcon: TIPConnection;
    dd: TBrickletDustDetector;
  public
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = 'ABC'; { Change to your UID }

var
  e: TExample;

procedure TExample.Execute;
var dustDensity: word;
begin
  { Create IP connection }
  ipcon := TIPConnection.Create;

  { Create device object }
  dd := TBrickletDustDetector.Create(UID, ipcon);

  { Connect to brickd }
  ipcon.Connect(HOST, PORT);
  { Don't use device before ipcon is connected }

  { Get current dust density (unit is µg/cm^3) }
  dustDensity := dd.GetDustDensity;
  WriteLn(Format('Dust Density: %d µg/cm^3', [dustDensity]));

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy; { Calls ipcon.Disconnect internally }
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.
