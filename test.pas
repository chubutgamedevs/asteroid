Program test;
{$UNITPATH ./units}
//penis
Uses SDL2, SDL2_image, sdl2_mixer;

Const 
  width =   44;
  height =   60;

Var 
  ventana :   PSDL_Window;
  render :   PSDL_Renderer;
  nave :  PSDL_Texture;
  rectangulo :   TSDL_Rect;
  event :   PSDL_Event;
  teclado :   PUInt8;
  velocidad :   Integer =   8;
  ventanaW :   Integer =   800;
  ventanaH :   Integer =   600;
  gradosRotacion : Real =   0;
  running :   Boolean =   True;
  motor :   PMix_Chunk;

Function mando(teclado: PUInt8; rectangulo : TSDL_Rect) :   TSDL_Rect;
Begin
  If (rectangulo.x > ventanaW) Then
    rectangulo.x := -50
  Else If (rectangulo.x < -50) Then
    rectangulo.x := ventanaW
  Else If (rectangulo.y > ventanaH) Then
    rectangulo.y := -50
  Else If (rectangulo.y < -50) Then
    rectangulo.y := ventanaH;

  // WASD keys pressed
  If (teclado[SDL_SCANCODE_W] = 1) Or (teclado[SDL_SCANCODE_UP] = 1) Then
    Begin
      rectangulo.x := rectangulo.x + Round(cos(gradosRotacion * pi / 180) * velocidad);
      rectangulo.y := rectangulo.y + Round(sin(gradosRotacion * pi / 180) * velocidad);
      nave := IMG_LoadTexture(render, './ImgNAve/nave1.png');
      if Mix_PlayChannel(1, motor, 0) < 0 Then Writeln(SDL_GetError);
    End
  Else
    nave := IMG_LoadTexture(render, './ImgNAve/nave0.png');
  If (teclado[SDL_SCANCODE_A] = 1) Or (teclado[SDL_SCANCODE_LEFT] = 1) Then
    gradosRotacion := gradosRotacion - velocidad;
  If (teclado[SDL_SCANCODE_D] = 1) Or (teclado[SDL_SCANCODE_RIGHT] = 1) Then
    gradosRotacion := gradosRotacion + velocidad;
  //if (teclado[SDL_SCANCODE_ESCAPE] = 1) then


  // ESC pressed
  If event^.window.event = SDL_WINDOWEVENT_CLOSE Then
    running := False;

  mando := rectangulo;
End;

Procedure salir;
Begin
  Dispose(event);
  // clear memory
  SDL_DestroyRenderer(render);
  SDL_DestroyWindow(ventana);

  //closing SDL2
  SDL_Quit;
End;

Procedure generarRectangulo;
Begin
  rectangulo.x := ventanaW Div 2;
  rectangulo.y := ventanaH Div 2;
  rectangulo.w := width;
  rectangulo.h := height;
End;

Procedure crearVentaraYRender;
Begin
  ventana := SDL_CreateWindow('Cacaroid', 50, 50, ventanaW, ventanaH, SDL_WINDOW_SHOWN);
  If ventana = Nil Then Halt;
  render := SDL_CreateRenderer(ventana, -1, 0);
  If render = Nil Then Halt;
  motor := Mix_LoadWAV('./ImgNAve/motor.wav');
  If motor = Nil Then Exit;
  Mix_VolumeChunk(motor, MIX_MAX_VOLUME);
End;

Begin
  //initilization of video subsystem
  If SDL_Init(SDL_INIT_VIDEO or SDL_INIT_AUDIO) < 0 Then Halt;
  // Prepare mixer
  If Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, MIX_DEFAULT_CHANNELS, 4096) < 0 Then Halt;

  crearVentaraYRender;
  New(event);

  // prepare rectangle
  generarRectangulo;

  // program loop
  While running Do
    Begin
      SDL_PollEvent(event);
      teclado := SDL_GetKeyboardState(Nil);
      rectangulo := mando(teclado, rectangulo);

      // black background
      SDL_SetRenderDrawColor(render, 0, 0, 0, SDL_ALPHA_OPAQUE);
      SDL_RenderClear(render);

      // draw rectangle
      SDL_SetRenderDrawColor(render, 255, 0, 0, SDL_ALPHA_OPAQUE);
      SDL_RenderCopyEx(render, nave, Nil, @rectangulo, gradosRotacion + 90, Nil, 1);
      SDL_RenderPresent(render);
      SDL_Delay(20);
    End;
  salir;
End.
