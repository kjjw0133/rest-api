unit Unit8;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TForm8 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    FDQueryMembers: TFDQuery;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDConnection1: TFDConnection;
    LabelClose: TLabel;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure LabelCloseClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    function roomnameequal: String;
  public
    ChatType : Integer;
    chatroomname : String;
  end;

var
  Form8: TForm8;

implementation

{$R *.dfm}

uses
Unit7, unit2,unit1,unit13;

function TForm8.roomnameequal: String;
var
  roomname : String;
begin
  FDQueryMembers.Close;
  FDQueryMembers.SQL.Text := ' select chatroomname from chat where chatroomname = :chatroomname ';
  FDQueryMembers.ParamByName('chatroomname').AsString := chatroomname;
  FDQueryMembers.Open;

  FDQueryMembers.FieldByName('chatroomname').AsString := roomname;

  if chatroomname = roomname then
  begin
    ShowMessage('이미 있는 이름입니다. 다시 이름으로 변경해주세요.');
    Exit;
  end;
end;

procedure TForm8.Button2Click(Sender: TObject);
var 
  roomname : String;
begin
  chatroomname := Trim(edit1.Text);
  ChatType := 1;

  if chatroomname = '' then
  begin
    ShowMessage('방 이름을 입력해주세요.');
    Exit;
  end;

  roomnameequal;

  Form13.ShowModal;
  Self.Hide;

  Edit1.Clear;
  Exit;
end;

procedure TForm8.Button3Click(Sender: TObject);
begin
  ChatType := 2;

  chatroomname := Trim(edit1.Text);

  if chatroomname = '' then
  begin
    ShowMessage('방 이름을 입력해주세요.');
    Exit;
  end;

  roomnameequal;

  Form13.ShowModal;
  Self.Hide;

  Edit1.Clear;
  Form8.Close;
  Exit;
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
  BorderStyle := bsNone;
end;

procedure TForm8.LabelCloseClick(Sender: TObject);
begin
  Close;
end;

end.


