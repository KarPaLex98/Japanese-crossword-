unit Unit3;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Grid, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.TextLayout, FMX.MultiView, FMX.Menus,
  FMX.Layouts, FMX.ListBox, FMX.Edit, FMX.EditBox, FMX.NumberBox, FMX.Ani ;

  procedure BlackWhite(var picture:timage);
  function RGBToBlackWhite(RGBColor : TColor) : TColor;
  procedure Pixalization(picture: timage; col_count,row_count:integer);

implementation

//ѕреобразование пиксел€ в черный или белый


uses Unit1, Unit4;

function RGBToBlackWhite(RGBColor : TColor) : TColor;
var Gray, r,g,b : byte;
begin
  r := RGBColor;
  g := RGBColor shr 8;
  b := RGBColor shr 16;
  Gray :=Round(0.30*r+0.59*g+0.11*b);
  if Gray>=balans then Gray:=255 else Gray:=0;
  TColorRec(RGBColor).R:=Gray;
  TColorRec(RGBColor).G:=Gray;
  TColorRec(RGBColor).B:=Gray;
  Result:=RGBColor;
end;

//ѕреобразование цветного изображени€ в черно-белое
procedure BlackWhite(var picture:timage);
var i,j: integer;
    c: TColor;
    Data: TBitmapData;
    Bitmap: TBitmap;
begin
  bitmap:=picture.Bitmap;
  if Bitmap.Map(TMapAccess.ReadWrite, Data) then
  try
    for i :=0 to Round(Data.Width-1) do
    for j :=0 to Round(Data.Height-1) do
    begin
      c :=Data.GetPixel(i,j);
      c :=RGBToBlackWhite(c);
      Data.SetPixel(i,j,c);
    end;
  finally
    Bitmap.Unmap(Data);
  end;
end;

//«аполнение массива цветов(массив нужен дл€ заполнени€ stringgrid'а)
procedure Pixalization(picture: timage; col_count,row_count:integer);
var i,j: integer;
    Data: TBitmapData;
    Bitmap: TBitmap;
    isg,jsg: integer; //дл€ заполени€ матрицы stringgrid'а
    i1,j1:integer;//текущее расположение сектора
    blcount, whcount: integer;//количество чЄрных и белых пиеселей
    black,white:TColor;
    W,H:integer; //размеры одного сектора;
begin
  black:=10001;
  white:=10000;
  bitmap:=picture.Bitmap;
  if Bitmap.Map(TMapAccess.ReadWrite, Data) then
  try
    W:=Data.Width div col_count;
    H:=Data.Height div row_count;
    if H>W then W:=H else H:=W;
    SetLength(ImMas,row_count,col_count);
    isg:=0;
    jsg:=0;
    i1:=0;
    j1:=0;
    while (isg<col_count) do
    begin
      blcount:=0;
      whcount:=0;
      for i :=i1 to W+i1 do
      begin
      if (i>Round(Data.Width-1)) then break;
      for j :=j1 to H+j1 do
      begin
        if (j>Round(Data.Height-1)) then continue;
        if Data.GetPixel(i,j)=TAlphaColorRec.Black then inc(blcount)
        else inc(whcount);
      end;
      end;
      if blcount>whcount then ImMas[jsg,isg]:=black else ImMas[jsg,isg]:=white;
      j1:=j1+H;
      inc(jsg);
      if jsg>=row_count then
      begin
        j1:=0;
        jsg:=0;
        i1:=i1+W;
        inc(isg);
      end;
    end;
  finally
    Bitmap.Unmap(Data);
    UdaleniePustihStolbcov_strok;
  end;
end;
end.
