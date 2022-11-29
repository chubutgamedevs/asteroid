Unit init;

Interface

Uses sdl2, sdl2_image, sdl2_ttf, logic, vectores;

Function crearVentaraYRender(ventanaH, ventanaW : Integer; render : PSDL_Renderer) : PSDL_Renderer;
Function animAsteroid(asteroide : figVect; render : PSDL_Renderer; ventanaW, ventanaH : Integer) : figVect;
Function initPosNave(Nave : figVect; ventanaH, ventanaW, width, height : Integer) : figVect;
Function initPosAsteroide(asteroide : figVect; ventanaW : Integer) : figVect;
Function initFont(font : PTTF_Font; render : PSDL_Renderer) : PTTF_Font;
Procedure salirJuego(events : PSDL_Event; render : PSDL_Renderer; font : PTTF_Font);

Implementation

Function crearVentaraYRender(ventanaH, ventanaW : Integer; render : PSDL_Renderer) : PSDL_Renderer;
Var 
  ventana : PSDL_Window;
  icon : PSDL_Surface;
Begin
  ventana := SDL_CreateWindow('Pascalroid', 50, 50, ventanaW, ventanaH, SDL_WINDOW_RESIZABLE);
  render := SDL_CreateRenderer(ventana, -1, 0);
  icon := IMG_Load('./media/img/pascalroid.ico');
  SDL_SetWindowIcon(ventana, icon);
  crearVentaraYRender := render
End;

Function initPosNave(Nave : figVect; ventanaH, ventanaW, width, height : Integer) : figVect;
Begin
  Nave := centerPos(ventanaH, ventanaW, width, height);
  Nave.r := 14;
  initPosNave := Nave
End;

Function initPosAsteroide(asteroide : figVect; ventanaW : Integer) : figVect;
Var 
  position : vect;
Begin
  position := newPolarVect(230 + random(ventanaW), random(360));
  asteroide := generarAsteroide(random(70) + 18, position, random(13) + 5);
  initPosAsteroide := asteroide
End;

Function animAsteroid(asteroide : figVect; render : PSDL_Renderer; ventanaW, ventanaH : Integer) : figVect;
Begin
  asteroide.pos := sumar(asteroide.pos, asteroide.vel);
  asteroide.rot := asteroide.rot + 1;
  asteroide := boundary(asteroide, ventanaW, ventanaH);
  dibujarAsteroide(render, asteroide);
  animAsteroid := asteroide
End;

Function initFont(font : PTTF_Font; render : PSDL_Renderer) : PTTF_Font;
Var 
  texto : PSDL_Surface;
  texture : PSDL_Texture;
  color : TSDL_Color;
Begin
  color := setColor(255, 255, 255, 255);
  font := TTF_OpenFont('../../media/NovaSquare-Regular.ttf', 12);
  {TTF_SetFontStyle(font, TTF_STYLE_NORMAL);
  TTF_SetFontOutline(font, 1);
  TTF_SetFontHinting(font, TTF_HINTING_NORMAL);}
  texto := TTF_RenderText_Solid(font, 'GAME OVER', color);
  texture := SDL_CreateTextureFromSurface(render, texto);
  initFont := font;
End;

Procedure salirJuego(events : PSDL_Event; render : PSDL_Renderer; font : PTTF_Font);
Var 
  ventana : PSDL_Window;
Begin
  Dispose(events);
  TTF_CloseFont(font);
  SDL_DestroyRenderer(render);
  SDL_DestroyWindow(ventana);
  TTF_Quit;
  SDL_Quit
End;

End.