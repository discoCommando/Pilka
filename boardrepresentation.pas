unit BoardRepresentation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

type

  TBoardPoint = class
  private
  protected
  public
    pt: integer; // 00 00 00 00 00 00 00 00
    //pierwszy bit: czy zajęta góra, drugi bit: czy przez pierwszego gracza.
    constructor Create();
    procedure addMove(moveUp, moveRight, byWho: integer);
    //moveUp = 1 - do góry, moveUp = 0 - nic, moveUp = -1 - do dołu etc.
    function isFree(): boolean;
    function isFreeLine(direction: integer): boolean;
  end;

  TMoveRep = class
  private
  protected
  public

  end;

  TMoveCont = class
  private
    container: TList;
  protected
  public
    procedure addToMe(var another: TMoveCont);
    procedure addToMe(var moveRep: TMoveRep);
    constructor Create();
    destructor Destroy();
    function getContainer(): TList;
  end;

  TPossibleMoves = class
  public
    counter: integer;
    function Next(): TPoint;
    constructor Create();
    procedure reset();
  private
    moves: array[0..7] of TPoint;
  end;

  TBoardRep = class
  const
    MAX_SIZE = 15;
  public
    ballPosX, ballPosY: integer;
    sizeX, sizeY: integer;
    points: array [-1..MAX_SIZE + 1, -2..MAX_SIZE + 2] of TBoardPoint; //x, y
    constructor Create();
    function giveMoves(): TMoveCont;
    procedure setSize(x, y: integer);
    procedure addMove(fromx, fromy, tox, toy, who: integer);
    procedure setBallPos(x, y: integer);
    function isLineFree(fromX, fromY, toX, toY: integer): boolean;

  private
    posMoves: TPossibleMoves;
    procedure borders();
  protected

  end;




implementation


constructor TBoardRep.Create();
var
  counterx, countery: integer;
begin
  for counterx := -1 to MAX_SIZE + 1 do
  begin
    for countery := -2 to MAX_SIZE + 2 do
    begin
      self.points[counterx, countery] := TBoardPoint.Create();
    end;
  end;
  posMoves := TPossibleMoves.Create;
end;

function TBoardRep.giveMoves(): TMoveCont;
begin

end;

procedure TBoardRep.setSize(x, y: integer);
begin
  self.sizeX := x;
  self.sizeY := y;
  self.borders();
end;

procedure TBoardRep.addMove(fromx, fromy, tox, toy, who: integer);
begin
  self.points[fromx, fromy].addMove(fromx - tox, toy - fromy, who);
  self.points[tox, toy].addMove(tox - fromx, fromy - toy, who);
end;

procedure TBoardRep.setBallPos(x, y: integer);
begin
  ballPosX := x;
  ballPosY := y;
end;

procedure TMoveCont.addToMe(var another: TMoveCont);
begin
  container.AddList(another.getContainer());
end;

procedure TMoveCont.addToMe(var moveRep: TMoveRep);
begin
  container.Add(Pointer(moveRep));
end;

constructor TMoveCont.Create();
begin
  container.Create;
end;

destructor TMoveCont.Destroy();
begin
  container.Destroy();
end;

function TMoveCont.getContainer: TList;
begin
  getContainer := container;
end;


procedure TBoardPoint.addMove(moveUp, moveRight, byWho: integer);
var
  place, by1: integer;
begin
  if moveUp = 1 then
  begin
    if moveRight = 1 then
    begin
      place := 2;
    end
    else if moveRight = 0 then
    begin
      place := 0;
    end
    else
    begin
      place := 14;
    end;
  end
  else if moveUp = 0 then
  begin
    if moveRight = 1 then
    begin
      place := 4;
    end
    else if moveRight = 0 then
    begin
      //impossible
    end
    else
    begin
      place := 12;
    end;
  end
  else
  begin
    if moveRight = 1 then
    begin
      place := 6;
    end
    else if moveRight = 0 then
    begin
      place := 8;
    end
    else
    begin
      place := 10;
    end;
  end;
  if byWho = 1 then
    by1 := 1
  else
    by1 := 0;

  pt := (pt) or ((1 shl place) or (by1 shl (place + 1)));
end;

constructor TBoardPoint.Create();
begin
  pt := 0;
end;

function TBoardPoint.isFree(): boolean;
var
  counter, i: integer;
begin
  counter := 0;
  for i := 0 to 7 do
  begin
    counter := counter + ((self.pt shr (i * 2)) and 1);
  end;
  isFree := counter <= 1;
end;



constructor TPossibleMoves.Create();
var
  tempTPoint: TPoint;  //x - gora, y - prawo
