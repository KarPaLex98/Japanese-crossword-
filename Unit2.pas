unit Unit2;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Grid, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.TextLayout, FMX.MultiView, FMX.Menus,
  FMX.Layouts, FMX.ListBox, FMX.Edit, FMX.EditBox, FMX.NumberBox, FMX.Ani ;

  procedure SaveStringGrid(StringGrid: TStringGrid; const FileName: TFileName);
  procedure LoadStringGrid(var StringGrid: TStringGrid; const FileName: TFileName);

implementation

uses Unit1;

procedure SaveStringGrid(StringGrid: TStringGrid; const FileName: TFileName);
 var
   f:    TextFile;
   i, j: Integer;
 begin
   AssignFile(f, FileName);
   Rewrite(f);
   with StringGrid do
   begin
    Writeln(f, ColumnCount);
    Writeln(f, RowCount);
    Writeln(f, max_bok);
    Writeln(f, max_verh);
    Writeln(f, zoom);
    for i := 0 to RowCount-1 do //заполнение таблицы
      for j := 0 to ColumnCount-1 do
         Writeln(F, Cells[j, i]);
   end;
   CloseFile(F);
 end;

procedure LoadStringGrid(var StringGrid: TStringGrid; const FileName: TFileName);
var
  f: TextFile;
  i, j: Integer;
  strTemp: String;
  colCountStr: string;
  colCount: integer;
  rowCountStr: string;
  max_bokStr, max_verhStr: string;
  zoomStr:string;
begin
  AssignFile(f, FileName);
  Reset(f);
  with StringGrid do
  begin
    Readln(f, colCountStr);
    colCount:=strtoint(colCountStr);
    Readln(f, rowCountStr);
    RowCount := strtoint(rowCountStr);
    readln(f, max_bokStr);
    readln(f, max_verhStr);
    readln(f, zoomStr);
    max_bok := strtoint(max_bokStr);
    max_verh := strtoint(max_verhStr);
    zoom := strtoint(zoomStr);
    for i := 0 to colCount-1 do //создание столбцов
    begin
      AddObject(TStringColumn.Create(nil));
      ColumnByIndex(i).Width:=zoom;  //размеры €чейки
    end;
    RowHeight:=zoom;
    for i := 0 to RowCount-1 do //заполнение таблицы
      for j := 0 to ColumnCount-1 do
      begin
        readln(f, strTemp);
        Cells[j, i]:=strTemp;
      end;
    TempSG:=TStringGrid.Create(Form1);
    for i := 0 to ColumnCount-1 do //создание столбцов
    begin
      TempSG.AddObject(TStringColumn.Create(nil));
      TempSG.ColumnByIndex(i).Width:=zoom;  //размеры €чейки
    end;
    TempSG.RowCount := RowCount;
    for i := 0 to TempSG.RowCount-1 do //ƒл€ проверки
      for j := 0 to TempSG.ColumnCount-1 do
      begin
        TempSG.Cells[j,i]:=Cells[j,i];
      end;;
    for i := max_verh to RowCount-1 do //заполнение таблицы
      for j := max_bok to ColumnCount-1 do
      begin
        Cells[j,i]:=inttostr(10000);
      end;;
  end;
 end;

end.
