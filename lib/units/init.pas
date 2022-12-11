Unit init;

Interface

Uses sdl2, sdl2_image, sdl2_ttf, logic, vectores;

Function crearVentaraYRender(ventanaH, ventanaW : Integer; render : PSDL_Renderer) : PSDL_Renderer;
Function animAsteroid(asteroide : figVect; render : PSDL_Renderer; ventanaW, ventanaH : Integer) : figVect;
Function initPosNave(Nave : figVect; ventanaH, ventanaW, width, height : Integer) : figVect;
Function initPosAsteroide(asteroide : figVect; ventanaW : Integer) : figVect;
Procedure initFont(render : PSDL_Renderer);
Procedure salirJuego(events : PSDL_Event; render : PSDL_Renderer);

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

procedure initFont(render : PSDL_Renderer);
Var 
  font : PTTF_Font;
  texto : PSDL_Surface;
  texture : PSDL_Texture;
  color : TSDL_Color;
Begin
  font := TTF_OpenFont('../../media/font/NovaSquare-Regular.ttf', 12);
  TTF_SetFontStyle(font, TTF_STYLE_UNDERLINE Or TTF_STYLE_ITALIC);
  TTF_SetFontOutline(font, 1);
  TTF_SetFontHinting(font, TTF_HINTING_NORMAL);
  color := setColor(255, 255, 255, 255);
  texto := TTF_RenderText_Solid(font, 'GAME OVER', color);
  texture := SDL_CreateTextureFromSurface(render, texto);
  SDL_RenderCopy(render, texture, Nil, Nil);
End;

Procedure salirJuego(events : PSDL_Event; render : PSDL_Renderer);
Var 
  ventana : PSDL_Window;
Begin
  Dispose(events);
  SDL_DestroyRenderer(render);
  SDL_DestroyWindow(ventana);
  TTF_Quit;
  SDL_Quit
End;

End.