begin
  counter := 0;
  tempTPoint.X := 1;
  tempTPoint.Y := 0;
  moves[0] := tempTPoint;//gora
  tempTPoint.Y := 1;
  moves[1] := tempTPoint; //gora i prawo
  tempTPoint.X := 0;
  moves[2] := tempTPoint;  //prawo
  tempTPoint.X := -1;
  moves[3] := tempTPoint; //prawo i dol
  tempTPoint.Y := 0;
  moves[4] := tempTPoint; //dol
  tempTPoint.Y := -1;
  moves[5] := tempTPoint; //dol i lewo
  tempTPoint.X := 0;
  moves[6] := tempTPoint; //lewo
  tempTPoint.X := 1;
  moves[7] := tempTPoint; //gora i lewo
end;

function TPossibleMoves.Next(): TPoint;
begin
  counter := counter + 1;

  Next := moves[counter - 1];
end;


procedure TPossibleMoves.reset();
begin
  counter := 0;
end;

function TBoardRep.isLineFree(fromX, fromY, toX, toY: integer): boolean;
var
  tempPoint, vector: TPoint;
begin
  posMoves.reset();
  tempPoint := posMoves.Next();
  vector.X := fromX - toX;
  vector.Y := toY - fromY;
  while ((vector.X <> tempPoint.X) or (vector.Y <> tempPoint.Y)) do
  begin
    tempPoint := posMoves.Next();
  end;
  isLineFree := self.points[fromX, fromY].isFreeLine(posMoves.counter - 1);
end;


function TBoardPoint.isFreeLine(direction: integer): boolean;
begin
  isFreeLine := ((self.pt shr (direction * 2)) and 1) = 0;
end;


procedure TBoardRep.borders();
var
  counter: integer;
begin
  //boki
  for counter := 0 to self.sizeY do
  begin
    self.addMove(0, counter, 0, counter + 1, 0);
    self.addMove(0, counter, -1, counter, 0);
    self.addMove(0, counter, -1, counter - 1, 0);
    self.addMove(0, counter, -1, counter + 1, 0);
    self.addMove(self.sizeX, counter, self.sizeX, counter + 1, 0);
    self.addMove(self.sizeX, counter, self.sizeX + 1, counter, 0);
    self.addMove(self.sizeX, counter, self.sizeX + 1, counter - 1, 0);
    self.addMove(self.sizeX, counter, self.sizeX + 1, counter + 1, 0);
  end;
  //góra i dół
  for counter := 0 to self.sizeX div 2 - 2 do
  begin
    self.addMove(counter, 0, counter + 1, 0, 0);
    self.addMove(counter, 0, counter - 1, -1, 0);
    self.addMove(counter, 0, counter + 1, -1, 0);
    self.addMove(counter, 0, counter, -1, 0);
    self.addMove(counter, self.sizeY, counter + 1, self.sizeY, 0);
    self.addMove(counter, self.sizeY, counter - 1, self.sizeY + 1, 0);
    self.addMove(counter, self.sizeY, counter + 1, self.sizeY + 1, 0);
    self.addMove(counter, self.sizeY, counter, self.sizeY + 1, 0);
  end;
  for counter := self.sizeX downto self.sizeX div 2 + 2 do
  begin
    self.addMove(counter, 0, counter - 1, 0, 0);
    self.addMove(counter, 0, counter - 1, -1, 0);
    self.addMove(counter, 0, counter + 1, -1, 0);
    self.addMove(counter, 0, counter, -1, 0);
    self.addMove(counter, self.sizeY, counter - 1, self.sizeY, 0);
    self.addMove(counter, self.sizeY, counter - 1, self.sizeY + 1, 0);
    self.addMove(counter, self.sizeY, counter + 1, self.sizeY + 1, 0);
    self.addMove(counter, self.sizeY, counter, self.sizeY + 1, 0);
  end;

  //bramki
  for counter := self.sizeX div 2 - 1 to self.sizeX div 2 do
  begin
    self.addMove(counter, -1, counter + 1, -1, 0);
    self.addMove(counter, self.sizeY + 1, counter + 1, self.sizeY + 1, 0);
  end;

  self.addMove(self.sizeX div 2 - 1, 0, self.sizeX div 2 - 1, -1, 0);
  self.addMove(self.sizeX div 2 - 1, self.sizeY, self.sizeX div 2 -
    1, self.sizeY + 1, 0);
  self.addMove(self.sizeX div 2 + 1, 0, self.sizeX div 2 + 1, -1, 0);
  self.addMove(self.sizeX div 2 + 1, self.sizeY, self.sizeX div 2 +
    1, self.sizeY + 1, 0);

  //trzeba zrobic "ukosy" od bramek

end;

end.
