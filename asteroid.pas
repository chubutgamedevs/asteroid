Program asteroid;
{$UNITPATH ./lib/units}

Uses SDL2, SDL2_image, vectores, logic;

Const 
  width = 34;
  height = 50;
  velocidadMax = 4;

Var 
  Nave : tNave;
  acc, velc, position: vect;
  ventana : PSDL_Window;
  render : PSDL_Renderer;
  events : PSDL_Event;
  icon : PSDL_Surface;
  asteroi : tAsteroide;
  ventanaW : Integer = 1920;
  ventanaH : Integer = 1080;

Procedure crearVentaraYRender;
Begin
  ventana := SDL_CreateWindow('Pascalroid', 50, 50, ventanaW, ventanaH, SDL_WINDOW_RESIZABLE);
  render := SDL_CreateRenderer(ventana, -1, 0);
  icon := IMG_Load('./media/img/pascalroid.ico');
  SDL_SetWindowIcon(ventana, icon);
End;

Procedure salirJuego;
Begin
  Dispose(events);
  SDL_DestroyRenderer(render);
  SDL_DestroyWindow(ventana);
  SDL_Quit;
End;

Procedure initPos;
Begin
  Nave := centerPos(ventanaH, ventanaW, width, height);
  acc := vectZero();
  velc := vectZero();
End;

//MAIN
Begin
  randomize;
  If SDL_Init(SDL_INIT_VIDEO) < 0 Then Halt;
  crearVentaraYRender;
  New(events);
  initPos;
  position := newVect(100, 100);
  asteroi := generarAsteroide(100, position, 5);

  While evento(events) Do
    Begin
      SDL_PollEvent(events);
      SDL_ShowCursor(SDL_DISABLE);

      Nave := rotacion(velocidadMax, Nave);
      velc := sumar(velc, acc);
      acc := kInput(acc, Nave);
      velc := limit(velc, velocidadMax);

      Nave := moverNave(Nave, velc);
      velc := multEscalar(velc, 1);

      Nave := boundary(Nave, ventanaW, ventanaH);

      // borrar pantalla
      SDL_SetRenderDrawColor(render, 0, 0, 0, SDL_ALPHA_OPAQUE);
      SDL_RenderClear(render);

      dibujarAsteroide(render, asteroi);
      asteroi.pos := sumar(asteroi.pos, newVect(2, 2));

      dibujarNave(render, Nave, width, height);
      SDL_RenderPresent(render);
      SDL_Delay(20);
    End;
  salirJuego;
End.
