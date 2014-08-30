unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type

  TForm4 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;


implementation

uses
  Unit2;

{$R *.dfm}

procedure admin();
var
i:integer;
out_a: save_pass;
begin
i:=0;
Seek(file_pass,i);
  while eof(file_pass) = false do
  begin
  Read(file_pass,out_a);
  Form4.Memo1.Lines.Add( IntToStr(out_a.id)+' '+ out_a.name+' '+out_a.log+' '+out_a.pass+' '+out_a.path+' '+IntToStr(out_a.id_catal)+' || '+ IntToStr(out_a.delet));
  i:=i+1;
  Seek(file_pass,i);
  end;
end;



procedure TForm4.Button1Click(Sender: TObject);
begin
  Memo1.Clear;
  admin;
  //Main.Show;
end;

end.
