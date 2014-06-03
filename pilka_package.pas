{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit Pilka_Package;

interface

uses
  Board, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('Board', @Board.Register);
end;

initialization
  RegisterPackage('Pilka_Package', @Register);
end.
