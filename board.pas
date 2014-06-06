unit Board;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  glib2, BoardRepresentation;

type
  TBoard = class(TImage)
  private
    { Private declarations }
    rects: array [0..1599] of TRect;
    procedure drawRects(x, y: integer);  //rozmiary planszy
    procedure drawGround(x, y: integer); //rozmiary planszy
    procedure drawLines(x, y: integer); //rysowanie granic boiska
    procedure drawBall(x, y: integer; col: TColor); //x, y względem boiska
    procedure drawBall(x, y: integer); //x, y względem boiska
    procedure drawRect(x, y: integer); //x, y względem boiska
    //x ,y względem boiska, ruch pilki do punktu x, y
    procedure drawLine(x, y: integer; col: TColor);//x ,y względem boiska
    procedure drawLine(fromx, fromy, tox, toy: integer; col: TColor);
    procedure test();
    procedure drawTBoardPoint(var pt: TBoardPoint; x, y: integer);
  const
    RECT_SIZE = 38;
    BALL_RADIUS = 3;
  protected
    { Protected declarations }
  public
    { Public declarations }
    lastBallPosX: integer;
    lastBallPosY: integer;
    sizeX: integer;
    sizeY: integer;
    myBoardRep: TBoardRep;
    constructor Create(AOwner: TComponent); override;
    procedure setSize(x, y: integer);
    procedure makeMove(x, y, playerNo: integer); //x ,y - wspolrzedne punktu docelowego
    procedure drawFromBR(var rep: TBoardRep);
    function giveClickedPoint(): TPoint; //daje współrzędne punktu
  published
    { Published declarations }
  end;

procedure Register;

implementation

constructor TBoard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  self.Top := 0;
end;

procedure Register;
begin
  RegisterComponents('Additional', [TBoard]);
end;

procedure TBoard.setSize(x, y: integer);
begin
  sizeX := x;
  sizeY := y;
  self.drawGround(x, y);
  self.drawRects(x, y);
  self.drawLines(x, y);
  self.lastBallPosX := x div 2;
  self.lastBallPosY := y div 2;
  self.drawBall(x div 2, y div 2);
end;

procedure TBoard.drawGround(x, y: integer);
begin
  self.Height := (x + 2) * RECT_SIZE;
  self.Width := (y + 4) * RECT_SIZE;
  self.SetBounds(0, 0, (x + 2) * RECT_SIZE, (y + 4) * RECT_SIZE);
  self.Paint;
  self.Update;
  self.Canvas.Pen.Color := clGreen;
  self.Canvas.Rectangle(self.BoundsRect);
  self.Canvas.Brush.Color := clGreen;
  self.Canvas.FillRect(self.BoundsRect);
end;

procedure TBoard.drawRects(x, y: integer);
var
  counterX, counterY, counter: integer;
begin

  counterX := 0;
  counterY := 0;
  counter := 0;
  self.Canvas.Brush.Color := $000C600C;
  for counterX := 0 to x + 2 do
  begin
    for counterY := 0 to y + 4 do
    begin
      rects[counter] := Rect(counterX * (RECT_SIZE) + 1, counterY *
        (RECT_SIZE) + 1, (counterX + 1) * (RECT_SIZE) - 1, (counterY + 1) *
        (RECT_SIZE) - 1);

      self.Canvas.FillRect(rects[counter]);
      counter := counter + 1;
    end;
  end;
end;

procedure TBoard.drawLines(x, y: integer);
begin
  self.Canvas.Pen.Color := clWhite;
  self.Canvas.Pen.Width := 3;
  //bok lewy
  self.Canvas.Line(RECT_SIZE, 2 * RECT_SIZE, RECT_SIZE, (y + 2) * RECT_SIZE);
  //bok prawy
  self.Canvas.Line(RECT_SIZE * (x + 1), 2 * RECT_SIZE,
    RECT_SIZE * (x + 1), (y + 2) * RECT_SIZE);
  //górne krawędzie
  self.Canvas.Line(RECT_SIZE, 2 * RECT_SIZE, RECT_SIZE * (x div 2), 2 * RECT_SIZE);
  self.Canvas.Line(RECT_SIZE * (x div 2 + 2), 2 * RECT_SIZE, RECT_SIZE *
    (x + 1), 2 * RECT_SIZE);
  //górna bramka
  self.Canvas.Line(RECT_SIZE * (x div 2), RECT_SIZE,
    RECT_SIZE * (x div 2 + 2), RECT_SIZE);
  self.Canvas.Line(RECT_SIZE * (x div 2), RECT_SIZE,
    RECT_SIZE * (x div 2), RECT_SIZE * 2);
  self.Canvas.Line(RECT_SIZE * (x div 2 + 2), RECT_SIZE,
    RECT_SIZE * (x div 2 + 2), RECT_SIZE * 2);
  //dolne krawędzie
  self.Canvas.Line(RECT_SIZE, (y + 2) * RECT_SIZE,
    RECT_SIZE * (x div 2), (y + 2) * RECT_SIZE);
  self.Canvas.Line(RECT_SIZE * (x div 2 + 2), (y + 2) * RECT_SIZE,
    RECT_SIZE * (x + 1), (y + 2) * RECT_SIZE);
  //dolna bramka
  self.Canvas.Line(RECT_SIZE * (x div 2), RECT_SIZE * (y + 3),
    RECT_SIZE * (x div 2 + 2), RECT_SIZE * (y + 3));
  self.Canvas.Line(RECT_SIZE * (x div 2), RECT_SIZE * (y + 2),
    RECT_SIZE * (x div 2), RECT_SIZE * (y + 3));
  self.Canvas.Line(RECT_SIZE * (x div 2 + 2), RECT_SIZE * (y + 2),
    RECT_SIZE * (x div 2 + 2), RECT_SIZE * (y + 3));

  self.Canvas.Pen.Width := 2;
