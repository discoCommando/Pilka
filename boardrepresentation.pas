unit BoardRepresentation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, glib2;

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


  TBoardRep = class
  const
    MAX_SIZE = 15;
  public
    ballPosX, ballPosY: integer;
    sizeX, sizeY: integer;
    points: array [0..MAX_SIZE, -1..MAX_SIZE + 1] of TBoardPoint; //x, y
    constructor Create();
    function giveMoves(): TMoveCont;
    procedure setSize(x, y: integer);
    procedure addMove(fromx, fromy, tox, toy: integer);
    procedure setBallPos(x, y: integer);


  private
  protected

  end;

  TPossibleMoves = class
  public
    function Next(): TPoint;
    constructor Create();
  private
    counter: integer;
    moves: array[0..7] of TPoint;
  end;


implementation


constructor TBoardRep.Create();
var
  counterx, countery: integer;
begin
  for counterx := 0 to MAX_SIZE do
  begin
    for countery := -1 to MAX_SIZE + 1 do
    begin
      self.points[counterx, countery] := TBoardPoint.Create();
    end;
  end;
end;

function TBoardRep.giveMoves(): TMoveCont;
begin

end;

procedure TBoardRep.setSize(x, y: integer);
begin
  self.sizeX := x;
  self.sizeY := y;
end;

procedure TBoardRep.addMove(fromx, fromy, tox, toy: integer);
begin

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
begin
  isFree := pt = 0;
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

end.
