unit Board;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  BoardRepresentation;

type
  TBoard = class(TImage)
  const
    MAX_SIZE = 1599;
    DOT_COLOR = $000C600C;
  private
    { Private declarations }
    rects: array [0..MAX_SIZE] of TRect;
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
    procedure drawUndo(move: TSegment);
    procedure drawRedo(move: TSegment);
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
  for counterX := -1 to x + 1 do
  begin
    for counterY := -2 to y + 2 do
    begin
      //rects[counter] := Rect(counterX * (RECT_SIZE) + 1, counterY *
      //  (RECT_SIZE) + 1, (counterX + 1) * (RECT_SIZE) - 1, (counterY + 1) *
      //  (RECT_SIZE) - 1);
      //
      //self.Canvas.FillRect(rects[counter]);
      //counter := counter + 1;

      self.drawBall(counterX, counterY, DOT_COLOR);
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
  self.drawBall(lastBallPosX, lastBallPosY, DOT_COLOR);
  //self.drawBall(lastBallPosX, lastBallPosY, col);
  self.drawBall(x, y, clWhite);
  self.myBoardRep.addMove(lastBallPosX, lastBallPosY, x, y, playerNo);
  lastBallPosX := x;
  lastBallPosY := y;
end;

procedure TBoard.drawLine(x, y: integer; col: TColor);
begin
  self.Canvas.Pen.Color:=col;
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
  for counterx := 1 to rep.sizeX - 1 do
  begin
    for countery := 1 to rep.sizeY - 1 do
    begin
      self.drawTBoardPoint(rep.points[counterx, countery], counterx, countery);
    end;
  end;
  self.lastBallPosX := rep.ballPosX;
  self.lastBallPosY := rep.ballPosY;
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
        self.drawLine(x, y, x - tempMove.X, y + tempMove.Y, clYellow);
      end
      else
      begin
        self.drawLine(x, y, x - tempMove.X, y + tempMove.Y, clRed);
      end;
      self.drawBall(x - tempMove.X, y + tempMove.Y, DOT_COLOR);
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
    res.X := (clicked.X + self.BALL_RADIUS * 2) div self.RECT_SIZE - 1;
    res.Y := (clicked.Y + self.BALL_RADIUS * 2) div self.RECT_SIZE - 2;
  end;

  if (res.X < 0) or (res.X > self.sizeX) or (res.Y > self.sizeY) or (res.Y < 0) then
  begin
    if not (((res.Y = self.sizeY + 1) or (res.Y = -1)) and
      (abs(self.sizeX div 2 - res.X) <= 1)) then
    begin
      res.X := -1;
      res.Y := -1;
    end;
  end;
  giveClickedPoint := res;
end;


procedure TBoard.drawUndo(move: TSegment);
var
  counter: integer;
  temp: ^TSegment;
begin
  self.myBoardRep.removeMove(move.fromx, move.fromy, move.tox, move.toy);
  self.lastBallPosY:=move.fromy;
  self.lastBallPosX:=move.fromx;
    self.drawLine(move.fromx, move.fromy, move.tox, move.toy, clGreen);
    self.drawBall(move.tox, move.toy, DOT_COLOR);
    self.drawBall(move.fromx, move.fromy, clWhite);
  self.drawTBoardPoint(self.myBoardRep.points[move.fromx, move.fromy - 1], move.fromx, move.fromy - 1);
  self.drawTBoardPoint(self.myBoardRep.points[move.fromx, move.fromy + 1], move.fromx, move.fromy + 1);
  self.drawTBoardPoint(self.myBoardRep.points[move.fromx + 1, move.fromy], move.fromx + 1, move.fromy);
  self.drawTBoardPoint(self.myBoardRep.points[move.fromx - 1, move.fromy], move.fromx - 1, move.fromy);
    self.drawBall(move.fromx, move.fromy + 1, DOT_COLOR);
    self.drawBall(move.fromx, move.fromy - 1, DOT_COLOR);
    self.drawBall(move.fromx - 1, move.fromy, DOT_COLOR);
    self.drawBall(move.fromx + 1, move.fromy, DOT_COLOR);



end;

procedure TBoard.drawRedo(move: TSegment);
begin
  self.makeMove(move.tox, move.toy, move.byWho);
end;

end.
