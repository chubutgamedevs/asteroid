Unit logic;

Interface

Uses sdl2, sdl2_image, vectores;

Type 
  tNave = Record
    pos: vect;
    rot: Real;
  End;

Function boundary(fig : tNave; winW, winH : Integer) : tNave;
Function moverNave(fig : tNave; vel : vect) : tNave;
Function kInput(acc: vect; fig : tNave) : vect;
Function rotacion(velMax : Integer; fig : tNave) : tNave;
Function dibujarNave(render : PSDL_Renderer; fig : tNave; w, h : Integer) : tNave;
Function evento(ev : PSDL_Event) : Boolean;
Function centerPos(winH, winW, w, h : Integer) : tNave;

Implementation

Function boundary(fig : tNave; winW, winH : Integer) : tNave;
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

Function moverNave(fig : tNave; vel : vect) : tNave;
Begin
  fig.pos.x := fig.pos.x + vel.x;
  fig.pos.y := fig.pos.y + vel.y;
  moverNave := fig
End;

Function kInput(acc: vect; fig : tNave) : vect;
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

Function rotacion(velMax : Integer; fig : tNave) : tNave;
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

Function dibujarNave(render : PSDL_Renderer; fig : tNave; w, h : Integer) : tNave;
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
End;

function centerPos(winH, winW, w, h : Integer) : tNave;
Begin
  centerPos.pos.x := (winW Div 2) - (w Div 2);
  centerPos.pos.y := (winH Div 2) - (h Div 2);
End;

End.
