Unit vectores;

Interface

Uses math;

Type 
  vect = Record
    x, y : Real
  End;

Function norma(v : vect) : Real;
Function sumar(v, w : vect) : vect;
Function multEscalar(v : vect; num : Real) : vect;

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

End.
