Unit vectores;

Interface

Uses math;

Type 
  vect = Record
    x, y : Real
  End;

Function norma(v : vect) : Real;
Function normalize(v : vect) : vect;
Function limit(v : vect; max : Real) : vect;
Function sumar(v, w : vect) : vect;
Function multEscalar(v : vect; num : Real) : vect;
Function vectZero() : vect;
Function newVect(x : Real; y : Real) : vect;
Function rotVect(vec : vect; angulo : Real) : vect;
Function rad(angulo : Real) : Real;

Implementation

Function norma(v : vect) : Real;
Begin
  norma := Sqrt(Sqr(v.x) + Sqr(v.y));
End;

Function sumar(v, w : vect) : vect;
Begin
  sumar.x := v.x + w.x;
  sumar.y := v.y + w.y;
End;

Function multEscalar(v : vect; num : Real) : vect;
Begin
  multEscalar.x := v.x * num;
  multEscalar.y := v.y * num;
End;

Function normalize(v : vect) : vect;
Begin
  normalize := multEscalar(v, 1 / norma(v));
End;

Function limit(v : vect; max : Real) : vect;
Begin
  If norma(v) > max Then
    limit := multEscalar(normalize(v), max)
  Else
    limit := v;
End;

Function vectZero() : vect;
Begin
  vectZero.x := 0;
  vectZero.y := 0;
End;

Function newVect(x : Real; y : Real) : vect;
Begin
  newVect.x := x;
  newVect.y := y;
End;

function rad(angulo : Real) : Real;
begin
  rad := angulo * Pi / 180;
end;

Function rotVect(vec : vect; angulo : Real) : vect;
Begin
  rotVect.x := Round(cos(rad(angulo)) * vec.x) - Round(sin(rad(angulo)) * vec.y);
  rotVect.y := Round(sin(rad(angulo)) * vec.x) + Round(cos(rad(angulo)) * vec.y);
End;

End.
