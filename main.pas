Program main;
{$UNITPATH ./lib/units}

Uses SDL2, SDL2_image, vectores, logic, init;

Const 
  width = 34;
  height = 50;
  velocidadMax = 4;

Var 
  Nave : figVect;
  acc, velc : vect;
  render : PSDL_Renderer;
  events : PSDL_Event;
  asteroide : array [0..20] Of figVect;
  ventanaW : Integer = 1920;
  ventanaH : Integer = 1080;
  i : Integer;

Procedure crearVentaraYRender;
Var 
  ventana : PSDL_Window;
  icon : PSDL_Surface;
Begin
  ventana := SDL_CreateWindow('Pascalroid', 50, 50, ventanaW, ventanaH, SDL_WINDOW_RESIZABLE);
  render := SDL_CreateRenderer(ventana, -1, 0);
  icon := IMG_Load('./media/img/pascalroid.ico');
  SDL_SetWindowIcon(ventana, icon);
End;

Procedure initPos;
Var 
  position : vect;
Begin
  Nave := centerPos(ventanaH, ventanaW, width, height);
  Nave.r := 14;
  acc := vectZero();
  velc := vectZero();
  For i := Low(asteroide) To High(asteroide) Do
    Begin
      position := newPolarVect(250 + random(ventanaW), random(2* Round(Pi)));
      position := sumar(position, newVect(ventanaW/2, ventanaH /2));
      asteroide[i] := generarAsteroide(random(70) + 18, position, random(13) + 5);
    End
End;

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

      SDL_SetRenderDrawColor(render, 0, 0, 0, SDL_ALPHA_OPAQUE);
      SDL_RenderClear(render);

      For i := Low(asteroide) To High(asteroide) Do
        Begin
          if collider(Nave, asteroide[i]) then
            exit;
          asteroide[i].pos := sumar(asteroide[i].pos, asteroide[i].vel);
          asteroide[i].rot := asteroide[i].rot + 1;
          asteroide[i] := boundary(asteroide[i], ventanaW, ventanaH);
          dibujarAsteroide(render, asteroide[i]);
        End;

      dibujarNave(render, Nave, width, height);
      SDL_RenderPresent(render);
      SDL_Delay(20);
    End;
  salirJuego(events, render);
End.
