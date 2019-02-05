unit Unit5;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Grid, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.TextLayout, FMX.MultiView, FMX.Menus,
  FMX.Layouts, FMX.ListBox, FMX.Edit, FMX.EditBox, FMX.NumberBox, FMX.Ani ;

Procedure Cifri(var isg,jsg: integer);
procedure Checking;
procedure ZapolnenieSG;

implementation

uses Unit1, Unit4;

Procedure Cifri(var isg,jsg: integer);
var i,j:integer;
begin
  isg:=max_verh-1; //запись в таблицу цифр слева
  for i := 0 to row_count-1 do
  begin
    jsg:=max_bok-1;
    inc(isg);
    for j:=max_bok-1 downto 0 do
    begin
      if bok[i,j]<>0 then
      begin
        Form1.SG.Cells[jsg,isg]:=IntToStr(bok[i,j]);
        dec(jsg);
      end;
    end;
  end;
  jsg:=max_bok-1;  //запись в таблицу цифр сверху
  for j := 0 to col_count-1 do
  begin
    isg:=max_verh-1;
    inc(jsg);
    for i:=max_verh-1 downto 0 do
    begin
      if verh[i,j]<>0 then
      begin
        Form1.SG.Cells[jsg,isg]:=IntToStr(verh[i,j]);
        dec(isg);
      end;
    end;
  end;
end;

procedure Checking;
var
  i,j: integer;
  flag: boolean;
  str: string;
  Label go;
begin
  flag:=false;
  for i := 0 to TempSG.RowCount-1 do //заполнение таблицы
    for j := 0 to TempSG.ColumnCount-1 do
    begin
      str:=Form1.SG.Cells[j,i];
      if str='10003' then str:='10000';
      if TempSG.Cells[j,i]=str then flag:=true
      else
      begin
        flag:= false;
        GoTo go;
      end;
    end;
 go:
 if flag=true then
  ShowMessage(' россворд решЄн верно')
 else
  ShowMessage(' россворд решЄн не верно');
end;

procedure ZapolnenieSG;
var
  i,j,isg,jsg:integer;
begin
  zoom:=20;
  SetLength(verh,row_count,col_count);
  SetLength(bok,row_count,col_count);
  ZapolnenieCifri; //подсчЄт групп
  Form1.SG.RowCount:=row_count+max_verh; //количество строк
  for i := 0 to col_count-1+max_bok do //создание столбцов
  begin
    Form1.SG.AddObject(TStringColumn.Create(nil));
    Form1.SG.ColumnByIndex(i).Width:=zoom;  //размеры €чейки
  end;
  Cifri(isg,jsg);
  Form1.SG.RowHeight:=zoom; //размеры €чейки
  for i := 0 to row_count-1 do //заполнение таблицы
    for j := 0 to col_count-1 do
    begin
      Form1.SG.Cells[j+max_bok,i+max_verh]:=inttostr(ImMas[i,j]);
    end;
  //UdaleniePustihStolbcov_strok;
end;

end.
