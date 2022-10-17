
Program Tron;

Uses 
Crt,Dos,Graph;

Label 
  1;

Var 
  gd,gm,size: integer;
  x,y,pxc,fl,sc,xr,yr,c,j,j2,u: integer;
  a,b: char;
  AA,Run: boolean;
  d,x2,y2,pxc2,sc2,j12,j22, c1: integer;
Begin
  clrscr;
  textcolor(white);
  writeln('-- Tron Game -- By Pascal Home --');
  writeln;
  textcolor(yellow);
  writeln('You must ride your snake with these keys:');
  writeln;
  writeln('Player 1:');
  textcolor(lightgreen);
  writeln('Up     : up arrow key');
  writeln('Down   : down arrow key');
  writeln('Right  : right arrow key');
  writeln('Left   : left arrow key');
  writeln;
  textcolor(yellow);
  writeln('Player 2:');
  textcolor(lightgreen);
  writeln('Up     : W');
  writeln('Down   : S');
  writeln('Right  : D');
  writeln('Left   : A');
  textcolor(lightred);
  writeln;
  writeln('Escape : Exit');
  textcolor(black);
  readln;
  gd := detect;
  initgraph(gd,gm,'c:\');
  randomize;
  Run := true;
  x2 := 20;
  y2 := 20;
  sc := 10;
  sc2 := 10;
  x := getmaxx-20;
  y := getmaxy-20;
  setcolor(lightgreen);
  xr := random(getmaxx-100)+50;
  yr := random(getmaxy-100)+50;
  For u:=1 To 3 Do
    circle(xr,yr,u);
  d := 5;
  aa := true;
  While (run) Do
    Begin
      setcolor(yellow);
      rectangle(0,0,getmaxx,getmaxy);
      If (keypressed)Then
        Begin
          b := a;
          a := readkey;
          If (ord(a)=27)Then
            Begin
              break;
              run := false;
            End;
          If (a=chr(0))Then
            Begin
              a := readkey;
              If (ord(a)=77)Then
                j2 := 1;
              If (ord(a)=75)Then
                j2 := 2;
              If (ord(a)=72)Then
                j2 := 3;
              If (ord(a)=80)Then
                j2 := 4;
            End
          Else
            Begin
              If (a='d')Or(a='D')Then
                j22 := 1;
              If (a='a')Or(a='A')Then
                j22 := 2;
              If (a='w')Or(a='W')Then
                j22 := 3;
              If (a='s')Or(a='S')Then
                j22 := 4;
            End;
        End;
      fl := 0;
      If ((abs(x-xr))<=10)And((abs(y-yr))<=10)Then
        Begin
          sc := sc+1;
          setcolor(black);
          For u:=1 To 3 Do
            circle(xr,yr,u);
          sound(2500);
          fl := 1;
        End;
      If ((abs(x2-xr))<=10)And((abs(y2-yr))<=10)Then
        Begin
          sc2 := sc2+1;
          setcolor(black);
          For u:=1 To 3 Do
            circle(xr,yr,u);
          sound(2500);
          fl := 1;
        End;
      c := 0;

      1: If (fl=1)Then
           Begin
             c := 0;
             xr := random(getmaxx-50)+50;
             yr := random(getmaxy-50)+50;
             Repeat
               c := c+1;
               If (Not(((getpixel(xr,yr)=black)And(getpixel(xr+c,yr)=black)
                  And(getpixel(xr,yr+c)=black)And(getpixel(xr-c,yr)=black)
                  And(getpixel(xr,yr-c)=black))))Then
                 goto 1;
             Until (c=25);
             setcolor(lightgreen);
             For u:=1 To 3 Do
               circle(xr,yr,u);
           End;
      If (((j2=1)And(j=2))Or((j2=2)And(j=1))Or
         ((j2=3)And(j=4))Or((j2=4)And(j=3)))Then
        j2 := j;
      If (j2=1)Then
        Begin
          x := x+1;
          pxc := getpixel(x+3,y);
        End;
      If (j2=2)Then
        Begin
          x := x-1;
          pxc := getpixel(x-3,y);
        End;
      If (j2=3)Then
        Begin
          y := y-1;
          pxc := getpixel(x,y-3);
        End;
      If (j2=4)Then
        Begin
          y := y+1;
          pxc := getpixel(x,y+3);
        End;
      j := j2;
      nosound;
      setcolor(white);
      circle(x,y,2);
      c1 := 0;
      If (((j22=1)And(j12=2))Or((j22=2)And(j12=1))Or
         ((j22=3)And(j12=4))Or((j22=4)And(j12=3)))Then
        j22 := j12;
      If (j22=1)Then
        Begin
          x2 := x2+1;
          pxc2 := getpixel(x2+3,y2);
        End;
      If (j22=2)Then
        Begin
          x2 := x2-1;
          pxc2 := getpixel(x2-3,y2);
        End;
      If (j22=3)Then
        Begin
          y2 := y2-1;
          pxc2 := getpixel(x2,y2-3);
        End;
      If (j22=4)Then
        Begin
          y2 := y2+1;
          pxc2 := getpixel(x2,y2+3);
        End;
      j12 := j22;
      setcolor(lightred);
      delay(8);
      circle(x2,y2,2);
      nosound;
      If ((abs(x-x2))<=5)And((abs(y-y2))<=5)Then
        Begin
          sc := sc-5;
          sc2 := sc2-5;
          setcolor(lightgreen);
          size := 2;
          SetTextStyle(DefaultFont, HorizDir, Size);
          outtextxy(5,5,'Draw!');
          delay(1500);
          aa := false;
          run := false;
          break;
        End;
      If (pxc2=white)Or(pxc2=yellow)Or(pxc2=lightred)And(aa)Then
        Begin
          setcolor(lightgreen);
          size := 2;
          SetTextStyle(DefaultFont, HorizDir, Size);
          outtextxy(5,5,'Player 2 Loses!');
          sc2 := sc2-5;
          delay(1500);
          run := false;
        End;
      If ((pxc=white)Or(pxc=yellow)Or(pxc=lightred))And(aa)Then
        Begin
          setcolor(lightgreen);
          size := 2;
          SetTextStyle(DefaultFont, HorizDir, Size);
          outtextxy(5,5,'Player 1 Loses!');
          sc := sc-5;
          delay(1500);
          run := false;
          break;
        End;
    End;
  closegraph;
  textcolor(yellow);
  writeln('Player 1: ',sc,' points');
  textcolor(lightgreen);
  writeln;
  writeln('Player 2: ',sc2,' points');
  textcolor(black);
  delay(2000);
  readln;
End.
