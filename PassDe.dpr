program PassDe;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Login},
  Unit2 in 'Unit2.pas' {Main},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TLogin, Login);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
