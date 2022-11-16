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
function newVect(x : Real; y : Real) : vect;
//function rotar(vec : vect; angulo : Real) : Real;

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

function newVect(x : Real; y : Real) : vect;
begin
  newVect.x := x;
  newVect.y := y;
end;

End.
