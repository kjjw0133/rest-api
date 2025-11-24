unit Unit9;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TForm9 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    FDQueryMembers: TFDQuery;
    FDConnection1: TFDConnection;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  Form9: TForm9;

implementation

uses Unit1, Unit2, Unit3, Unit8, Unit7;


{$R *.dfm}



procedure TForm9.FormCreate(Sender: TObject);
var
ChatRoomId,num : Integer;
chatroomname, chatpw : String;
begin
  FDqueryMembers.SQL.Text := 'select ChatRoomId, chatroomname, num, chatpw from chat where ChatRoomId = :roomid ';
  FDQueryMembers.ParamByName('roomid').AsInteger := Form1.ChatRoomId;
  FDQueryMembers.Open;

  if not FDQueryMembers.IsEmpty then
  begin
    Label7.Caption := IntToStr(FDQueryMembers.ParamByName('roomid').AsInteger);
    Label5.Caption := FDQueryMembers.FieldByName('chatroomname').AsWideString;
    Label3.Caption := IntToStr(FDQueryMembers.FieldByName('num').AsInteger);
    Label8.Caption := FDQueryMembers.FieldByName('chatpw').AsString;
  end
  else
  begin
    Exit;
  end;
end;

end.
