Program testText;
{$UNITPATH ../lib/units}

Uses SDL2, SDL2_image, sdl2_ttf, vectores, logic, init;

Const 
  width = 34;
  height = 50;
  velocidadMax = 4;

Function raycast(fig1, fig2 : figVect) : Real;
Var 
  e, d: vect;
  a, bSq, rSq, f: Real;
Begin
  e := restar(fig1.pos, fig2.pos);
  // El vector entre el raycast y el centro del circulo.
  d := newPolarVect(1, fig2.rot);
  // dirección del raycast (norma 1)
  a := dot(e, d);
  // Longitud de la proyección de e sobre d
  bSq := lengthSq(e) - (a * a);
  rSq := fig2.r * fig2.r;
  If (rSq - bSq) < 0 Then
    Begin
      // No le pega
      raycast := 2000;
      WriteLn('No pega');
      // "Infinito"
      exit;
    End;
  f := Sqrt(rSq - bSq);
  If a < f Then
    Begin
      raycast := 2000;
      exit
    End;
  If (lengthSq(e) < rSq) Then
    raycast := a + f // Está dentro del circulo, quizás debería ser 0
  Else
    Begin
      raycast := a - f;
      WriteLn('Pega');
    End;
  // Le pega.
End;

Procedure disparo(render : PSDL_Renderer; fig : figVect; dist : Real);
Var 
  vet, tip : vect;
Begin
  tip := newPolarVect(dist, fig.rot);
  tip := sumar(tip, fig.pos);
  vet.x := fig.pos.x + Round(cos(rad(fig.rot)) * 2000);
  vet.y := fig.pos.y + Round(sin(rad(fig.rot)) * 2000);

  SDL_SetRenderDrawColor(render, 255, 255, 255, 0);
  SDL_RenderDrawLine(render, Round(fig.pos.x), Round(fig.pos.y), Round(tip.x),
  Round(tip.y));
End;

Var 
  Nave : figVect;
  acc, velc : vect;
  render : PSDL_Renderer;
  events : PSDL_Event;
  asteroide : array [0..20] Of figVect;
  ventanaW : Integer = 1920;
  ventanaH : Integer = 1080;
  i : Integer;
  d : Real;

Begin
  randomize;
  render := crearVentaraYRender(ventanaH, ventanaW, render);
  Nave := initPosNave(Nave, ventanaH, ventanaW, width, height);
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
          kDisparo(render, Nave, asteroide[i]);
          If collider(Nave, asteroide[i]) Then
            exit;
          asteroide[i] := animAsteroid(asteroide[i], render, ventanaW, ventanaH)
        End;
      Nave := dibujarNave(render, Nave, width, height);
      SDL_RenderPresent(render);
      SDL_Delay(20)
    End;
  salirJuego(events, render)
End.
