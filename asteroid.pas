Program asteroid;
{$UNITPATH ./lib/units}

Uses SDL2, SDL2_image, sdl2_mixer, vectores, logic;

Const 
  width = 34;
  height = 50;
  velocidadMax = 6;

Var 
  Nave : tNave;
  acc, velc : vect;
  ventana : PSDL_Window;
  render : PSDL_Renderer;
  events : PSDL_Event;
  icon : PSDL_Surface;
  ventanaW : Integer = 800;
  ventanaH : Integer = 600;

Procedure crearVentaraYRender;
Begin
  ventana := SDL_CreateWindow('Pascalroid', 50, 50, ventanaW, ventanaH, SDL_WINDOW_RESIZABLE);
  If ventana = Nil Then Halt;
  render := SDL_CreateRenderer(ventana, -1, 0);
  If render = Nil Then Halt;
  icon := IMG_Load('./media/img/pascalroid.ico');
  If icon = Nil Then Halt;
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
  Nave.pos.x := (ventanaW Div 2) - (width Div 2);
  Nave.pos.y := (ventanaH Div 2) - (height Div 2);
  //Nave := centerPos(ventanaH, ventanaW, width, height);
  acc := vectZero();
  velc := vectZero();
End;

//MAIN
Begin
  If SDL_Init(SDL_INIT_VIDEO) < 0 Then Halt;
  crearVentaraYRender;
  New(events);
  initPos;

  While evento(events) Do
    Begin
      SDL_PollEvent(events);

      Nave := rotacion(velocidadMax, Nave);
      velc := sumar(velc, acc);
      acc := kInput(acc, Nave);
      velc := limit(velc, velocidadMax);

      Nave := moverNave(Nave, velc);
      velc := multEscalar(velc, 0.99);

      Nave := boundary(Nave, ventanaW, ventanaH);

      // borrar pantalla
      SDL_SetRenderDrawColor(render, 0, 0, 0, SDL_ALPHA_OPAQUE);
      SDL_RenderClear(render);

      dibujarNave(render, Nave, width, height);
      SDL_RenderPresent(render);
      SDL_Delay(20);
    End;
  salirJuego;
End.
