
Program cacas;

Uses ptcGraph;

Const 
  

Type 
PointType = ((X: 50; Y: 100), (X: 100; Y:100),
            (X: 75; Y: 150), (X:  50; Y: 100));

  //Triangle: array[1..4] Of 

Var 
  Driver, Modo,i: Integer;             { Pues el driver y el modo, claro }

Begin
  Driver := Vga;                                   { Para pantalla VGA }
  Modo := VgaHi;                            { Modo 640x480, 16 colores }
  InitGraph(Driver, Modo, '');                { Inicializamos }
  DrawPoly(SizeOf(Triangle) div SizeOf(PointType), Triangle);{ 4 }
  // DrawPoly(SizeOf(Triangle1) div SizeOf(PointType), Triangle1);



  Readln;
  CloseGraph;
End.
