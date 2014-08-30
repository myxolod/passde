unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Clipbrd;

type
  TSet_g = record
    pass: string[50];
  end;
  TLogin = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    Pass: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Login: TLogin;
    LSet_g: TSet_g;
  prover: Boolean;

implementation

uses Unit2;

{$R *.dfm}


// процедура скрытия и открытия кнопок на форме
procedure m_onshow(v:integer);
begin
if v = 0 then
begin
  main.TreeView1.Visible:=false;
  main.ListView1.Visible:=false;
  main.Edit1.Visible:=false;
  main.Button1.Visible:=false;
  main.Button2.Visible:=false;
  main.SpeedButton1.Visible:=false;
  main.SpeedButton2.Visible:=false;
  main.SpeedButton3.Visible:=false;
  main.SpeedButton4.Visible:=false;
end
else
begin
  main.TreeView1.Visible:=true;
  main.ListView1.Visible:=true;
  main.Edit1.Visible:=true;
  main.Button1.Visible:=true;
  main.Button2.Visible:=true;
  main.SpeedButton1.Visible:=true;
  main.SpeedButton2.Visible:=true;
  main.SpeedButton3.Visible:=true;
  main.SpeedButton4.Visible:=true;
end
end;
//----------------------------------------------

procedure TLogin.FormCreate(Sender: TObject);
begin

if FileExists('set.ini') = false then
  begin

    prover:= false;
    Edit2.Visible:=true;
    Pass.Caption := 'Введите пароль и его подтверждение:';

    ShowMessage('Внимание! После создания первого пароля нужно перезойти вв программу!');
  end
else
  begin

    prover:= true;
    Edit2.Visible := false;
    Pass.Caption:= 'Введите пароль:';
    Button1.Top := Button1.Top - 21;
    Button2.Top := Button2.Top - 21;
    login.Height:= login.Height - 21;
  end;
 end;
procedure TLogin.Button1Click(Sender: TObject);
var
  l:file of TSet_g;

  s: TSet_g;
begin
  AssignFile(l,'set.ini');
  if prover = true then    // при существоввании файла
    begin
      Reset(l);
      if FileSize(l) <> 0 then
      begin
        Read(l,s);
        Seek(l,0);
        
        if Edit1.Text = s.pass then
          begin
            vis:=1;
            m_onshow(vis);
            Login.Visible := false;
            CloseFile(l);
          end
        else
          begin
            Edit1.Text := '';
            ShowMessage('Неверный пароль');
          end;
        end
      else
      ShowMessage('Ошибка пароля|1')  // фаил с паролем имеет размер 0
    end
  else
    begin
      if (Edit1.Text = Edit2.Text) and (edit1.Text <> '') then
        begin
          Rewrite(l);
          s.pass:=edit1.Text;
          Write(l,s);
          ShowMessage('Пароль успешно изменен');
          vis:=1;
            m_onshow(vis);
            Login.Visible := false;
            CloseFile(l);
        end
      else

          ShowMessage('Не верно задан пароль');

    end;
end;
procedure TLogin.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if prover = true then
  begin
    if Key = 13 then
    Button1.Click;
  end
  else
    if key = 13 then
    Edit2.SetFocus;
end;

procedure TLogin.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if Key = 13 then
    Button1.Click;
end;

procedure TLogin.FormShow(Sender: TObject);
begin
edit1.SetFocus;
end;

procedure TLogin.Button2Click(Sender: TObject);
begin
close;
end;

end.
