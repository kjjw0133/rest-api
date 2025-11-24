unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.MySQLDef, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.VCLUI.Wait, Data.FMTBcd, Data.SqlExpr, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, System.Hash; // <-- 해시 유닛 추가

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    Edit1: TEdit; // ID
    Edit2: TEdit; // PW (비밀번호)
    Button1: TButton; // 로그인 버튼
    FDQueryMembers: TFDQuery;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    Label2: TLabel;
    Label4: TLabel;
    Button2: TButton;
    FDConnection1: TFDConnection;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject); // 폼 생성 이벤트 추가
  private
    { Private declarations }
  public
    function GetUserNo: Integer;
  end;

type
  TUser = record
    UserNo: Integer;
    ID: string;
    Name: string;
    Role: string; // 예: 'admin', 'user'
  end;

var
  CurrentUser: TUser;
  IsLoggedIn: Boolean = False;
  Form2: TForm2;

implementation
uses Unit3, Unit1, Unit4, Unit7;
{$R *.dfm}

function TForm2.GetUserNo: Integer;
begin
  FDQueryMembers.Close;
  FDQueryMembers.SQL.Text :=
    'SELECT userno FROM user WHERE id = :userid AND pw = :userpw';
  FDQueryMembers.ParamByName('userid').AsString := Edit1.Text;
  FDQueryMembers.ParamByName('userpw').AsString := Edit2.Text;
  FDQueryMembers.Open;

  if FDQueryMembers.IsEmpty then
    Result := -1
  else
    Result := FDQueryMembers.FieldByName('userno').AsInteger;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  //Form9.show;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  // 비밀번호 입력란 숨김 처리
  Edit2.PasswordChar := '*';
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  ID, PW, hashedInput: string;
begin
  ID := Trim(Edit1.Text);
  PW := Trim(Edit2.Text);

  // 입력 검증
  if ID = '' then
  begin
    ShowMessage('아이디를 입력해주세요.');
    Exit;
  end;
  if PW = '' then
  begin
    ShowMessage('비밀번호를 입력해주세요.');
    Exit;
  end;

  // 입력한 비밀번호를 SHA-256으로 해시
  hashedInput := THashSHA2.GetHashString(PW);

  // 쿼리 준비 및 실행 (pw에는 해시값 전달)
  FDQueryMembers.Close;
  FDQueryMembers.SQL.Text :=
    'select userno, id, name, role from user where id = :id and pw = :pw';
  FDQueryMembers.ParamByName('id').AsString := ID;
  FDQueryMembers.ParamByName('pw').AsString := hashedInput;
  FDQueryMembers.Open;

  try
    if not FDQueryMembers.IsEmpty then
    begin
      CurrentUser.ID := FDQueryMembers.FieldByName('id').AsString;
      CurrentUser.Name := FDQueryMembers.FieldByName('name').AsString;
      CurrentUser.Role := FDQueryMembers.FieldByName('role').AsString;
      CurrentUser.UserNo := FDQueryMembers.FieldByName('userno').AsInteger;
      IsLoggedIn := True;
      //ShowMessage('로그인 성공: ' + CurrentUser.Name);

      Form7.UserNo := CurrentUser.UserNo;

      Edit1.Clear;
      Edit2.Clear;
      ModalResult := mrOk; // 로그인 폼 닫기 또는 호출자에 결과 전달

    end
    else
      ShowMessage('아이디 또는 비밀번호가 잘못되었습니다.');
  finally
    FDQueryMembers.Close;
  end;
end;

procedure TForm2.Label2Click(Sender: TObject);
begin
  Form3.Show;
  Form2.Close;
end;

procedure TForm2.Label4Click(Sender: TObject);
begin
  Form4.Show;
  Form2.Close;
end;

end.

