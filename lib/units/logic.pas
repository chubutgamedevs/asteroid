Unit logic;

Interface

Uses sdl2, sdl2_image, vectores;

Function boundary(fig : figVect; winW, winH : Integer) : figVect;
Function moverNave(fig : figVect; vel : vect) : figVect;
Function kInput(render : PSDL_Renderer; acc: vect; fig : figVect) : vect;
Function rotacion(velMax : Integer; fig : figVect) : figVect;
Function dibujarNave(render : PSDL_Renderer; fig : figVect; w, h : Integer) : figVect;
Function evento(ev : PSDL_Event) : Boolean;
Function centerPos(winH, winW, w, h : Integer) : figVect;
Function generarAsteroide(r : Real; pos : vect; lado : Integer) : figVect;
Function collider(obj1, obj2 : figVect) : Boolean;
Function raycast(fig1, fig2 : figVect) : Real;
Procedure dibujarAsteroide(render : PSDL_Renderer; a : figVect);
procedure kDisparo(render : PSDL_Renderer; fig : figVect; ArrAst : Array Of figVect; d : Real);
Procedure disparo(render : PSDL_Renderer; fig : figVect; dist : Real);

Implementation

Function raycast(fig1, fig2 : figVect) : Real;
Var 
  e, d: vect;
  a, bSq, rSq, f: Real;
Begin
  e := restar(fig2.pos, fig1.pos);
  // El vector entre el raycast y el centro del circulo.
  d := newPolarVect(1, fig1.rot);
  // dirección del raycast (norma 1)
  a := dot(e, d);
  // Longitud de la proyección de e sobre d
  bSq := lengthSq(e) - (a * a);
  rSq := fig2.r * fig2.r;
  If (rSq - bSq) < 0 Then
    Begin
      // No le pega
      raycast := 2000;
      //WriteLn('No pega');
      // "Infinito"
      exit;
    End;
  f := Sqrt(rSq - bSq);
  If a < f Then
    Begin
      raycast := 2000;
      exit
    End;
  If (lengthSq(e) < rSq) Then
    raycast := a + f // Está dentro del circulo, quizás debería ser 0
  Else
    begin
    raycast := a - f;
    //WriteLn('Pega');
    end;
  // Le pega.
End;

Procedure disparo(render : PSDL_Renderer; fig : figVect; dist : Real);
Var 
  vet, tip : vect;
Begin
  tip := newPolarVect(dist, fig.rot);
  tip := sumar(tip, fig.pos);
  vet.x := fig.pos.x + Round(cos(rad(fig.rot)) * 2000);
  vet.y := fig.pos.y + Round(sin(rad(fig.rot)) * 2000);

  SDL_SetRenderDrawColor(render, 255, 255, 255, 0);
  SDL_RenderDrawLine(render, Round(fig.pos.x), Round(fig.pos.y), Round(tip.x), Round(tip.y));
End;

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

Function kInput(render : PSDL_Renderer; acc: vect; fig : figVect) : vect;
Var 
  input : PUInt8;
Begin
  input := SDL_GetKeyboardState(Nil);
  acc := vectZero();

  If (input[SDL_SCANCODE_W] = 1) Or (input[SDL_SCANCODE_UP] = 1) Then
    Begin
      acc.x := acc.x + Round(cos(rad(fig.rot)) * 1);
      acc.y := acc.y + Round(sin(rad(fig.rot)) * 1)
    End;
  kInput := acc
End;

procedure kDisparo(render : PSDL_Renderer; fig : figVect; ArrAst : array of figVect; d : Real);
var
  input : PUInt8;
  i : Integer;
begin
  input := SDL_GetKeyboardState(Nil);
  If input[SDL_SCANCODE_SPACE] = 1 Then
    disparo(render, fig, d)
end;

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

Function centerPos(winH, winW, w, h : Integer) : figVect;
Begin
  centerPos.pos.x := (winW Div 2) - (w Div 2);
  centerPos.pos.y := (winH Div 2) - (h Div 2)
End;

Procedure dibujarAsteroide(render : PSDL_Renderer; a : figVect);
Var 
  i : Integer;
  v, u : vect;
Begin
  SDL_SetRenderDrawColor(render, 255, 255, 255, 255);
  For i := 0 To (a.lado - 1) Do
    Begin
      v := a.puntos[i];
      u := a.puntos[(i + 1) Mod a.lado];
      // Rotar
      v := rotVect(v, a.rot);
      u := rotVect(u, a.rot);
      // Trasladar
      v := sumar(v, a.pos);
      u := sumar(u, a.pos);
      SDL_RenderDrawLine(render, Round(v.x), Round(v.y), Round(u.x), Round(u.y))
    End
End;

Function generarAsteroide(r : Real; pos : vect; lado : Integer) : figVect;
Var 
  res : figVect;
  i : Integer;
Begin
  res.r := r;
  res.pos := pos;
  res.lado := lado;
  SetLength(res.puntos, lado);

  For i := 0 To (lado - 1) Do
    Begin
      res.puntos[i].x := Round(r * cos(i * 2 * Pi / lado));// + random(Round(r) Div 2));
      res.puntos[i].y := Round(r * sin(i * 2 * Pi / lado));// + (Round(r) Div 2));
    End;
  res.vel := newVect(random(6) - 3, random(6) - 3);
  If (res.vel.x = 0) And (res.vel.y = 0) Then
    res.vel := newVect(random(4) + 1, random(4) + 1);
  generarAsteroide := res
End;

Function collider(obj1, obj2 : figVect) : Boolean;
Var 
  dr : Real;
Begin
  dr := distFig(obj1, obj2) - obj2.r - obj1.r;
  collider := dr <= 0
End;

Function evento(ev : PSDL_Event) : Boolean;
Var 
  input : PUInt8;
Begin
  input := SDL_GetKeyboardState(Nil);
  evento := Not ((input[SDL_SCANCODE_ESCAPE] = 1) Or (ev^.window.event = SDL_WINDOWEVENT_CLOSE))
End;

End.
