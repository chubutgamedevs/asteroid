Unit vectores;

Interface

Uses math, sdl2;

Type 
  vect = Record
    x, y : Real
  End;
  figVect = Record
    pos, vel : vect;
    rot, r : Real;
    lado : Integer;
    puntos : array Of vect
  End;

Function norma(v : vect) : Real;
Function normalize(v : vect) : vect;
Function limit(v : vect; max : Real) : vect;
Function sumar(v, w : vect) : vect;
Function restar(v, w : vect) : vect;
Function multEscalar(v : vect; num : Real) : vect;
Function vectZero() : vect;
Function newVect(x : Real; y : Real) : vect;
Function rotVect(vec : vect; angulo : Real) : vect;
Function rad(angulo : Real) : Real;
Function distFig(obj1, obj2 : figVect) : Real;
Function newPolarVect(r, angulo : Real) : vect;
Function dot(u, v : vect) : Real;
Function setColor(r, g, b, a : Byte) : TSDL_Color;
Function lengthSq(v: vect): Real;

Implementation

Function dot(u, v : vect) : Real;
Begin
  dot := (u.x * v.x) + (u.y * v.y)
End;

Function norma(v : vect) : Real;
Begin
  norma := Sqrt(Sqr(v.x) + Sqr(v.y))
End;

Function sumar(v, w : vect) : vect;
Begin
  sumar.x := v.x + w.x;
  sumar.y := v.y + w.y
End;

Function restar(v, w : vect) : vect;
Begin
  restar.x := v.x - w.x;
  restar.y := v.y - w.y
End;

Function multEscalar(v : vect; num : Real) : vect;
Begin
  multEscalar.x := v.x * num;
  multEscalar.y := v.y * num
End;

Function normalize(v : vect) : vect;
Begin
  normalize := multEscalar(v, 1 / norma(v))
End;

Function limit(v : vect; max : Real) : vect;
Begin
  If norma(v) > max Then
    limit := multEscalar(normalize(v), max)
  Else
    limit := v
End;

Function vectZero() : vect;
Begin
  vectZero.x := 0;
  vectZero.y := 0
End;

Function newVect(x : Real; y : Real) : vect;
Begin
  newVect.x := x;
  newVect.y := y
End;

Function rad(angulo : Real) : Real;
Begin
  rad := angulo * Pi / 180
End;

Function newPolarVect(r, angulo : Real) : vect;
Begin
  newPolarVect.x := r * cos(rad(angulo));
  newPolarVect.y := r * sin(rad(angulo))
End;

Function rotVect(vec : vect; angulo : Real) : vect;
Begin
  rotVect.x := Round(cos(rad(angulo)) * vec.x) - Round(sin(rad(angulo)) * vec.y);
  rotVect.y := Round(sin(rad(angulo)) * vec.x) + Round(cos(rad(angulo)) * vec.y)
End;

Function distFig(obj1, obj2 : figVect) : Real;
Var 
  res : vect;
Begin
  res.x := obj1.pos.x - obj2.pos.x;
  res.y := obj1.pos.y - obj2.pos.y;
  distFig := norma(res)
End;

Function lengthSq(v: vect): Real;
Begin
  lengthSq := v.x * v.x + v.y * v.y;
End;

Function setColor(r, g, b, a : Byte) : TSDL_Color;
begin
  setColor.r := r;
  setColor.g := g;
  setColor.b := b;
  setColor.a := a;
end;

End.
