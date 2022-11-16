Unit logic;

Interface

Uses sdl2, sdl2_image, vectores;

Type 
  figVect = Record
    pos, vel : vect;
    rot, r : Real;
    lado : Integer;
    puntos : array Of TSDL_Point
  End;

Function boundary(fig : figVect; winW, winH : Integer) : figVect;
Function moverNave(fig : figVect; vel : vect) : figVect;
Function kInput(acc: vect; fig : figVect) : vect;
Function rotacion(velMax : Integer; fig : figVect) : figVect;
Function dibujarNave(render : PSDL_Renderer; fig : figVect; w, h : Integer) : figVect;
Function evento(ev : PSDL_Event) : Boolean;
Function centerPos(winH, winW, w, h : Integer) : figVect;
function generarAsteroide(r : Real; pos : vect; lado : Integer) : figVect;
procedure dibujarAsteroide(render : PSDL_Renderer; a : figVect);

Implementation

Function boundary(fig : figVect; winW, winH : Integer) : figVect;
Begin
  If fig.pos.x > winW + 50 Then
    fig.pos.x := -50
  Else If fig.pos.x < -50 Then
    fig.pos.x := winW
  Else If fig.pos.y > winH + 50 Then
    fig.pos.y := -50
  Else If fig.pos.y < -50 Then
    fig.pos.y := winH;

  boundary := fig
End;

Function moverNave(fig : figVect; vel : vect) : figVect;
Begin
  fig.pos.x := fig.pos.x + vel.x;
  fig.pos.y := fig.pos.y + vel.y;
  moverNave := fig
End;

Function kInput(acc: vect; fig : figVect) : vect;
Var 
  input : PUInt8;
Begin
  input := SDL_GetKeyboardState(Nil);
  acc := vectZero();

  If (input[SDL_SCANCODE_W] = 1) Or (input[SDL_SCANCODE_UP] = 1) Then
    Begin
      acc.x := acc.x + Round(cos(fig.rot * pi / 180) * 1);
      acc.y := acc.y + Round(sin(fig.rot * pi / 180) * 1)
    End;
  kInput := acc
End;

Function rotacion(velMax : Integer; fig : figVect) : figVect;
Var 
  input : PUInt8;
Begin
  input := SDL_GetKeyboardState(Nil);
  If (input[SDL_SCANCODE_A] = 1) Or (input[SDL_SCANCODE_LEFT] = 1) Then
    fig.rot := fig.rot - velMax;
  If (input[SDL_SCANCODE_D] = 1) Or (input[SDL_SCANCODE_RIGHT] = 1) Then
    fig.rot := fig.rot + velMax;
  rotacion := fig
End;

Function dibujarNave(render : PSDL_Renderer; fig : figVect; w, h : Integer) : figVect;
Var 
  tex : PSDL_Texture;
  rect : TSDL_Rect;
  input : PUInt8;
Begin
  input := SDL_GetKeyboardState(Nil);
  rect.x := Round(fig.pos.x) - (w Div 2);
  rect.y := Round(fig.pos.y) - (h Div 2);
  rect.w := w;
  rect.h := h;

  If (input[SDL_SCANCODE_W] = 1) Or (input[SDL_SCANCODE_UP] = 1) Then
    tex := IMG_LoadTexture(render, './media/img/nave1.png')
  Else
    tex := IMG_LoadTexture(render, './media/img/nave0.png');

  SDL_RenderCopyEx(render, tex, Nil, @rect, fig.rot + 90, Nil, 1);
  dibujarNave := fig
End;

Function evento(ev : PSDL_Event) : Boolean;
Var 
  input : PUInt8;
Begin
  input := SDL_GetKeyboardState(Nil);
  If (input[SDL_SCANCODE_ESCAPE] = 1) Or (ev^.window.event = SDL_WINDOWEVENT_CLOSE) Then
    evento := False
  Else
    evento := True;
End;

Function centerPos(winH, winW, w, h : Integer) : figVect;
Begin
  centerPos.pos.x := (winW Div 2) - (w Div 2);
  centerPos.pos.y := (winH Div 2) - (h Div 2);
End;

procedure dibujarAsteroide(render : PSDL_Renderer; a : figVect);
var
  i : Integer;
begin
  SDL_SetRenderDrawColor(render, 255, 255, 255, 255);
  for i := 0 to (a.lado - 1) do
    SDL_RenderDrawLine(render, a.puntos[i].x + Round(a.pos.x), a.puntos[i].y + Round(a.pos.y), a.puntos[(i + 1) mod a.lado].x + Round(a.pos.x), a.puntos[(i + 1) mod a.lado].y + Round(a.pos.y));
end;

function generarAsteroide(r : Real; pos : vect; lado : Integer) : figVect;
var
  resultado : figVect;
  i : Integer;
begin
  resultado.r := r;
  resultado.pos := pos;
  resultado.lado := lado;

  SetLength(resultado.puntos, lado);
  for i := 0 to (lado - 1) do
    begin
      resultado.puntos[i].x := Round(r * cos(i * 2 * Pi / lado) + random(Round(r) div 2));
      resultado.puntos[i].y := Round(r * sin(i * 2 * Pi / lado) + random(Round(r) div 2));
    end;
  resultado.vel := newVect(random(5) - 2, random(5) - 2);
  generarAsteroide := resultado;
end;

End.
