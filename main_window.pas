unit Main_Window;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, Menus, ActnList, Board, boardRepresentation, Game;

type

  { TForm1 }

  TForm1 = class(TForm)
    Board1: TBoard;
    Button1: TButton;
    Button2: TButton;
    EndTurnButton: TButton;
    GameLabel: TLabel;
    MainMenu1: TMainMenu;
    R8x10MenuItem: TMenuItem;
    R15x15MenuItem: TMenuItem;
    R10x10MenuItem: TMenuItem;
    RozmiarMenuItem: TMenuItem;
    PlikMenuItem: TMenuItem;
    NowaGraMenuItem: TMenuItem;
    OpcjeMenuItem: TMenuItem;
    procedure Board1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure EndTurnButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure R10x10MenuItemClick(Sender: TObject);
    procedure R15x15MenuItemClick(Sender: TObject);
    procedure R8x10MenuItemClick(Sender: TObject);
    procedure PlikMenuItemClick(Sender: TObject);
    procedure NowaGraMenuItemClick(Sender: TObject);
    procedure OpcjeMenuItemClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure checkMenuItem(item: TMenuItem);

  private
    sizeX, sizeY: integer;
    { private declarations }
  public
    { public declarations }
  end;



var
  Form1: TForm1;
  Game1: TGame;
  gameOn: boolean;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  rep: TBoardRep;
begin
  //Board1.setSize(12, 12);
  rep := TBoardRep.Create();
  rep.setSize(12, 12);
  rep.setBallPos(6, 6);
  Board1.drawFromBR(rep);
  Game1 := TGame.Create(Board1, True, True, self.EndTurnButton, self.GameLabel);
  gameOn := True;
end;

procedure TForm1.Board1Click(Sender: TObject);
begin
  if (gameOn) then
  begin
    Game1.OnClick();

  end;
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
  self.Board1.makeMove(5, 5, 1);
  Button2.Caption := IntToStr((49152 shr 14) and 1);
end;

procedure TForm1.EndTurnButtonClick(Sender: TObject);
begin
  if (gameOn) then
  begin
    Game1.endTurn();
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  gameOn := False;
end;



procedure TForm1.checkMenuItem(item: TMenuItem);
var
  counter: integer;
begin
  for counter := 0 to 2 do
  begin
    self.RozmiarMenuItem.Items[counter].Checked := False;
  end;
  item.Checked := True;
end;

procedure TForm1.R10x10MenuItemClick(Sender: TObject);
var
  counter: integer;

begin
  sizeX := 10;
  sizeY := 10;
  checkMenuItem(self.R10x10MenuItem);
end;

procedure TForm1.R15x15MenuItemClick(Sender: TObject);
begin
  sizeX := 15;
  sizeY := 15;
  checkMenuItem(self.R15x15MenuItem);
end;

procedure TForm1.R8x10MenuItemClick(Sender: TObject);
begin
  sizeX := 8;
  sizeY := 10;
  checkMenuItem(self.R8x10MenuItem);
end;

procedure TForm1.PlikMenuItemClick(Sender: TObject);
begin

end;


procedure TForm1.NowaGraMenuItemClick(Sender: TObject);
begin
  board1.setSize(sizeX, sizeY);
end;

procedure TForm1.OpcjeMenuItemClick(Sender: TObject);
begin

end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin

end;




end.
