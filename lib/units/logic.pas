Unit logic;

Interface

Uses sdl2, sdl2_image, vectores;

Type 
  tNave = Record
    pos: vect;
    rot: Real;
  End;

Function boundary(figura : tNave; w, h : Integer) : tNave;
Function moverNave(Nave : tNave; velocidadActual : vect) : tNave;
Function kInput(aceleracion: vect; velocidadMaxima : Integer; rotacion : Real) : vect;
function dibujarNave(render : PSDL_Renderer; figura : tNave; width, height : Integer; rotacion : Real) : tNave;
Function rotacion(rot : Real; velocidadMaxima : Integer) : Real;
function evento(ev : PSDL_Event) : Boolean;

Implementation

Function boundary(figura : tNave; w, h : Integer) : tNave;
Begin
  If figura.pos.x > w + 50 Then
    figura.pos.x := -50

  Else If figura.pos.x < -50 Then
    figura.pos.x := w

  Else If figura.pos.y > h + 50 Then
    figura.pos.y := -50

  Else If figura.pos.y < -50 Then
    figura.pos.y := h;

  boundary := figura;
End;

Function moverNave(Nave : tNave; velocidadActual : vect) : tNave;
Begin
  Nave.pos.x := Nave.pos.x + velocidadActual.x;
  Nave.pos.y := Nave.pos.y + velocidadActual.y;
  moverNave := Nave;
End;

Function kInput(aceleracion: vect; velocidadMaxima : Integer; rotacion : Real) : vect;
var
  teclado : PUInt8;
Begin
  teclado := SDL_GetKeyboardState(Nil);
  aceleracion.x := 0;
  aceleracion.y := 0;

  If (teclado[SDL_SCANCODE_W] = 1) Or (teclado[SDL_SCANCODE_UP] = 1) Then
    Begin
      aceleracion.x := aceleracion.x + Round(cos(rotacion * pi / 180) * 1);
      aceleracion.y := aceleracion.y + Round(sin(rotacion * pi / 180) * 1);
    End;
  kInput := aceleracion;
End;

Function rotacion(rot : Real; velocidadMaxima : Integer) : Real;
var
  teclado : PUInt8;
Begin
  teclado := SDL_GetKeyboardState(Nil);
  If (teclado[SDL_SCANCODE_A] = 1) Or (teclado[SDL_SCANCODE_LEFT] = 1) Then
    rot := rot - velocidadMaxima;
  If (teclado[SDL_SCANCODE_D] = 1) Or (teclado[SDL_SCANCODE_RIGHT] = 1) Then
    rot := rot + velocidadMaxima;
  rotacion := rot;
End;

Function dibujarNave(render : PSDL_Renderer; figura : tNave; width, height : Integer; rotacion : Real) : tNave;
var
  tex : PSDL_Texture;
  rectangulo : TSDL_Rect;
  teclado : PUInt8;
Begin
  teclado := SDL_GetKeyboardState(Nil);

  rectangulo.x := Round(figura.pos.x) - width Div 2;
  rectangulo.y := Round(figura.pos.y) - height Div 2;
  rectangulo.w := width;
  rectangulo.h := height;

  If (teclado[SDL_SCANCODE_W] = 1) Or (teclado[SDL_SCANCODE_UP] = 1) Then
    tex := IMG_LoadTexture(render, './media/img/nave1.png')
  else
    tex := IMG_LoadTexture(render, './media/img/nave0.png');

  SDL_RenderCopyEx(render, tex, Nil, @rectangulo, rotacion + 90, Nil, 1);
  dibujarNave := figura;
End;

function evento(ev : PSDL_Event) : Boolean;
var
  running : Boolean = True;
  teclado : PUInt8;
begin
  teclado := SDL_GetKeyboardState(Nil);
  If (teclado[SDL_SCANCODE_ESCAPE] = 1) Or (ev^.window.event = SDL_WINDOWEVENT_CLOSE) Then
    running := False;
  evento := running;
end;

End.
