Program test2;
{$UNITPATH ../lib/units}

Uses sdl2, sdl2_image;

Const 
    xPos =   250;
    yPos =   250;
    width =   50;
    height =   50;

Var 
    ventana :   PSDL_Window;
    render :   PSDL_Renderer;
    rectangulo :   TSDL_Rect;
    teclado :   PUInt8;
    running :   Boolean =   True;
    velocidadx,velocidady :   LongInt;
    aceleracion :    Real =   0.2;
    vel :   integer =   1;
    maxVelocidad :   Integer =   8;
    ventanaW :   Integer =   800;
    ventanaH :   Integer =   600;
    evento :   PSDL_Event;

Function mover(vx,vy : LongInt):   TSDL_Rect;
Var 
    rect :   PSDL_Rect;
Begin
    rectangulo.x := rectangulo.x + vx;
    rectangulo.y := rectangulo.y + vy;

    If (rectangulo.x > ventanaW) Then
        rectangulo.x := -50
    Else If (rectangulo.x < -50) Then
        rectangulo.x := ventanaW
    Else If (rectangulo.y > ventanaH) Then
        rectangulo.y := -50
    Else If (rectangulo.y < -50) Then
        rectangulo.y := ventanaH;

    velocidadx := vx;
    velocidady := vy;
    mover := rectangulo;
End;


Function mando(teclado: PUInt8; rectangulo : TSDL_Rect) :   TSDL_Rect;
Begin
    If vel > maxVelocidad Then
        vel := maxVelocidad;

    If (teclado[SDL_SCANCODE_W] = 1) Or (teclado[SDL_SCANCODE_UP] = 1) Then
        velocidady := velocidady - vel
    Else If (teclado[SDL_SCANCODE_A] = 1) Or (teclado[SDL_SCANCODE_LEFT] = 1) Then
        velocidadx := velocidadx - vel
    Else If (teclado[SDL_SCANCODE_D] = 1) Or (teclado[SDL_SCANCODE_RIGHT] = 1) Then
        velocidadx := velocidadx + vel
    Else If (teclado[SDL_SCANCODE_S] = 1) Or (teclado[SDL_SCANCODE_DOWN] = 1) Then
        velocidady := velocidady + vel
    Else
        Begin
            If velocidadx > 0 Then
                velocidadx := velocidadx - vel
            Else If velocidadx < 0 Then
                velocidadx := velocidadx + vel;
            If velocidady > 0 Then
                velocidady := velocidady - vel
            Else If velocidady < 0 Then
                velocidady := velocidady + vel;
        End;

    If (teclado[SDL_SCANCODE_ESCAPE] = 1) Or (evento^.window.event = SDL_WINDOWEVENT_CLOSE) Then
        running := False;

    mando := mover(velocidadx,velocidady);
End;

Procedure salir;
Begin
    Dispose(evento);
    // clear memory
    SDL_DestroyRenderer(render);
    SDL_DestroyWindow(ventana);
    //closing SDL2
    SDL_Quit;
End;

Procedure generarRectangulo;
Begin
    rectangulo.x := xPos;
    rectangulo.y := yPos;
    rectangulo.w := width;
    rectangulo.h := height;
End;

Procedure crearVentanaYRender;
Begin
    ventana := SDL_CreateWindow('Cacaroid', 50, 50, ventanaW, ventanaH, SDL_WINDOW_SHOWN);
    If ventana = Nil Then Halt;
    render := SDL_CreateRenderer(ventana, -1, 0);
    If render = Nil Then Halt;
End;

Begin
    //initilization of video subsystem
    If SDL_Init(SDL_INIT_VIDEO) < 0 Then Halt;
    crearVentanaYRender;
    New(evento);

    // prepare rectangle
    generarRectangulo;
    // program loop
    While running Do
        Begin
            SDL_PollEvent(evento);
            teclado := SDL_GetKeyboardState(Nil);
            rectangulo := mando(teclado, rectangulo);

            // grey background
            SDL_SetRenderDrawColor(render, 20, 20, 20, SDL_ALPHA_OPAQUE);
            SDL_RenderClear(render);

            // draw red rectangle
            SDL_SetRenderDrawColor(render, 255, 0, 0, SDL_ALPHA_OPAQUE);
            SDL_RenderFillRect(render, @rectangulo);
            SDL_RenderPresent(render);
            SDL_Delay(30);
        End;
    salir;
End.
