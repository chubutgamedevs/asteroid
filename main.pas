Program main;
{$UNITPATH ./lib/units}

Uses SDL2, SDL2_image, sdl2_ttf, vectores, logic, init;

Const 
  width = 34;
  height = 50;
  velocidadMax = 4;

Var 
  Nave : figVect;
  acc, velc : vect;
  render : PSDL_Renderer;
  events : PSDL_Event;
  font : PTTF_Font;
  asteroide : array [0..20] Of figVect;
  ventanaW : Integer = 1920;
  ventanaH : Integer = 1080;
  i : Integer;

Begin
  randomize;
  render := crearVentaraYRender(ventanaH, ventanaW, render);
  Nave := initPosNave(Nave, ventanaH, ventanaW, width, height);
  font := initFont(font, render);
  acc := vectZero();
  velc := vectZero();
  For i := low(asteroide) To High(asteroide) Do
    asteroide[i] := initPosAsteroide(asteroide[i], ventanaW);
  New(events);

  While evento(events) Do
    Begin
      SDL_PollEvent(events);
      SDL_ShowCursor(SDL_DISABLE);
      Nave := rotacion(velocidadMax, Nave);
      velc := sumar(velc, acc);
      acc := kInput(render, acc, Nave);
      velc := limit(velc, velocidadMax);
      Nave := moverNave(Nave, velc);
      velc := multEscalar(velc, 1);
      Nave := boundary(Nave, ventanaW, ventanaH);
      SDL_SetRenderDrawColor(render, 0, 0, 0, SDL_ALPHA_OPAQUE);
      SDL_RenderClear(render);
      For i := Low(asteroide) To High(asteroide) Do
        Begin
          If collider(Nave, asteroide[i]) Then
            exit;
          asteroide[i] := animAsteroid(asteroide[i], render, ventanaW, ventanaH)
        End;
      dibujarNave(render, Nave, width, height);
      SDL_RenderPresent(render);
      SDL_Delay(20)
    End;
  salirJuego(events, render, font)
End.
