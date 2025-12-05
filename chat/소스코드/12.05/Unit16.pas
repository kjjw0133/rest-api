unit Unit16;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TForm16 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    Button1: TButton;
    Button2: TButton;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form16: TForm16;

implementation

{$R *.dfm}
uses unit2,unit14;

procedure TForm16.Button1Click(Sender: TObject);
var
  requester_id, receiver_id : String;
begin
  requester_id := CurrentUser.ID;
  receiver_id := Trim(Edit1.Text);

  FDQuery1.Close;
  FDQuery1.SQL.Text := 'SELECT id FROM user WHERE id = :id';
  FDQuery1.ParamByName('id').AsWideString := receiver_id;
  FDQuery1.Open;

  if FDQuery1.IsEmpty then
  begin
    ShowMessage('해당 사용자가 존재하지 않습니다.');
    Exit;
  end;

  FDQuery1.Close;
  FDQuery1.SQL.Text := ' SELECT requester_id, receiver_id '+
  ' FROM friend '+
  ' WHERE status IN (1, 2) '+
  ' AND ( (requester_id = :me AND receiver_id = :other) '+
  ' OR (requester_id = :other AND receiver_id = :me) ) ';

  FDQuery1.ParamByName('me').AsWideString := requester_id;
  FDQuery1.ParamByName('other').AsWideString := receiver_id;
  FDQuery1.Open;

   if not FDQuery1.IsEmpty then
   begin
    ShowMessage('이미 초대하거나 친구 상태입니다.');
    Exit;
   end;
        
  FDQuery1.Close;
  FDQuery1.SQL.Text := ' INSERT INTO friend (requester_id, receiver_id, status) '+
                       ' SELECT u1.id, u2.id, 1 '+
                       ' FROM user u1 '+
                       ' JOIN user u2 '+
                       ' WHERE u1.id = :requester_id '+
                       ' AND u2.id = :receiver_id ';
  FDQuery1.ParamByName('requester_id').AsWideString := requester_id;
  FDQuery1.ParamByName('receiver_id').AsWideString := receiver_id;
  FDQuery1.ExecSQL;

  ShowMessage('친구 추가 요청이 성공적으로 완료되었습니다.');
  Form16.Close;
  
  TForm14.Create(Application);

end;

procedure TForm16.Button2Click(Sender: TObject);
begin
  Edit1.Clear;
  Form16.Close;
  
  TForm14.Create(Application);
end;

procedure TForm16.FormCreate(Sender: TObject);
begin
  ActiveControl := Panel1;
  Panel1.Color := clWhite;
end;

end.
