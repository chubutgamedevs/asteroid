Program test;
{$UNITPATH ./units}

Uses SDL2;

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
    velocidad :   Integer =   6;
    aceleracion :    Integer =   2;
    ventanaW :   Integer =   800;
    ventanaH :   Integer =   600;


Function mando(teclado: PUInt8; rectangulo : TSDL_Rect) :   TSDL_Rect;
Begin
    // WASD keys pressed
    If (teclado[SDL_SCANCODE_W] = 1) Or (teclado[SDL_SCANCODE_UP] = 1) Then
        rectangulo.y := rectangulo.y - velocidad;
    If (teclado[SDL_SCANCODE_A] = 1) Or (teclado[SDL_SCANCODE_LEFT] = 1) Then
        rectangulo.x := rectangulo.x - velocidad;
    If (teclado[SDL_SCANCODE_S] = 1) Or (teclado[SDL_SCANCODE_DOWN] = 1) Then
        rectangulo.y := rectangulo.y + velocidad;
    If (teclado[SDL_SCANCODE_D] = 1) Or (teclado[SDL_SCANCODE_RIGHT] = 1) Then
        rectangulo.x := rectangulo.x + velocidad;
    // ESC pressed
    If teclado[SDL_SCANCODE_ESCAPE] = 1 Then
        running := False;

    mando := rectangulo;
End;

Procedure salir;
Begin
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

Procedure crearVentaraYRender;
Begin
    ventana := SDL_CreateWindow('Cacaroid', 50, 50, ventanaW, ventanaH, SDL_WINDOW_SHOWN);
    If ventana = Nil Then Halt;
    render := SDL_CreateRenderer(ventana, -1, 0);
    If render = Nil Then Halt;
End;

Begin
    //initilization of video subsystem
    If SDL_Init(SDL_INIT_VIDEO) < 0 Then Halt;
    crearVentaraYRender;

    // prepare rectangle
    generarRectangulo;

    // program loop
    While running = True Do
        Begin
            SDL_PumpEvents;
            teclado := SDL_GetKeyboardState(Nil);
            rectangulo := mando(teclado, rectangulo);

            // black background
            SDL_SetRenderDrawColor(render, 0, 0, 0, SDL_ALPHA_OPAQUE);
            SDL_RenderClear(render);

            // draw red rectangle
            SDL_SetRenderDrawColor(render, 255, 0, 0, SDL_ALPHA_OPAQUE);
            SDL_RenderFillRect(render, @rectangulo);
            SDL_RenderPresent(render);
            SDL_Delay(20);
        End;
    salir;
End.
