unit Game;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, Buttons, Board, Forms, Controls, History,
  BoardRepresentation, Dialogs;

type
  TState = (Playing, Undoing, NotPlaying);
  //rozróżnienie miedzy grą a poruszaniem sie po historii
  TPlayer = (Human, Computer);

  TGame = class
  public
    constructor Create(var b: TBoard; firstHuman, secondHuman: boolean;
      var h: THistory; var endTurnBut, undoBut, redoBut, endUndoRedoBut: TButton;
      var gameLabel: TLabel);
    procedure OnClick();  //dodaj historie do konstruktora
    procedure endTurn();
    procedure undoClick();
    procedure redoClick();
    procedure endUndoRedoClick();
  private
    turn: integer;
    board: TBoard;
    history: THistory;
    players: array [1..2] of TPlayer;
    state: TState;
    lastEndTurnPoint: TPoint; //punkt na ktorym ktoś ostatnio skończył
    endTurnButton: TButton;
    undoButton: TButton;
    redoButton: TButton;
    endUndoRedoButton: TButton;
    infoLabel: TLabel;
    procedure handleTurn();
    procedure makeMove();
    procedure checkEndOfGame();
    function canEndTurn(): boolean;
    procedure setState(s: TState);
  end;




implementation

constructor TGame.Create(var b: TBoard; firstHuman, secondHuman: boolean;
  var h: THistory; var endTurnBut, undoBut, redoBut, endUndoRedoBut: TButton;
  var gameLabel: TLabel);
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
  self.turn := 1;
  self.lastEndTurnPoint.X := self.board.lastBallPosX;
  self.lastEndTurnPoint.Y := self.board.lastBallPosY;
  self.endTurnButton := endTurnBut;
  self.endTurnButton.Enabled := False;
  self.infoLabel := gameLabel;
  self.infoLabel.Caption := 'Tura Gracza: ' + IntToStr(turn);
  self.history := h;
  self.endUndoRedoButton := endUndoRedoBut;
  self.undoButton := undoBut;
  self.redoButton := redoBut;
  self.setState(Playing);
end;

procedure TGame.OnClick();
var
  tempSegment: TSegment;
begin
  if self.state = TState.Undoing then
  begin
    if (self.history.counter = 0) then
    begin
      turn := 1;
      self.history.writeYourself();
    end;
    setState(TState.Playing);

  end;
  if self.state = TState.Playing then
  begin
    if self.players[turn] = Human then
    begin
        self.makeMove();
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
  tempSegment: TSegment;
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
        tempSegment := TSegment.Create();
        tempSegment.setSegment(self.board.lastBallPosX, self.board.lastBallPosY,
          clicked.X, clicked.Y, turn);
        self.history.addSegment(tempSegment);
        self.board.makeMove(clicked.X, clicked.Y, turn);
  self.endTurn();
  self.checkEndOfGame();
      end;
    end;

  end;
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
    self.history.endMove();
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
  if self.state = TState.Playing then
  begin
    if (self.board.myBoardRep.points[self.board.lastBallPosX,
      self.board.lastBallPosY].noWayOut()) then  //nie da sie wyjsc
    begin
      self.infoLabel.Caption :=
        'KONIEC GRY!!! Wygrana Gracza: ' + IntToStr(1 + (turn mod 2)) +
        ' poprzez zaklinowanie się przeciwnika!';
      self.setState(NotPlaying);
    end
    else if (abs(self.board.lastBallPosX - (self.board.sizeX div 2)) <= 1) then

    begin
      if ((self.board.lastBallPosY = -1)) then
      begin
        self.infoLabel.Caption := 'KONIEC GRY!!! Gracz 1 strzela GOLA';
        self.setState(NotPlaying);
      end
      else if (self.board.lastBallPosY = self.board.sizeY + 1) then
      begin
        self.setState(NotPlaying);
        self.infoLabel.Caption := 'KONIEC GRY!!! Gracz 2 strzela GOLA';
      end;
    end;
  end;
end;

procedure TGame.setState(s: TState);
begin
  if (s = TState.NotPlaying) then
  begin
    self.endTurnButton.Enabled := False;
    self.endUndoRedoButton.Enabled := False;
    self.redoButton.Enabled := False;
    self.undoButton.Enabled := False;
    self.state := NotPlaying;
  end
  else if (s = TState.Playing) then
  begin
    self.endUndoRedoButton.Enabled := False;
    self.redoButton.Enabled := True;
    self.undoButton.Enabled := True;
    self.endTurnButton.Enabled := False;
    self.canEndTurn();
    self.state := Playing;
  end
  else if (s = TState.Undoing) then
  begin

    self.endUndoRedoButton.Enabled := True;
    self.redoButton.Enabled := True;
    self.undoButton.Enabled := True;
    self.endTurnButton.Enabled := False;
    self.state := Undoing;
  end;
end;

procedure TGame.undoClick();
var tempSegment: TSegment;
begin
  if (self.history.canUndo()) then
  begin
    tempSegment := self.history.undo();
    self.board.drawUndo(tempSegment);
    turn := tempSegment.byWho;
    self.handleTurn();
    self.setState(TState.Undoing);  //PO KAZDYM UNDO ZMIANA TURN!!
  end;
end;

procedure TGame.redoClick();
var tempSegment: TSegment;
begin
  if (self.history.canRedo()) then
  begin
    tempSegment := self.history.redo();
    self.board.drawRedo(tempSegment);
    turn := tempSegment.byWho;
    endTurn();
    self.handleTurn();

  end;
end;

procedure TGame.endUndoRedoClick();
begin
end;

end.
