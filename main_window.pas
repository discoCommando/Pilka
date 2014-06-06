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
    Label1: TLabel;
    MainMenu1: TMainMenu;
    R8x10MenuItem: TMenuItem;
    R15x15MenuItem: TMenuItem;
    R10x10MenuItem: TMenuItem;
    RozmiarMenuItem: TMenuItem;
    PlikMenuItem: TMenuItem;
    NowaGraMenuItem: TMenuItem;
    OpcjeMenuItem: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
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
  rep.points[6, 6].addMove(1, 0, 1);
  rep.points[1, 6].addMove(1, -1, 1);
  rep.setBallPos(5, 5);
  Board1.drawFromBR(rep);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.Label1Click(Sender: TObject);
var
  pt, pt2: TBoardPoint;
begin
  pt := TBoardPoint.Create;
  //pt.addMove(1, 0, 0);
  pt2 := pt;
  if pt2.isFree() then

    Label1.Caption := 'TAK';
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
