unit Unit3;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Clipbrd;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    SpeedButton1: TSpeedButton;
    Button3: TButton;
    SpeedButton2: TSpeedButton;
    Button4: TButton;
    Label6: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  id_c: integer;
  f: boolean; // переменна€ дл€  PasswordChar

implementation

uses Unit2, ComCtrls, Unit4;

{$R *.dfm}

// процедура обновлени€ списка -----------------------------------

procedure Pass_reset2();
var
  i,number_str,test: integer;
  out_pass: save_pass;

begin
    Main.ListView1.Clear;
    i:=0;
    number_str:=0;
    Seek(file_pass,number_str);
    test:=1;
   while Eof(file_pass) = false do
   begin
    test:=test+1;
    read(file_pass,out_pass);
    SetLength(a_id_pass,test);
    if out_pass.id_catal = mynode.AbsoluteIndex then
      begin
      if out_pass.delet = 0 then
      begin
        Main.ListView1.Items.Add.Caption:=out_pass.name;
        Main.ListView1.Items[i].SubItems.Add(out_pass.log);
        Main.ListView1.Items[i].SubItems.Add('******');
        Main.ListView1.Items[i].SubItems.Add(out_pass.path);

        a_id_pass[test - 1] := out_pass.pass;
        id_pass := out_pass.id;

        i:=i+1;
        number_str:=number_str+1;
        Seek(file_pass,number_str);
      end
      else
      begin
        number_str:=number_str+1;
        Seek(file_pass,number_str);
      end;
      end
      else
      begin
        number_str:=number_str+1;
        Seek(file_pass,number_str);
      end;
  end;
end;
//--------------------------------------------------------------

//----------- процедура рандом парол€ -------------------

procedure random_pass();
var
  a,i:integer;
begin

Randomize;
for i:=0 to 19 do
begin
a := Random(61);
a:= a+48;
if a > 57 then
begin
a:= a + 7;
if a > 90 then
  a := a + 6;
end;
Form3.Edit3.Text := Form3.Edit3.Text + Char(a);
Form3.Edit4.Text := Form3.Edit4.Text + Char(a);
end;

end;

// ------------------------------------------------------

function eof_file_p(): integer;
var
  level,i:integer;
begin
level := 0;
i:=0;
Seek(file_pass,i);
  while eof(file_pass) = false do
  begin
  i:=i+1;
  Seek(file_pass,i);
  level:= level + 1;
  end;
  eof_file_p := level;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
 // id_c :=  main.treeview1.Selected.SelectedIndex;
 // Main.ListView1. Label6.Caption := IntToStr(mynode.AbsoluteIndex);
 f:= true;
 Edit1.Clear;
 Edit2.Clear;
 Edit3.Clear;
 Edit4.Clear;
 Edit5.Clear;
end;

procedure TForm3.Button1Click(Sender: TObject);
var
  i,id_st: integer;
begin
if (Edit3.Text = Edit4.Text) and (Edit3.Text <> '') then
begin
  if Edit1.Text = '' then
    Edit1.Text := '-';
  if Edit2.Text = '' then
    Edit2.Text := '-';
  if Edit3.Text = '' then
    Edit3.Text := '-';
  if Edit4.Text = '' then
    Edit4.Text := '-';
  if Edit5.Text = '' then
    Edit5.Text := '-';
// «апись при успешной проверке во временную переменную
  output_s.id := eof_file_p;
  output_s.name:= Edit1.Text;
  output_s.log:=Edit2.Text;
  output_s.coments[1] := '123';
  output_s.pass:= Edit3.Text;
  output_s.path:= edit5.Text;
  output_s.id_catal:=mynode.AbsoluteIndex;
  output_s.delet := 0;

// запись в сам фаил
  write(file_pass, output_s);
  Pass_reset2;
  Form3.Close;
  Label6.Caption := Inttostr(eof_file_p);

end
else
begin
  ShowMessage('ѕароли не совпадают');
end;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Pass_reset2;
Main.Enabled:=true;
end;

procedure TForm3.SpeedButton1Click(Sender: TObject);
begin
Edit3.Clear;
Edit4.Clear;
random_pass;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
Edit1.Clear;
Edit2.Clear;
Edit3.Clear;
Edit4.Clear;
Edit5.Clear;
end;

procedure TForm3.SpeedButton2Click(Sender: TObject);
begin
if f = true then
begin
  Edit3.PasswordChar := '*';
  Edit4.PasswordChar := '*';
end
else
begin
  Edit3.PasswordChar := Char(#0);
  Edit4.PasswordChar := Char(#0);
end;
end;

procedure TForm3.Button4Click(Sender: TObject);
begin
  form4.show;
  form3.Hide;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
form3.Close;
end;

end.
