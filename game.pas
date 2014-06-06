unit Game;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Board;

type
  TState = (Playing, Undoing); //rozróżnienie miedzy grą a poruszaniem sie po historii
  TPlayer = (Human, Computer);

  TGame = class
  public
    constructor Create(var b: TBoard; firstHuman, secondHuman: boolean);
    procedure OnClick();  //dodaj historie do konstruktora
  private
    board: TBoard;
    players: array [1..2] of TPlayer;
    state: TState;
    procedure handleTurn();
  end;




implementation

constructor TGame.Create(var b: TBoard; firstHuman, secondHuman: boolean);
begin
  if firstHuman then
  begin
    self.players[1] := Human;
  end
  else
  begin
    self.players[1] := Computer;
  end;
  if secondHuman then
  begin
    self.players[2] := Human;
  end
  else
  begin
    self.players[2] := Computer;
  end;

  self.board := b;
  self.state := TState.Playing;
end;

procedure TGame.OnClick();
var
  clicked: TPoint;
begin
  if self.state = TState.Playing then
  begin
    clicked := self.board.giveClickedPoint();
    if (clicked.X <> -1) or (clicked.Y <> -1) then
    begin
      if ((abs(clicked.X - self.board.lastBallPosX) <= 1) and
        (abs(clicked.X - self.board.lastBallPosX) <= 1) and
        ((clicked.X <> self.board.lastBallPosX) or
        (clicked.Y <> self.board.lastBallPosY))) then
      begin
        if (self.board.myBoardRep.isLineFree(self.board.lastBallPosX,
          self.board.lastBallPosY, clicked.X, clicked.Y)) then
        begin
          self.board.makeMove(clicked.X, clicked.Y, 1);
        end;
      end;
    end;
  end;
end;

procedure TGame.handleTurn();
begin

end;

end.
