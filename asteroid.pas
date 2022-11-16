Program asteroid;
{$UNITPATH ./lib/units}

Uses SDL2, SDL2_image, vectores, logic;

Const 
  width = 34;
  height = 50;
  velocidadMax = 4;

Var 
  Nave : figVect;
  acc, velc : vect;
  render : PSDL_Renderer;
  events : PSDL_Event;
  asteroi : array [0..20] of figVect;
  ventanaW : Integer = 1920;
  ventanaH : Integer = 1080;
  i : Integer;

Procedure crearVentaraYRender;
var
  ventana : PSDL_Window;
  icon : PSDL_Surface;
Begin
  ventana := SDL_CreateWindow('Pascalroid', 50, 50, ventanaW, ventanaH, SDL_WINDOW_RESIZABLE);
  render := SDL_CreateRenderer(ventana, -1, 0);
  icon := IMG_Load('./media/img/pascalroid.ico');
  SDL_SetWindowIcon(ventana, icon);
End;

Procedure salirJuego;
var
  ventana : PSDL_Window;
Begin
  Dispose(events);
  SDL_DestroyRenderer(render);
  SDL_DestroyWindow(ventana);
  SDL_Quit;
End;

Procedure initPos;
var
  position : vect;
Begin
  Nave := centerPos(ventanaH, ventanaW, width, height);
  acc := vectZero();
  velc := vectZero();
  For i := Low(asteroi) To High(asteroi) Do
    Begin
      position := newVect(random(ventanaW + 100), random(ventanaH + 100));
      asteroi[i] := generarAsteroide(random(100), position, random(13) + 5);
    End
End;

//MAIN
Begin
  randomize;
  If SDL_Init(SDL_INIT_VIDEO) < 0 Then Halt;
  crearVentaraYRender;
  New(events);
  initPos;

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

      for i := Low(asteroi) to High(asteroi) do
        begin
          asteroi[i].pos := sumar(asteroi[i].pos, asteroi[i].vel);
          asteroi[i] := boundary(asteroi[i], ventanaW, ventanaH);
          dibujarAsteroide(render, asteroi[i]);
        end;

      dibujarNave(render, Nave, width, height);
      SDL_RenderPresent(render);
      SDL_Delay(20);
    End;
  salirJuego;
End.