end;

procedure TBoard.drawBall(x, y: integer; col: TColor);
begin
  self.Canvas.Brush.Color := col;
  self.Canvas.Pen.Color := col;
  self.Canvas.Ellipse((x + 1) * RECT_SIZE - BALL_RADIUS,
    (y + 2) * RECT_SIZE - BALL_RADIUS, (x + 1) * RECT_SIZE + BALL_RADIUS,
    (y + 2) * RECT_SIZE + BALL_RADIUS);
  self.Canvas.FloodFill((x + 1) * RECT_SIZE, (y + 2) * RECT_SIZE,
    color, fsBorder);
end;

procedure TBoard.drawBall(x, y: integer);
begin
  self.drawBall(lastBallPosX, lastBallPosY, clGreen);
  self.drawRect(x - 1, y - 1);
  self.drawBall(x, y, clWhite);
  lastBallPosX := x;
  lastBallPosY := y;
end;

procedure TBoard.drawRect(x, y: integer);
var
  counter: integer;
begin

  self.Canvas.Brush.Color := $000C600C;
  self.Canvas.FillRect(rects[sizeY + 4 * x + 2 + y]);

end;

procedure TBoard.makeMove(x, y, playerNo: integer);
var
  col: TColor;
begin
  if playerNo = 1 then
  begin
    col := clYellow;
  end
  else
  begin
    col := clRed;
  end;
  self.Canvas.Pen.Color := col;
  self.drawLine(x, y, col);
  self.drawBall(lastBallPosX, lastBallPosY, col);
  self.drawBall(x, y, clWhite);
  self.myBoardRep.addMove(lastBallPosX, lastBallPosY, x, y, playerNo);
  lastBallPosX := x;
  lastBallPosY := y;
end;

procedure TBoard.drawLine(x, y: integer; col: TColor);
begin
  self.Canvas.Line((lastBallPosX + 1) * RECT_SIZE, (lastBallPosY + 2) * RECT_SIZE,
    (x + 1) * RECT_SIZE, (y + 2) * RECT_SIZE);
end;

procedure TBoard.test;
begin

end;

procedure TBoard.drawLine(fromx, fromy, tox, toy: integer; col: TColor);
begin
  self.Canvas.Pen.Color := col;
  self.Canvas.Line((fromx + 1) * RECT_SIZE, (fromy + 2) * RECT_SIZE,
    (tox + 1) * RECT_SIZE, (toy + 2) * RECT_SIZE);
end;

procedure TBoard.drawFromBR(var rep: TBoardRep);
var
  counterx, countery: integer;
begin
  self.setSize(rep.sizeX, rep.sizeY);
  for counterx := 0 to rep.sizeX - 1 do
  begin
    for countery := 0 to rep.sizeY - 1 do
    begin
      self.drawTBoardPoint(rep.points[counterx, countery], counterx, countery);
    end;
  end;
  self.lastBallPosX:=rep.ballPosX;
  self.lastBallPosY:=rep.ballPosY;
  self.drawBall(rep.ballPosX, rep.ballPosY, clWhite);
  self.myBoardRep := rep;
end;


procedure TBoard.drawTBoardPoint(var pt: TBoardPoint; x, y: integer);
var
  counter, tempVar: integer;
  tempMove: TPoint;
  moves: TPossibleMoves;
begin
  tempVar := pt.pt;
  moves := TPossibleMoves.Create();
  for counter := 0 to 7 do
  begin
    tempMove := moves.Next();
    if (tempVar and 1) = 1 then
    begin
      if ((tempVar shr 1) and 1) = 1 then
      begin
        self.drawLine(x, y, x - tempMove.Y, y - tempMove.X, clYellow);
      end
      else
      begin
        self.drawLine(x, y, x - tempMove.Y, y - tempMove.X, clRed);
      end;
    end;
    tempVar := tempVar shr 2;
  end;
end;

function TBoard.giveClickedPoint(): TPoint; // (-1, -1) jeżeli żaden nie jest
var
  res, clicked: TPoint;
begin
  clicked := self.ScreenToClient(mouse.CursorPos);
  if ((clicked.X + self.BALL_RADIUS) mod self.RECT_SIZE > self.BALL_RADIUS * 3) or
    ((clicked.Y + self.BALL_RADIUS) mod self.RECT_SIZE > self.BALL_RADIUS * 3) then
  begin
    res.X := -1;
    res.Y := -1;
  end
  else
  begin
    res.X := (clicked.X + self.BALL_RADIUS*2) div self.RECT_SIZE - 1;
    res.Y := (clicked.Y + self.BALL_RADIUS*2) div self.RECT_SIZE - 2;
  end;
  giveClickedPoint := res;
end;

end.
