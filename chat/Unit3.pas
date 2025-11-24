unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Phys.MySQLDef, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Data.SqlExpr, Data.FMTBcd, System.Hash;

type
  TForm3 = class(TForm)
    Label1: TLabel;   // ID 라벨
    Label3: TLabel;   // PW 라벨
    Edit1: TEdit;     // ID 입력
    Edit2: TEdit;     // PW 입력
    Button1: TButton; // 회원가입 버튼
    Label2: TLabel;   // Name 라벨
    Edit3: TEdit;
    FDQueryMembers: TFDQuery;
    Label4: TLabel;
    Edit4: TEdit;
    ComboBox1: TComboBox;
    FDConnection1: TFDConnection;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit2, Unit7;  // Unit7: 메인 폼

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  ID, PW, Name, Email, hashedInput: string;
  NewUserNo: Integer;
begin
  ID := Trim(Edit1.Text);
  PW := Trim(Edit2.Text);
  Name := Trim(Edit3.Text);
  Email := Trim(Edit4.Text) + ComboBox1.Text;

  // 비밀번호 해시 (SHA-256)
  if PW.Length > 0 then
    hashedInput := THashSHA2.GetHashString(PW);

  // 입력값 확인
  if ID.IsEmpty or PW.IsEmpty or Name.IsEmpty or Email.IsEmpty then
  begin
    ShowMessage('모든 항목을 입력해주세요.');
    Exit;
  end;

  // DB에 회원정보 삽입
  FDQueryMembers.SQL.Text :=
    'INSERT INTO user(id, pw, name, email) VALUES (:id, :pw, :name, :email)';
  FDQueryMembers.ParamByName('id').AsString   := ID;
  FDQueryMembers.ParamByName('pw').AsString   := hashedInput;
  FDQueryMembers.ParamByName('name').AsString := Name;
  FDQueryMembers.ParamByName('email').AsString:= Email;
  FDQueryMembers.ExecSQL;

  // 새로 생성된 유저의 userno 가져오기
  FDQueryMembers.Close;
  FDQueryMembers.SQL.Text := 'select userno, id, name, role from user where id = :id and pw = :pw';
  FDQueryMembers.ParamByName('id').AsString := ID;
  FDQueryMembers.ParamByName('pw').AsString := hashedInput;
  FDQueryMembers.Open;
  if FDQueryMembers.IsEmpty then
  begin
    ShowMessage('회원가입은 되었지만 로그인 정보를 가져오지 못했습니다.');
    Exit;
  end;

  try
    if not FDQueryMembers.IsEmpty then
    begin
      CurrentUser.ID := FDQueryMembers.FieldByName('id').AsString;
      CurrentUser.Name := FDQueryMembers.FieldByName('name').AsString;
      CurrentUser.Role := FDQueryMembers.FieldByName('role').AsString;
      CurrentUser.UserNo := FDQueryMembers.FieldByName('userno').AsInteger;
      IsLoggedIn := True;
      ShowMessage('로그인 성공: ' + CurrentUser.Name);

      Form7.UserNo := CurrentUser.UserNo;

      Edit1.Clear;
      Edit2.Clear;
      Edit3.Clear;
      Edit4.Clear;
      ComboBox1.Clear;

      ModalResult := mrOk;
//      Form3.Close;
//      Form7.Show;
    end
    else
      ShowMessage('아이디 또는 비밀번호가 잘못되었습니다.');
  finally
    FDQueryMembers.Close;
  end;

end;

procedure TForm3.ComboBox1Change(Sender: TObject);
begin
  ComboBox1.Style := csDropDown;
end;

end.

