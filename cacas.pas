
Program cacas;

Uses ptcGraph;

Var 
  Driver, Modo,i: Integer;             { Pues el driver y el modo, claro }

Begin
  Driver := detect;                                   { Para pantalla VGA }
  Modo := VgaHi;
  //Modo := detect;                            { Modo 640x480, 16 colores }
  InitGraph(Driver, Modo, '');                { Inicializamos }
  //DrawPoly(SizeOf(Triangle) div SizeOf(PointType), Triangle);{ 4 }
  // DrawPoly(SizeOf(Triangle1) div SizeOf(PointType), Triangle1);
  Readln;
  CloseGraph;
End.
