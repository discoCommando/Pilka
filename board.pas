unit Board;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
  TBoard = class(TImage)
  private
    { Private declarations }
    rects: array [0..899] of TRect;
    procedure drawGround(x, y: integer);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create();
    procedure setSize(x, y: integer);
  published
    { Published declarations }
  end;

procedure Register;

implementation

constructor TBoard.Create();
begin

end;

procedure Register;
begin
  RegisterComponents('Additional', [TBoard]);
end;

procedure TBoard.setSize(x, y: integer);
begin
  self.drawGround(x, y);
end;

procedure TBoard.drawGround(x, y: integer);
var
  counterX, counterY: integer;
begin
  self.Height := x + 10;
  self.Width := y + 10;
  self.Visible := True;
  counterX := 0;
  counterY := 0;
  rects[0]:= self.BoundsRect;
  self.Canvas.Rectangle(rects[0]);
end;

end.
