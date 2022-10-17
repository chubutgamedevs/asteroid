
Program caca;

Uses ptccrt,ptcGraph,ptcmouse,sysutils;

Const 
  size = 4;

Type 
  PointType = Record
    x, y: Integer;
  End;
  //arrPointType = array [1..size] Of PointType;

Var 
  Driver, Modo,i: Integer;             { Pues el driver y el modo, claro }
  option: Char;
  Triangle : array[1..size] Of PointType;
Procedure load();
Begin
  Triangle[1].x := 50;
  Triangle[1].Y := 100;
  Triangle[2].X := 100;
  Triangle[2].Y := 100;
  Triangle[3].X := 75;
  Triangle[3].Y := 150;
  Triangle[4].X := 50;
  Triangle[4].Y := 100;

End;
Begin
  load;
  Driver := Vga;                                   { Para pantalla VGA }
  Modo := VgaHi;                            { Modo 640x480, 16 colores }
  InitGraph(Driver, Modo, '');                { Inicializamos }
  //drawpoly(size,Triangle);{ 4 }
  //setcolor(15);
  //drawpoly(size,Triangle1);
  Repeat
    option := readkey;
    Case option Of 
      'd':
           Begin
             //Triangle[i].Y := Triangle[i].Y + 1;
             Begin
               For i:=1 To size Do
                 Begin
                   setcolor(0);
                   drawpoly(size,Triangle);
                   Triangle[i].X := Triangle[i].X + 3;
                   drawpoly(size,Triangle);
                 End;
               setcolor(15);
               Triangle[i].X := Triangle[i].X;
               drawpoly(size,Triangle);
             End;
           End;
    End;
  Until (option= 'f');
  WriteLn(Triangle[1].X);
  Readln;
  CloseGraph;
End.
