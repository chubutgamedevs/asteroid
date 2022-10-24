
Unit logic;

Interface

Uses sdl2, vectores;

Type 
  PointType = Record
    x, y: Integer;
  End;
  tNave = Record
    pos: vect;
    rot: Real;
  End;

Function boundary(figura : TSDL_Rect; w, h : Integer) : TSDL_Rect;
Function limitarVel(velocidadActual : vect; velocidadMaxima : Integer) : vect;
function moverNave(Nave : tNave; velocidadActual : vect) : tNave;
Function input(aceleracion: vect; teclado : PUInt8; velocidadMaxima : Integer; rotacion : Real) : vect;
Function rotacion(rot : Real; teclado : PUInt8; velocidadMaxima : Integer) : Real;

Implementation

Function boundary(figura : TSDL_Rect; w, h : Integer) : TSDL_Rect;
Begin
  If figura.x > w Then
    figura.x := -figura.h
  Else If figura.x < -figura.h Then
    figura.x := w
  Else If figura.y > h Then
    figura.y := -figura.h
  Else If figura.y < -figura.h Then
    figura.y := h;
  boundary := figura;
End;

Function limitarVel(velocidadActual : vect; velocidadMaxima : Integer) : vect;
var
  vectorNormalizado : Real;
Begin
  vectorNormalizado := norma(velocidadActual);

  If velocidadActual.x > velocidadMaxima  Then
    velocidadActual.x := velocidadMaxima;

  if velocidadActual.x < -velocidadMaxima then
    velocidadActual.x := -velocidadMaxima;

  If velocidadActual.y > velocidadMaxima  Then
    velocidadActual.y := velocidadMaxima;

  If velocidadActual.y < -velocidadMaxima  Then
    velocidadActual.y := -velocidadMaxima;

  limitarVel := velocidadActual;
End;

Function moverNave(Nave : tNave; velocidadActual : vect) : tNave;
begin
  Nave.pos.x := Nave.pos.x + velocidadActual.x;
  Nave.pos.y := Nave.pos.y + velocidadActual.y;
  moverNave := Nave;
end;

Function input(aceleracion: vect; teclado : PUInt8; velocidadMaxima : Integer; rotacion : Real) : vect;
Begin
  aceleracion.x := 0;
  aceleracion.y := 0;

  If (teclado[SDL_SCANCODE_W] = 1) Or (teclado[SDL_SCANCODE_UP] = 1) Then
    Begin
      aceleracion.x := aceleracion.x + Round(cos(rotacion * pi / 180) * 2);
      aceleracion.y := aceleracion.y + Round(sin(rotacion * pi / 180) * 2);
    End;
  input := aceleracion;
End;

function rotacion(rot : Real; teclado : PUInt8; velocidadMaxima : Integer) : Real;
begin
  If (teclado[SDL_SCANCODE_A] = 1) Or (teclado[SDL_SCANCODE_LEFT] = 1) Then
    rot := rot - velocidadMaxima;
  If (teclado[SDL_SCANCODE_D] = 1) Or (teclado[SDL_SCANCODE_RIGHT] = 1) Then
    rot := rot + velocidadMaxima;
  rotacion := rot;
end;

End.
