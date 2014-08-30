unit Unit2;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ComCtrls, Clipbrd, Menus;

type
  save_pass = record  // тип для записи паролей
    id: Integer;
    name:string[255];
    log:string[255];
    coments: array [0..99] of string[255];
    pass:string[255];
    path:string[255];

    id_catal, delet: Integer;
  end;
  catal = record       // тип для записи каталогов
    id: integer;
    name: String[255];
    uroven: integer;
    image: Integer;
  end;
  TMain = class(TForm)
    TreeView1: TTreeView;
    ListView1: TListView;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label1: TLabel;
    SpeedButton4: TSpeedButton;
    Button3: TButton;
    SpeedButton5: TSpeedButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ListView1Changing(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    //procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;
  Exp_col:boolean;
  file_pass,r_file_pass, t_file_p:file of save_pass;
  file_cat,t_file_c: file of catal;
  output_s: save_pass;
  output_c: catal;
  result_db: boolean;  // результат проверки нна существование файла с паролями
  result_cat: boolean;  // результат проверки на существвование файла с каталагами
  mynode: TTreeNode;
  list_level,id_pass:integer;
  byfer: TClipboard;
  a_id_pass: array of string[255];
  g_id_pass: array of integer;
  vis:integer;

implementation

uses Unit1, Unit3, Unit4;

{$R *.dfm}

// процедура отката изменений  -----------------------------------
procedure return_m();
var
  i:integer;
begin
  AssignFile(t_file_p,'pass.~sp');
  //AssignFile(t_file_c,'cat.~sc');
  //AssignFile(file_cat,'database.ca');
  AssignFile(file_pass,'database.sp');
  reset(t_file_p);
  //reset(t_file_c);
  Rewrite(file_pass);
  //Rewrite(file_cat);
  i:=0;
  //seek(file_cat,i);
  seek(file_pass,i);
  seek(t_file_p,i);
  //seek(t_file_c,i);
  while Eof(t_file_p) = false do
  begin
    read(t_file_p,output_s);
    write(file_pass,output_s);
    i:=i+1;
    seek(file_pass,i);
    seek(t_file_p,i);
  end;
  (*while Eof(t_file_c) = false do
  begin
    read(t_file_c,output_c);
    write(file_cat,output_c);
    i:=i+1;
    seek(t_file_c,i);
    seek(file_cat,i);
  end; *)
end;
//----------------------------------------------------------------
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
// процедура копировавния файлов с паролем и каталогов -----------
procedure copy_file();
var
  i:integer;
begin
  AssignFile(t_file_p,'pass.~sp');
  AssignFile(t_file_c,'cat.~sc');
  rewrite(t_file_p);
  rewrite(t_file_c);
  i:=0;
  seek(file_cat,i);
  while Eof(file_cat) = false do
    begin
      read(file_cat,output_c);
      write(t_file_c,output_c);
      i:=i+1;
      seek(file_cat,i);
    end;
  i:=0;
  Seek(file_pass,i);
  while Eof(file_pass) = false do
    begin
      read(file_pass,output_s);
      write(t_file_p,output_s);
      i:=i+1;
      seek(file_pass,i);
    end;
  CloseFile(t_file_p);
  CloseFile(t_file_c);
end;

//----------------------------------------------------------------
// функция сравнения файла катологов с его копией------------------------
function compare():boolean;
var
  i,c_end: integer;
  t_out_p,out_p:catal;
  result_m:boolean;
begin
  c_end:=0;
  result_m:=false;
  AssignFile(t_file_c,'cat.~sc');
  AssignFile(file_cat,'database.ca');
  reset(file_cat);
  if FileExists('cat.~sc') = true then
    begin
    i:=0;
    reset(t_file_c);
    Seek(file_cat,i);
    Seek(t_file_c,i);
    while c_end = 0 do
    begin
      if Eof(file_cat) = false then
      begin
        if Eof(t_file_c) = false then
        begin
        read(file_cat,out_p);
        read(t_file_c,t_out_p);
        if out_p.id <> t_out_p.id then
          result_m:=true;
        if out_p.name <> t_out_p.name then
          result_m:=true;
        if out_p.uroven <> t_out_p.uroven then
          result_m:=true;
        if out_p.image <> t_out_p.image then
          result_m:=true;
        i:=i+1;
        Seek(file_cat,i);
        Seek(t_file_c,i);
        //ShowMessage('прощли '+inttostr(i));
      end
      else
      begin
      c_end:=1;
      result_m:=true;
      end;
      end
      else
      begin
      c_end:=1;
      if Eof(t_file_c) = false then
        result_m:=true;
      end;
    end;
    end;
  compare:=result_m;
end;
//----------------------------------------------------------------
// функция проверки изменений в файле с паролями

function compare_p():boolean;
var
  i,c_end,cikl: integer;
  t_out_p,out_p:save_pass;
  result_m:boolean;
begin
//ShowMessage('начали proc_p');
  c_end:=0;
  result_m:=false;
  //ShowMessage('дошли до сввязки с pass~');
  AssignFile(t_file_p,'pass.~sp');
  //ShowMessage('дошли до database');
  AssignFile(file_pass,'database.sp');
  //ShowMessage('дошли до ресета');
  reset(file_pass);
    //ShowMessage('дошли до проверки файла pass');
  if FileExists('pass.~sp') = true then
    begin
    i:=0;
     // ShowMessage('дошли до ресета t_file_p');
    reset(t_file_p);
      //ShowMessage('дошли до seek file pass');
    Seek(file_pass,i);
          //ShowMessage('дошли до seek t file pass');
    Seek(t_file_p,i);
    while c_end = 0 do
    begin
      if Eof(file_pass) = false then
      begin
      //ShowMessage('прошли проверку существования файла');
        if Eof(t_file_p) = false then
        begin
        //ShowMessage('дошли до считывания file pass');
        read(file_pass,out_p);
        //ShowMessage('дошли до считывания t file pass');
        read(t_file_p,t_out_p);
        //ShowMessage('прошли все считывания и дошли до проверок');
        if out_p.id <> t_out_p.id then
          result_m:=true;
        //ShowMessage('прошли out_p.id <> t_out_p.id');
        if out_p.name <> t_out_p.name then
          result_m:=true;
        //ShowMessage('прошли out_p.name <> t_out_p.name');
        if out_p.log <> t_out_p.log then
          result_m:=true;
        //ShowMessage('прошли out_p.log <> t_out_p.log');
        (*for cikl:=0 to 255 do
        if out_p.coments[cikl] <> t_out_p.coments[cikl] then
          result_m:=true;*) // критическая ошибка обработки массива
        if out_p.pass <> t_out_p.pass then
          result_m:=true;
        if out_p.path <> t_out_p.path then
          result_m:=true;
        if out_p.id_catal <> t_out_p.id_catal then
          result_m:=true;
        if out_p.delet <> t_out_p.delet then
          result_m:=true;
        i:=i+1;
        Seek(file_pass,i);
        Seek(t_file_p,i);
        //ShowMessage('прошли pass '+inttostr(i));
      end
      else
      begin
      c_end:=1;
      result_m:=true;
      end;
      end
      else
      begin
      c_end:=1;
      if Eof(t_file_p) = false then
        result_m:=true;
      end;
    end;
    end;
  compare_p:=result_m;
 //ShowMessage('прошли pass 0');
  closefile(file_pass);
  closefile(t_file_p);
end;

//-----------------------------------------
// процедура обновления списка -----------------------------------

procedure Pass_reset2();
var
  i,number_str,test: integer;
  out_pass: save_pass;

begin
    Main.ListView1.Clear;
    i:=0;
    number_str:=0;
    SetLength(a_id_pass,0);
    SetLength(g_id_pass,0);
    Seek(file_pass,number_str);
    test:=1;
   while Eof(file_pass) = false do
   begin

    read(file_pass,out_pass);
    SetLength(a_id_pass,test);
    SetLength(g_id_pass,test);
    if out_pass.id_catal = mynode.AbsoluteIndex then
      begin
      if out_pass.delet = 0 then
      begin
        Main.ListView1.Items.Add.Caption:=out_pass.name;
        Main.ListView1.Items[i].SubItems.Add(out_pass.log);
        Main.ListView1.Items[i].SubItems.Add('******');
        Main.ListView1.Items[i].SubItems.Add(out_pass.path);

        a_id_pass[test - 1] := out_pass.pass;
        g_id_pass[test - 1] := out_pass.id;
        id_pass := out_pass.id;

        test:=test+1;
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

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i,urov,bytton_vibor:integer;
begin

CloseFile(file_pass);
AssignFile(file_cat,'database.ca');
Rewrite(file_cat);
    i:=0;
    mynode := TreeView1.Items[0];
if mynode <> nil then
    begin
    try
    repeat
      output_c.name := TreeView1.Items[i].Text;
      output_c.id := i;
      output_c.uroven := TreeView1.Items[i].Level;
      output_c.image := TreeView1.Items[i].ImageIndex;
      Write(file_cat,output_c);
      mynode.getNext;
      i:=i+1;
    until mynode = nil
    except

    end;
end;
if compare_p = true then
  begin
  bytton_vibor := MessageDlg('Сохранить изменения паролей?',mtConfirmation,[mbYes,mbNo],0);
  if bytton_vibor = mrNo then
  begin
    return_m(); // -----написать процедуру замены настоящего файла его копией
  end;
end;
CloseFile(file_cat);
//CloseFile(file_pass);
login.close;
end;

procedure TMain.FormShow(Sender: TObject);
var
  i,urov:integer;
begin
  ListView1.Clear;
  AssignFile(file_cat,'database.ca');
  AssignFile(file_pass,'database.sp');

if FileExists('database.sp') = true then
  begin
    result_db:=true;
    Reset(file_pass);
    try
    //Pass_reset2;
    except
    end;
  end
  else
  begin
    result_db:=false;
    Rewrite(file_pass);

  end;


//==========================================//
//  Создание, проверка существования        //
//  каталогов и их загрузка и их последующее//
//  сохранение                              //
//==========================================//
  if FileExists('database.ca') =  true then
  begin
    result_cat:= true;
    Reset(file_cat);
    seek(file_cat,0);
    i:=0;
    urov := 0;
    repeat                                                                        // выполняет хоть одно чтение
      Read(file_cat,output_c);
      if output_c.uroven > urov then
      begin

        TreeView1.Items.AddChild(mynode,output_c.name);
        TreeView1.Items[output_c.id].Selected := true;
        TreeView1.Items[output_c.id - 1].Selected := false;
        TreeView1.Items[output_c.id].ImageIndex := output_c.image;
      end
      else
      begin
        if output_c.uroven = 0 then
        begin
          if output_c.id <> 0 then
          begin
          mynode := TreeView1.Items[0];
          TreeView1.Items.Add(mynode,output_c.name);
          TreeView1.Items[output_c.id].Selected := true;
          TreeView1.Items[output_c.id -1].Selected := false;
          TreeView1.Items[output_c.id].ImageIndex := output_c.image;
          end
          else
          begin
          TreeView1.Items.Add(mynode,output_c.name);
          TreeView1.Items[output_c.id].Selected := true;
          TreeView1.Items[output_c.id].ImageIndex := output_c.image;
          end;
        end
        else
        begin
          TreeView1.Items.Add(mynode,output_c.name);
          TreeView1.Items[output_c.id].Selected := true;
          TreeView1.Items[output_c.id].ImageIndex := output_c.image;
        end;
        end;
   

      i:=i+1;
      seek(file_cat,i);
      urov := output_c.uroven;
    until Eof(file_cat);
  end
  else                                  // если не существуют
  begin
    result_cat:=false;
    Rewrite(file_cat);
    TreeView1.Items.Add(mynode,'Базовые');
    TreeView1.Items[0].Selected := true;
    TreeView1.Items[0].ImageIndex := -1;
    TreeView1.Items.AddChild(mynode,'ОС');
    TreeView1.Items[1].ImageIndex := -1;
    TreeView1.Items.AddChild(mynode,'Интернет');
    TreeView1.Items[2].ImageIndex := -1;
    TreeView1.Items.AddChild(mynode,'Игры');
    TreeView1.Items[3].ImageIndex := -1;
    TreeView1.Items.Add(mynode,'Прочее');
    TreeView1.Items[4].ImageIndex:= -1;
    i:=0;

    mynode := TreeView1.Items[0];
if mynode <> nil then
    begin
    try
    repeat
      output_c.name := TreeView1.Items[i].Text;
      output_c.id := i;
      output_c.uroven := TreeView1.Items[i].Level;
      output_c.image := TreeView1.Items[i].ImageIndex;
      Write(file_cat,output_c);
      mynode.getNext;
      i:=i+1;
    until mynode = nil
    except
    end;
    end;
  end;
    // =====================
  // работа с самими паролями
  //
  //
  //
  //

  Exp_col:=true;
  TreeView1.FullExpand;
  TreeView1.Items[0].Selected := true;

  copy_file;

  (*m_onshow(vis);
  if vis = 0 then
  begin
  login.Show;

   end; *)
end;

procedure TMain.SpeedButton1Click(Sender: TObject);
begin
  if Exp_col = true then // он разернут
  begin
    TreeView1.FullCollapse;
    Exp_col:=false;
  end
  else
  begin
    treeview1.FullExpand;
    Exp_col:=true;
  end;
end;

procedure TMain.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
mynode:= node;
Pass_reset2;
end;

procedure TMain.Button1Click(Sender: TObject);
var
  lev,mes: integer;
begin
lev := mynode.Level;
  if Edit1.Text <> '' then
    if lev > 0 then
    TreeView1.Items.AddChild(mynode,edit1.Text)
    else
    begin
      mes :=MessageDlg('Добавть потомка ?',mtConfirmation,mbYesNoCancel, 0);
      case mes of
      6: TreeView1.Items.AddChild(mynode,edit1.Text);
      7: TreeView1.Items.Add(mynode,Edit1.Text);
      end;
    end
    else
    ShowMessage('Введите имя каталога');
end;

procedure TMain.Button2Click(Sender: TObject);
begin
  TreeView1.Items.Delete(mynode);
end;

procedure TMain.SpeedButton2Click(Sender: TObject);
begin
form3.show;
Main.Enabled:=false;
end;




procedure TMain.ListView1Changing(Sender: TObject; Item: TListItem;
  Change: TItemChange; var AllowChange: Boolean);
begin
try
 list_level:= Item.Index;
 Label1.Caption:= IntToStr(list_level);
 SpeedButton4Click(Self);
 id_pass := g_id_pass[list_level];
except
end;

end;



procedure TMain.SpeedButton4Click(Sender: TObject);
begin
Clipboard.Clear;
 try
 Clipboard.AsText := a_id_pass[list_level];
 Except
 ShowMessage('Выберите строку откуда хотите копировать пароль');
 end;
end;

procedure TMain.Button3Click(Sender: TObject);
begin
form4.show
end;

procedure TMain.SpeedButton3Click(Sender: TObject);
var
  test,i,number_str:integer;
    out_pass: save_pass;
begin
AssignFile(r_file_pass,'datapass.rsp');
Rewrite(r_file_pass);
test:=0;
seek(file_pass,test);
   while Eof(file_pass) = false do
   begin
    read(file_pass,out_pass);
    if out_pass.id = id_pass then
          out_pass.delet:=1;
        write(r_file_pass,out_pass);
        test:=test+1;
        Seek(file_pass,test);
   end;
test := 0;
seek(r_file_pass,test);
CloseFile(file_pass);
AssignFile(file_pass,'database.sp');
rewrite(file_pass);
   while Eof(r_file_pass) = false do
   begin
    read(r_file_pass,out_pass);
        write(file_pass,out_pass);
        test:=test+1;
        Seek(r_file_pass,test);
   end;

ListView1.Items[list_level].Delete;

end;


procedure TMain.N1Click(Sender: TObject);
begin
main.Show;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
vis:=0;
end;

end.
