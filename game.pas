unit Game;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, Buttons, Board, Forms, Controls;

type
  TState = (Playing, Undoing, NotPlaying);
  //rozróżnienie miedzy grą a poruszaniem sie po historii
  TPlayer = (Human, Computer);

  TGame = class
  public
    constructor Create(var b: TBoard; firstHuman, secondHuman: boolean;
      var endTurnBut: TButton; var gameLabel: TLabel);
    procedure OnClick();  //dodaj historie do konstruktora
    procedure endTurn();
  private
    turn: integer;
    board: TBoard;
    players: array [1..2] of TPlayer;
    state: TState;
    lastEndTurnPoint: TPoint; //punkt na ktorym ktoś ostatnio skończył
    endTurnButton: TButton;
    infoLabel: TLabel;
    procedure handleTurn();
    procedure makeMove();
    procedure checkEndOfGame();
    function canEndTurn(): boolean;
  end;




implementation

constructor TGame.Create(var b: TBoard; firstHuman, secondHuman: boolean;
  var endTurnBut: TButton; var gameLabel: TLabel);
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
  self.turn := 1;
  self.lastEndTurnPoint.X := self.board.lastBallPosX;
  self.lastEndTurnPoint.Y := self.board.lastBallPosY;
  self.endTurnButton := endTurnBut;
  self.endTurnButton.Enabled := False;
  self.infoLabel := gameLabel;
  self.infoLabel.Caption := 'Tura Gracza: ' + IntToStr(turn);
end;

procedure TGame.OnClick();

begin
  if self.state = TState.Playing then
  begin
    if self.players[turn] = Human then
    begin
      if not self.canEndTurn() then
      begin

        self.makeMove();

      end;
    end;
  end;
end;

procedure TGame.handleTurn();      //TODO
begin
  self.infoLabel.Caption := 'Tura Gracza: ' + IntToStr(turn);
end;

procedure TGame.makeMove();      //sprawdzanie czy koniec
var
  clicked: TPoint;
begin
  clicked := self.board.giveClickedPoint();
  if (clicked.X <> -1) or (clicked.Y <> -1) then
  begin
    if ((abs(clicked.X - self.board.lastBallPosX) <= 1) and
      (abs(clicked.Y - self.board.lastBallPosY) <= 1) and
      ((clicked.X <> self.board.lastBallPosX) or
      (clicked.Y <> self.board.lastBallPosY))) then
    begin
      if (self.board.myBoardRep.isLineFree(self.board.lastBallPosX,
        self.board.lastBallPosY, clicked.X, clicked.Y)) then
      begin
        self.board.makeMove(clicked.X, clicked.Y, turn);
      end;
    end;

  end;
  self.canEndTurn();
end;

procedure TGame.endTurn();         //TODO
begin
  if (self.canEndTurn()) then
  begin
    turn := 1 + ((turn) mod 2);
    self.lastEndTurnPoint.X := self.board.lastBallPosX;
    self.lastEndTurnPoint.Y := self.board.lastBallPosY;
    self.handleTurn();
    self.endTurnButton.Enabled := False;
  end;
end;

function TGame.canEndTurn(): boolean;    //TODO
var
  tempResult: boolean;
begin
  tempResult := True;
  if (self.lastEndTurnPoint.X = self.board.lastBallPosX) and
    (self.lastEndTurnPoint.Y = self.board.lastBallPosY) then
  begin
    tempResult := False;
  end;

  if not (self.board.myBoardRep.points[self.board.lastBallPosX,
    self.board.lastBallPosY].isFree()) then
  begin
    tempResult := False;
  end;

  if (tempResult) then
  begin
    self.endTurnButton.Enabled := True;
  end;
  canEndTurn := tempResult;
end;


procedure TGame.checkEndOfGame();
begin

end;

end.
