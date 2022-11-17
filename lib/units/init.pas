Unit init;

Interface

Uses sdl2, sdl2_image, logic, vectores;

Procedure crearVentaraYRender(ventanaH, ventanaW : Integer; render : PSDL_Renderer);
Procedure initPos(ventanaH, ventanaW, width, height : Integer; acc, velc : vect; Nave : figVect);
Procedure salirJuego(events : PSDL_Event; render : PSDL_Renderer);

Implementation

procedure crearVentaraYRender(ventanaH, ventanaW : Integer; render : PSDL_Renderer);
Var 
  ventana : PSDL_Window;
  icon : PSDL_Surface;
Begin
  ventana := SDL_CreateWindow('Pascalroid', 50, 50, ventanaW, ventanaH, SDL_WINDOW_RESIZABLE);
  render := SDL_CreateRenderer(ventana, -1, 0);
  icon := IMG_Load('./media/img/pascalroid.ico');
  SDL_SetWindowIcon(ventana, icon);
End;


procedure initPos(ventanaH, ventanaW, width, height : Integer; acc, velc : vect; Nave : figVect);
Var 
  asteroide : array [0..20] Of figVect;
  position : vect;
  i : Integer;
Begin
  Nave := centerPos(ventanaH, ventanaW, width, height);
  acc := vectZero();
  velc := vectZero();
  For i := Low(asteroide) To High(asteroide) Do
    Begin
      position := newVect(random(ventanaW + 100), random(ventanaH + 100));
      asteroide[i] := generarAsteroide(random(100), position, random(13) + 5);
    End
End;

Procedure salirJuego(events : PSDL_Event; render : PSDL_Renderer);
Var 
  ventana : PSDL_Window;
Begin
  Dispose(events);
  SDL_DestroyRenderer(render);
  SDL_DestroyWindow(ventana);
  SDL_Quit;
End;

End.