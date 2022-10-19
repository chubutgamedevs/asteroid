
Program caca;

Uses sysutils,SDL2,SDL2_image;

Const 
  size = 4;

Type 
  PointType = Record
    x, y: Integer;
  End;
  vect = Record
    x, y: Real;
  End;

  tNave = Record
    pos: vect;
    rot: Real;
  End;


Var 
  Driver, Modo,i: Integer;             { Pues el driver y el modo, claro }
  option: Char;

  Nave: tNave;
  Triangle : array[1..size] Of PointType;
  Triangle1: array[1..size] Of PointType;
  acc: vect;
  velc: vect;
  salir: Boolean;

  ventana :   PSDL_Window;
  render :   PSDL_Renderer;

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
  teclado :   PUInt8;
Begin
  acc.x := 0;
  acc.y := 0;

  SDL_PumpEvents;
  teclado := SDL_GetKeyboardState(Nil);


  If (teclado[SDL_SCANCODE_W] = 1) Or (teclado[SDL_SCANCODE_UP] = 1) Then
    acc.y := -2;
  If (teclado[SDL_SCANCODE_A] = 1) Or (teclado[SDL_SCANCODE_LEFT] = 1) Then
    acc.x := -2;
  If (teclado[SDL_SCANCODE_S] = 1) Or (teclado[SDL_SCANCODE_DOWN] = 1) Then
    acc.y := 2;
  If (teclado[SDL_SCANCODE_D] = 1) Or (teclado[SDL_SCANCODE_RIGHT] = 1) Then
    acc.x := 2;
  If teclado[SDL_SCANCODE_ESCAPE] = 1 Then
    salir := True;

  InputControl := acc;
End;

Procedure crearVentaraYRender;
Begin
  ventana := SDL_CreateWindow('Cacaroid', 50, 50, 800, 600,
             SDL_WINDOW_SHOWN);
  If ventana = Nil Then Halt;
  render := SDL_CreateRenderer(ventana, -1, 0);
  If render = Nil Then Halt;
End;

Procedure salirJuego;
Begin
  // clear memory
  SDL_DestroyRenderer(render);
  SDL_DestroyWindow(ventana);

  //closing SDL2
  SDL_Quit;
End;
Function moverNave(Nave:tNave;velc:vect): tNave;
Begin
  Nave.pos.x := Nave.pos.x+ velc.x;
  Nave.pos.y := Nave.pos.y+ velc.y;
  moverNave := Nave;
End;
Procedure dibujarNave(Nave:tNave);

Var 
  rectangulo :   TSDL_Rect;
  sdlTexture1 : PSDL_Texture;

Begin
  sdlTexture1 := IMG_LoadTexture(render,             'ImgNAve\nave-espacial.png'
                 );
  If sdlTexture1 = Nil Then HALT;

  rectangulo.x := Round(Nave.pos.x);
  rectangulo.y := Round(Nave.pos.y);
  rectangulo.w := 50;
  rectangulo.h := 50;

  SDL_RenderCopy(render, sdlTexture1, Nil, @rectangulo);
End;

//MAIN
Begin
  If SDL_Init(SDL_INIT_VIDEO) < 0 Then Halt;
  crearVentaraYRender;
  load;
  salir := False;
  velc.X := 0;

  Nave.pos.x := 0;
  Nave.pos.y := 0;
  Nave.rot := 0;


  Repeat
    acc := InputControl;

    velc.X := velc.X + acc.X;
    velc.y := velc.y + acc.y;
    velc := LimitarVel(velc);

    // borrar pantalla
    SDL_SetRenderDrawColor(render, 255, 255, 255,
                           SDL_ALPHA_OPAQUE);
    SDL_RenderClear(render);


    Nave := moverNave(Nave,velc);

    velc.y := velc.y * 0.96;
    velc.x := velc.X * 0.96;
{dibujar}
    dibujarNave(Nave);

    SDL_RenderPresent(render);
    SDL_Delay(20);


  Until salir;
  //Readln;
  salirJuego;
End.
