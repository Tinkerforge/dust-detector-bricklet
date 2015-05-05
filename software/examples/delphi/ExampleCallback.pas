program ExampleCallback;

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
    procedure DustDensityCB(sender: TBrickletDustDetector; const dustDensity: word);
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = 'ABC'; { Change to your UID }

var
  e: TExample;

{ Callback function for dust density callback (parameter has unit µg/cm^3) }
procedure TExample.DustDensityCB(sender: TBrickletDustDetector; const dustDensity: word);
begin
  WriteLn(Format('Dust Density: %d µg/cm^3', [dustDensity]));
end;

procedure TExample.Execute;
begin
  { Create IP connection }
  ipcon := TIPConnection.Create;

  { Create device object }
  dd := TBrickletDustDetector.Create(UID, ipcon);

  { Connect to brickd }
  ipcon.Connect(HOST, PORT);
  { Don't use device before ipcon is connected }

  { Set Period for dust density callback to 1s (1000ms)
    Note: The dust density callback is only called every second if the
          dust density has changed since the last call! }
  dd.SetDustDensityCallbackPeriod(1000);

  { Register dust density callback to procedure DustDensityCB }
  dd.OnDustDensity := {$ifdef FPC}@{$endif}DustDensityCB;

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy; { Calls ipcon.Disconnect internally }
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.
