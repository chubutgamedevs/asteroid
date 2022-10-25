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
Function vectZero(v : vect) : vect;

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

Function vectZero(v : vect) : vect;
Begin
  v.x := 0;
  v.y := 0;
  vectZero := v;
End;

End.
