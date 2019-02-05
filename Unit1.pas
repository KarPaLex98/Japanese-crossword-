unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Grid, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.TextLayout, FMX.MultiView, FMX.Menus,
  FMX.Layouts, FMX.ListBox, FMX.Edit, FMX.EditBox, FMX.NumberBox, FMX.Ani;
type
  TOpenColumn = class (TColumn);
  TRGB=record
  b,g,r : byte;
   end;
  ARGB=array [0..1] of TRGB;
  PARGB=^ARGB;
  TForm1 = class(TForm)
    Image1: TImage;
    SG: TStringGrid;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    StyleBook1: TStyleBook;
    MultiView1: TMultiView;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    Layout1: TLayout;
    TrackBar1: TTrackBar;
    Brush1: TBrushObject;
    ScaledLayout1: TScaledLayout;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton2: TSpeedButton;
    TrackBar2: TTrackBar;
    Label4: TLabel;
    Layout3: TLayout;
    Label5: TLabel;
    ScaledLayout2: TScaledLayout;
    SpeedButton7: TSpeedButton;
    SaveDialog1: TSaveDialog;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Label8: TLabel;
    Edit1: TEdit;
    Layout2: TLayout;
    ScaledLayout3: TScaledLayout;
    Label10: TLabel;
    Label11: TLabel;
    NumberBox1: TNumberBox;
    NumberBox2: TNumberBox;
    SpeedButton3: TSpeedButton;
    Label12: TLabel;
    SpeedButton4: TSpeedButton;
    Edit2: TEdit;
    Label13: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    ListBoxItem4: TListBoxItem;
    AniIndicator1: TAniIndicator;
    procedure Button1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SGDrawColumnCell(Sender: TObject; const Canvas: TCanvas;
  const Column: TColumn; const Bounds: TRectF; const Row: Integer;
  const Value: TValue; const State: TGridDrawStates);
    procedure SGCellClick(const Column: TColumn; const Row: Integer);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure ListBoxItem3Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure ListBoxItem4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SGCellDblClick(const Column: TColumn; const Row: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private

  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  put: string;
  ImMas: array of array of integer; //массив для заполнения ячеек sringgrid'а
  col_count,row_count:integer; //размерность ImMas
  zoom:integer;
  verh, bok: array of array of integer;//цифры сбоку и сверху
  koleso: boolean;
  max_bok,max_verh: integer;
  balans: real = 126;
  TempSG: TStringGrid;
  dblcl: boolean = false;
  ctrl: boolean = false;
implementation

{$R *.fmx}

uses Unit2, Unit3, Unit4, Unit5 ;

procedure TForm1.ListBoxItem1Click(Sender: TObject);
var
  i: integer;
begin
  try
    OpenDialog1.Filter := 'Изображения (bmp,jpeg,jpg,png,ico)|*.bmp;*.jpeg;*.jpg;*.png;*.ico';
    if OpenDialog1.Execute then
      put:=OpenDialog1.FileName
    else exit;
  except
    ShowMessage('Данное изображение не существует или неверный формат изображения! Выберите другой файл.');
  end;
  //AniIndicator1.Visible:=true;
  //AniIndicator1.Enabled:=true;
  Image1.Bitmap.LoadFromFile(put);
  Image2.Bitmap:=Image1.Bitmap;
  BlackWhite(Image1);
  col_count:=50;
  row_count:=50;
  for i:=SG.ColumnCount-1 downto 0 do
    SG.Columns[i].Destroy;
  SG.RowCount:=0;
  Pixalization(Image1,col_count,row_count);
  ZapolnenieSG;
  SG.OnCellClick := nil;
  Layout1.Visible:=true;
  Layout2.Visible:=false;
  Layout3.Visible:=false;
  Image3.Visible:=false;
  Image3.Enabled:=false;
  dblcl:=false;
  MultiView1.HideMaster;
  //AniIndicator1.Enabled:=false;
  //AniIndicator1.Visible:=false;
end;

procedure TForm1.ListBoxItem2Click(Sender: TObject);
var
  i,j:integer;
begin
  //AniIndicator1.Enabled:=true;
  zoom:=20;
  for i:=SG.ColumnCount-1 downto 0 do
    SG.Columns[i].Destroy;
  SG.RowCount:=0;
  NumberBox1.Value:=20;
  NumberBox2.Value:=20;
  col_count:=20;
  row_count:=20;
  SG.RowCount:=row_count;
  for i := 0 to col_count-1 do //создание столбцов
  begin
    SG.AddObject(TStringColumn.Create(nil));
    SG.ColumnByIndex(i).Width:=zoom;  //размеры ячейки
  end;
  SG.RowHeight:=zoom;
  for i := 0 to row_count-1 do //заполнение таблицы
    for j := 0 to col_count-1 do
    begin
      SG.Cells[j,i]:='10000';
    end;
  Layout1.Visible:=false;
  Layout2.Visible:=true;
  Layout3.Visible:=false;
  SG.OnCellClick := SGCellClick;
  Image3.Visible:=false;
  Image3.Enabled:=false;
  dblcl:=false;
  MultiView1.HideMaster;
  //AniIndicator1.Enabled:=false;
end;

procedure TForm1.ListBoxItem3Click(Sender: TObject);
var
  put:string;
  i:integer;
begin
  try
    OpenDialog1.Filter := 'Японские кроссворды (.jc)|*.jc|';
    if OpenDialog1.Execute then
      put:=OpenDialog1.FileName
    else exit;
    for i:=SG.ColumnCount-1 downto 0 do
    SG.Columns[i].Destroy;
    SG.RowCount:=0;
    LoadStringGrid(SG,put);
  except
    ShowMessage('Файл не существует или неверный формат файла! Выберите другой файл.');
  end;
  SG.OnCellClick := SGCellClick;
  Layout1.Visible:=false;
  Layout2.Visible:=false;
  Layout3.Visible:=true;
  Image3.Visible:=false;
  Image3.Enabled:=false;
  dblcl:=true;
  MultiView1.HideMaster;
end;

procedure TForm1.ListBoxItem4Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    put:=OpenDialog1.FileName
  else exit;
  //AniIndicator1.Enabled:=true;
  Image1.Bitmap.LoadFromFile(put);
  BlackWhite(Image1);
  TrackBar1.Value:=50;
  Pixalization(Image1,col_count,row_count);
  ZapolnenieSG;
  //AniIndicator1.Enabled:=false;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  //AniIndicator1.Enabled:=true;
  col_count:=1;
  row_count:=1;
  Pixalization(Image1,col_count,row_count);
  ZapolnenieSG;
  col_count:=round(TrackBar1.Value);
  row_count:=round(TrackBar1.Value);
  Pixalization(Image1,col_count,row_count);
  ZapolnenieSG;
  //AniIndicator1.Enabled:=false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SG.OnCellClick := nil;
  SG.OnDrawColumnCell:=SGDrawColumnCell;
  dblcl:= false;
  ctrl:= false;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if key=17 then
    ctrl:=true;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if key=17 then
    ctrl:=false;
end;

function Proverka(number: integer): boolean;
begin
  case number of
  0..150: result:=true
  else result:=false;
  end;
end;

procedure TForm1.SGDrawColumnCell(Sender: TObject; const Canvas: TCanvas;
  const Column: TColumn; const Bounds: TRectF; const Row: Integer;
  const Value: TValue; const State: TGridDrawStates);
var
  aTextRect:   TRectF;
  str: string;
begin
  if value.tostring = '10000' then
  begin
    aTextRect := Bounds;
    aTextRect.Right := Round(aTextRect.Right) + 1;
    aTextRect.Bottom := Round(aTextRect.Bottom) - 1;
    Canvas.FillRect(aTextRect, 0, 0, AllCorners, 1);
    Canvas.ClearRect(aTextRect, TAlphaColorRec.White);
  end;
  if value.tostring = '10001' then
  begin
    aTextRect := Bounds;
    aTextRect.Right := Round(aTextRect.Right) + 1;
    aTextRect.Bottom := Round(aTextRect.Bottom) - 1;
    Canvas.FillRect(aTextRect, 0, 0, AllCorners, 1);
    Canvas.ClearRect(aTextRect, TAlphaColorRec.Black);
  end;
  str:=value.ToString;
  if str<>'(empty)' then
  begin
    if Proverka(strtoint(value.ToString)) then
    begin
      aTextRect := Bounds;
      aTextRect.Right := Round(aTextRect.Right) + 6;
      aTextRect.Bottom := Round(aTextRect.Bottom) + 4;
      Canvas.FillRect(aTextRect, 0, 0, AllCorners, 1);
      Canvas.ClearRect(aTextRect, TAlphaColorRec.Silver);
      Canvas.FillText(Bounds, Value.ToString, false, 100, [TFillTextFlag.ftRightToLeft], TTextAlign.taCenter, TTextAlign.taCenter);
    end;
  end
  else
  begin
      aTextRect := Bounds;
      aTextRect.Right := Round(aTextRect.Right) + 6;
      aTextRect.Bottom := Round(aTextRect.Bottom) + 4;
      Canvas.FillRect(aTextRect, 0, 0, AllCorners, 1);
      Canvas.ClearRect(aTextRect, TAlphaColorRec.Silver);
  end;
  if value.tostring = '10003' then
  begin
    aTextRect := Bounds;
    aTextRect.Right := Round(aTextRect.Right) + 1;
    aTextRect.Bottom := Round(aTextRect.Bottom) - 1;
    Canvas.FillRect(aTextRect, 0, 0, AllCorners, 1);
    Canvas.ClearRect(aTextRect, TAlphaColorRec.Blanchedalmond);
  end;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
var
  i:integer;
begin
  if ctrl=true then
  begin
    zoom:=zoom+WheelDelta div 100;
    if zoom<15 then
    begin
      zoom:=15;
      exit;
    end;
    if zoom>80 then
    begin
      zoom:=80;
      exit;
    end;
    for i := 0 to SG.ColumnCount-1 do //создание столбцов
    begin
      SG.ColumnByIndex(i).Width:=zoom;  //размеры ячейки
    end;
    SG.RowHeight:=zoom;
  end;
end;

procedure TForm1.SGCellClick(const Column: TColumn; const Row: Integer);
begin
  if SG.Cells[Column.Index,row]='' then exit;
  case strtoint(SG.Cells[Column.Index,row]) of
    10000: SG.Cells[Column.Index,row]:='10001';
    10001: SG.Cells[Column.Index,row]:='10000';
    10003: SG.Cells[Column.Index,row]:='10001';
  end;
  if (dblcl=true) and (ctrl=true) then
  case strtoint(SG.Cells[Column.Index,row]) of
    10000: SG.Cells[Column.Index,row]:='10003';
    10001: SG.Cells[Column.Index,row]:='10003';
  end;
end;

procedure TForm1.SGCellDblClick(const Column: TColumn; const Row: Integer);
begin
  if SG.Cells[Column.Index,row]='' then exit;
  if dblcl then
  case strtoint(SG.Cells[Column.Index,row]) of
    10000: SG.Cells[Column.Index,row]:='10003';
    10001: SG.Cells[Column.Index,row]:='10003';
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Image3.Visible:=false;
  Image3.Enabled:=false;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  i:integer;
begin
  //AniIndicator1.Enabled:=true;
  for i:=SG.ColumnCount-1 downto 0 do
    SG.Columns[i].Destroy;
  SG.RowCount:=0;
  Image1.Bitmap:=Image2.Bitmap;
  BlackWhite(Image1);
  col_count:=round(TrackBar1.Value);
  row_count:=round(TrackBar1.Value);
  Pixalization(Image1,col_count,row_count);
  ZapolnenieSG;
  //AniIndicator1.Enabled:=false;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
var
  i,j:integer;
begin
  //AniIndicator1.Enabled:=true;
  for i:=SG.ColumnCount-1 downto 0 do
    SG.Columns[i].Destroy;
  SG.RowCount:=0;
  col_count:=round(NumberBox1.Value);
  row_count:=round(NumberBox2.Value);
  SG.RowCount:=row_count; //количество строк
  for i := 0 to col_count-1 do //создание столбцов
  begin
    SG.AddObject(TStringColumn.Create(nil));
    SG.ColumnByIndex(i).Width:=zoom;  //размеры ячейки
  end;
  SG.RowHeight:=zoom;
  for i := 0 to row_count-1 do //заполнение таблицы
    for j := 0 to col_count-1 do
    begin
      SG.Cells[j,i]:='10000';
    end;
  //AniIndicator1.Enabled:=false;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
var
  i,j,isg,jsg:integer;
  put: string;
begin  SetLength(ImMas,row_count,col_count);
  for i := 0 to row_count-1 do //заполнение Матрицы
    for j := 0 to col_count-1 do
    begin
      ImMas[i,j]:=strtoint(SG.Cells[j,i]);
    end;
  UdaleniePustihStolbcov_strok;
  zoom:=20;
  SetLength(verh,row_count,col_count);
  SetLength(bok,row_count,col_count);
  ZapolnenieCifri; //подсчёт групп
  for i:=SG.ColumnCount-1 downto 0 do
    SG.Columns[i].Destroy;
  SG.RowCount:=0;
  SG.RowCount:=row_count+max_verh; //количество строк
  for i := 0 to col_count-1+max_bok do //создание столбцов
  begin
    SG.AddObject(TStringColumn.Create(nil));
    SG.ColumnByIndex(i).Width:=zoom;  //размеры ячейки
  end;
  //Заполнение цифрами
  Cifri(isg,jsg);
  SG.RowHeight:=zoom; //размеры ячейки
  for i := 0 to row_count-1 do //заполнение таблицы
    for j := 0 to col_count-1 do
    begin
      SG.Cells[j+max_bok,i+max_verh]:=inttostr(ImMas[i,j]);
    end;
  if Edit2.Text='' then
  begin
    ShowMessage('Введите название кроссворда!');
    exit;
  end;
  CreateDir('Кроссворды');
  put:='Кроссворды\'+Edit2.Text+'.jc';
  SaveStringGrid(SG, put);
  ShowMessage('Кроссворд успешно сохранён');
  //UdaleniePustihStolbcov_strok;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  SG.OnCellClick := SGCellClick;
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
var
  put:string;
begin
  if Edit1.Text='' then
  begin
    ShowMessage('Введите название кроссворда!');
    exit;
  end;
  CreateDir('Кроссворды');
  put:='Кроссворды\'+Edit1.Text+'.jc';
  SaveStringGrid(SG, put);
  ShowMessage('Кроссворд успешно сохранён');
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin
  Checking;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  col_count:=round(TrackBar1.Value);
  row_count:=round(TrackBar1.Value);
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
  balans:=TrackBar2.Value;
end;

end.
