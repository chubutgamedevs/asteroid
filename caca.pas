
Program caca;

Uses ptccrt,ptcGraph,ptcmouse,sysutils;

Const 
  size = 4;

Type 
  PointType = Record
    x, y: Integer;
  End;
  vect = Record
    x, y: Real;
  End;

  //arrPointType = array [1..size] Of PointType;


Var 
  Driver, Modo,i: Integer;             { Pues el driver y el modo, claro }
  option: Char;
  Triangle : array[1..size] Of PointType;
  Triangle1: array[1..size] Of PointType;
  acc: vect;
  velc: vect;
  salir: Boolean;
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
Function LimitarVel(velc:vect): vect;
Begin
  If velc.x > 20  Then
    velc.x := 20;
  If velc.x < -20  Then
    velc.x := -20;

  LimitarVel := velc;
End;
Function InputControl(): vect;

Var 
  tecla: Char;
  acc: vect;
Begin
  acc.x := 0;
  acc.y := 0;
  If keyPressed Then
    Begin
      tecla := readkey;
      Case tecla Of 
        'd': acc.x := 2;
        'a': acc.x := - 2;
        's': acc.y := 2;
        'w': acc.y := - 2;
        'f': salir := True;
      End;
    End;
  InputControl := acc;
End;
Begin

  Driver := Vga;                                   { Para pantalla VGA }
  Modo := VgaHi;                            { Modo 640x480, 16 colores }
  InitGraph(Driver, Modo, '');                { Inicializamos }
  //drawpoly(size,Triangle);{ 4 }
  //setcolor(15);
  //drawpoly(size,Triangle1);
  load;
  salir := False;
  velc.X := 0;
  Repeat
    acc := InputControl;
    velc.X := velc.X + acc.X;
    velc.y := velc.y + acc.y;
    velc := LimitarVel(velc);

    setcolor(0);
    drawpoly(size,Triangle);


    For i:=1 To size Do
      Begin
        Triangle[i].X := Triangle[i].X + Round(velc.X);
        Triangle[i].y := Triangle[i].y + Round(velc.y);
      End;
    velc.y := velc.y * 0.96;
    velc.x := velc.X * 0.96;
{dibujar}

    setcolor(15);
    drawpoly(size,Triangle);

    delay(50);

  Until salir;
  WriteLn(Triangle[1].X);
  //Readln;
  CloseGraph;
End.
