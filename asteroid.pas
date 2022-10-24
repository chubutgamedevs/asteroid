Program asteroid;
{$UNITPATH ./lib/units}

Uses SDL2, SDL2_image, sdl2_mixer, vectores, logic;

Const 
  size = 4;

Var 
  Nave : tNave;
  acc : vect;
  velc : vect;
  gradosRotacion : Real = 0;
  running : Boolean = True;
  ventana : PSDL_Window;
  render : PSDL_Renderer;
  events : PSDL_Event;
  teclado : PUInt8;
  ventanaW : Integer = 800;
  ventanaH : Integer = 600;
  rectangulo : TSDL_Rect;
  naveTexura : PSDL_Texture;
  velocidadMax : Integer = 5;

Procedure crearVentaraYRender;
Begin
  ventana := SDL_CreateWindow('Cacaroid', 50, 50, ventanaW, ventanaH, SDL_WINDOW_SHOWN);
  If ventana = Nil Then Halt;
  render := SDL_CreateRenderer(ventana, -1, 0);
  If render = Nil Then Halt;
  teclado := SDL_GetKeyboardState(Nil);
End;

Procedure salirJuego;
Begin
  SDL_DestroyRenderer(render);
  SDL_DestroyWindow(ventana);
  SDL_Quit;
End;

Procedure dibujarNave;
Begin
  naveTexura := IMG_LoadTexture(render, './media/img/nave0.png');
  If naveTexura = Nil Then HALT;

  rectangulo.x := Round(Nave.pos.x);
  rectangulo.y := Round(Nave.pos.y);
  rectangulo.w := 34;
  rectangulo.h := 50;

  SDL_RenderCopyEx(render, naveTexura, Nil, @rectangulo, gradosRotacion + 90, Nil, 1);
End;

//MAIN
Begin
  If SDL_Init(SDL_INIT_VIDEO) < 0 Then Halt;
  crearVentaraYRender;

  velc.X := 0;
  Nave.pos.x := 0;
  Nave.pos.y := 0;
  Nave.rot := 0;

  While running Do
    Begin
      SDL_PollEvent(events);
      acc :=  input(acc, teclado, velocidadMax, gradosRotacion);
      gradosRotacion := rotacion(gradosRotacion, teclado, velocidadMax);
      velc := sumar(velc, acc);
      velc := limitarVel(velc, velocidadMax);

      // borrar pantalla
      SDL_SetRenderDrawColor(render, 0, 0, 0, SDL_ALPHA_OPAQUE);
      SDL_RenderClear(render);

      Nave := moverNave(Nave,velc);
      velc := multEscalar(velc, 0.95);

      If (teclado[SDL_SCANCODE_ESCAPE] = 1) Then
        running := False;

      dibujarNave;
      SDL_RenderPresent(render);
      SDL_Delay(20);
    End;
  salirJuego;
End.
