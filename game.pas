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
   Constructor Create(var b: TBoard; firstPlayerHuman, secondPlayerHuma: Boolean);
   //dodaj historie do konstruktora
 private
        board: TBoard;
   players: array [1..2] of TPlayer;
 end;




implementation

end.

