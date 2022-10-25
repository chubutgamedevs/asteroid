Program asteroid;
{$UNITPATH ./lib/units}

Uses SDL2, SDL2_image, sdl2_mixer, vectores, logic;

Const 
  width = 34;
  height = 50;

Var 
  Nave : tNave;
  acc : vect;
  velc : vect;
  gradosRotacion : Real = 0;
  ventana : PSDL_Window;
  render : PSDL_Renderer;
  events : PSDL_Event;
  ventanaW : Integer = 800;
  ventanaH : Integer = 600;
  velocidadMax : Integer = 6;

Procedure crearVentaraYRender;
Begin
  ventana := SDL_CreateWindow('Pascalroid', 50, 50, ventanaW, ventanaH, SDL_WINDOW_SHOWN);
  If ventana = Nil Then Halt;
  render := SDL_CreateRenderer(ventana, -1, 0);
  If render = Nil Then Halt;
End;

Procedure salirJuego;
Begin
  Dispose(events);
  SDL_DestroyRenderer(render);
  SDL_DestroyWindow(ventana);
  SDL_Quit;
End;

procedure initPos;
begin
  Nave.pos.x := (ventanaW Div 2) - (width Div 2);
  Nave.pos.y := (ventanaH Div 2) - (height Div 2);
  //Nave := centerPos(Nave, ventanaH, ventanaW, width, height);
  acc := vectZero(acc);
  velc := vectZero(velc);
end;

//MAIN
Begin
  If SDL_Init(SDL_INIT_VIDEO) < 0 Then Halt;
  crearVentaraYRender;
  New(events);
  initPos;

  While evento(events) Do
    Begin
      SDL_PollEvent(events);

      gradosRotacion := rotacion(gradosRotacion, velocidadMax);
      velc := sumar(velc, acc);
      acc := kInput(acc, gradosRotacion);
      velc := limit(velc, velocidadMax);

      Nave := moverNave(Nave, velc);
      velc := multEscalar(velc, 0.99);

      Nave := boundary(Nave, ventanaW, ventanaH);

      // borrar pantalla
      SDL_SetRenderDrawColor(render, 0, 0, 0, SDL_ALPHA_OPAQUE);
      SDL_RenderClear(render);

      dibujarNave(render, Nave, width, height, gradosRotacion);
      SDL_RenderPresent(render);
      SDL_Delay(20);
    End;
  salirJuego;
End.
