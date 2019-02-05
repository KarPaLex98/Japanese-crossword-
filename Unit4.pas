unit Unit4;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Grid, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.TextLayout, FMX.MultiView, FMX.Menus,
  FMX.Layouts, FMX.ListBox, FMX.Edit, FMX.EditBox, FMX.NumberBox, FMX.Ani ;

Procedure Udalstr(k : integer);
Procedure Udalst(k : integer);
procedure ZapolnenieCifri;
procedure UdaleniePustihStolbcov_strok;

implementation

uses Unit1;

Procedure Udalstr(k : integer);
var
  i,j:integer;
Begin
  for i := k to row_count-2 do
    for j := 0 to col_count-1 do
      ImMas[i, j] := ImMas[i+1, j];
  dec(row_count);
end;

Procedure Udalst(k : integer);
var
  i,j:integer;
Begin
  for j := k to col_count-2 do
    for i := 0 to row_count-1 do
      ImMas[i, j] := ImMas[i, j+1];
  dec(col_count);
end;

procedure ZapolnenieCifri;
var
  i, j, group, group_old, isg, jsg : integer;
begin
  max_verh:=0;
  max_bok:=0;
  group:=0;
  group_old:=0;
  jsg:=-1;
  for j := 0 to col_count-1 do
  begin
    isg:=0;
    inc(jsg);
    for i := 0 to row_count-1 do
    begin
      group_old:=group;
      if ImMas[i,j]=10001 then
        inc(group);
        if ((group_old=group) or (i=row_count-1)) and (group<>0) then
        begin
          verh[isg,jsg]:=group;
          group:=0;
          group_old:=0;
          inc(isg);
          if isg>max_verh then max_verh:=isg;
        end;
    end;
  end;
  group:=0;
  group_old:=0;
  isg:=-1;
  for i := 0 to row_count-1 do
  begin
    jsg:=0;
    inc(isg);
    for j := 0 to col_count-1 do
    begin
      group_old:=group;
      if ImMas[i,j]=10001 then
        inc(group);
      if ((group_old=group) or (j=col_count-1)) and (group<>0) then
      begin
        bok[isg,jsg]:=group;
        group:=0;
        group_old:=0;
        inc(jsg);
        if jsg>max_bok then max_bok:=jsg;
      end;
    end;
  end;
end;

procedure UdaleniePustihStolbcov_strok;
var
  i, j: integer;
  k: array [0..101] of byte;
  i_k: integer;
  flag: boolean;
begin
  i_k:= 0;
  for i := 0 to row_count-1 do
  begin
    flag:=true;
    j := 0;
    while (j<col_count) and (flag=true) do
      if ImMas[i,j]=10001 then flag:=false
      else inc(j);
    if (flag=true) then
    begin
      k[i_k]:=i;
      inc(i_k);
    end;
  end;
  for i :=i_k-1 downto 0 do
  begin
    Udalstr(k[i]);
  end;
  i_k:=0;
  for j := 0 to col_count-1 do
  begin
    flag:=true;
    i := 0;
    while (i<row_count) and (flag=true) do
      if ImMas[i,j]=10001 then flag:=false
      else inc(i);
    if (flag=true) then
    begin
      k[i_k]:=j;
      inc(i_k);
    end;
  end;
  for i :=i_k-1 downto 0 do
  begin
    Udalst(k[i]);
  end;
end;

end.
