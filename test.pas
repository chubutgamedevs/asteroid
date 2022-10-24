Program test;
{$UNITPATH ../lib/units}

Uses sdl2, sdl2_image, sdl2_mixer;

Const 
  width =   34;
  height =   50;

Var 
  ventana :   PSDL_Window;
  render :   PSDL_Renderer;
  nave :  PSDL_Texture;
  icon :  PSDL_Surface;
  rectangulo :   TSDL_Rect;
  event :   PSDL_Event;
  teclado :   PUInt8;
  velocidad :   Integer =   6;
  ventanaW :   Integer =   800;
  ventanaH :   Integer =   600;
  gradosRotacion : Real =   0;
  running :   Boolean =   True;
  motor, disparo :   PMix_Chunk;
  spaceship :   PMix_Music;

Procedure salir;
Begin
  Dispose(event);
  SDL_DestroyRenderer(render);
  SDL_DestroyWindow(ventana);
  Mix_FreeMusic(spaceship);
  Mix_FreeChunk(motor);
  Mix_FreeChunk(disparo);

  Mix_CloseAudio;
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
  ventana := SDL_CreateWindow('Pascalroid', 50, 50, ventanaW, ventanaH, SDL_WINDOW_SHOWN);
  If ventana = Nil Then Halt;
  render := SDL_CreateRenderer(ventana, -1, 0);
  If render = Nil Then Halt;
  motor := Mix_LoadWAV('../media/sound/motor.wav');
  If motor = Nil Then Halt;
  disparo := Mix_LoadWAV('../media/sound/shoot.wav');
  If disparo = Nil Then Halt;
  spaceship := Mix_LoadMUS('../media/sound/spaceship.wav');
  If spaceship = Nil Then Halt;

  icon := IMG_Load('../media/img/pascalroid.ico');
  SDL_SetWindowIcon(ventana, icon);
  Mix_VolumeChunk(motor, MIX_MAX_VOLUME);
  Mix_VolumeMusic(MIX_MAX_VOLUME);
  teclado := SDL_GetKeyboardState(Nil);
End;


Function mando(teclado: PUInt8; rectangulo : TSDL_Rect) :   TSDL_Rect;
Begin
  If rectangulo.x > ventanaW Then
    rectangulo.x := -50
  Else If rectangulo.x < -50 Then
    rectangulo.x := ventanaW
  Else If rectangulo.y > ventanaH Then
    rectangulo.y := -50
  Else If rectangulo.y < -50 Then
    rectangulo.y := ventanaH;

  // WASD keys pressed
  If (teclado[SDL_SCANCODE_W] = 1) Or (teclado[SDL_SCANCODE_UP] = 1) Then
    Begin
      rectangulo.x := rectangulo.x + Round(cos(gradosRotacion * pi / 180) * velocidad);
      rectangulo.y := rectangulo.y + Round(sin(gradosRotacion * pi / 180) * velocidad);
      nave := IMG_LoadTexture(render, '../media/img/nave1.png');
      Mix_PlayChannel(2, motor, 0);
    End
  Else
    Begin
      Mix_HaltChannel(2);
      nave := IMG_LoadTexture(render, '../media/img/nave0.png');
    End;

  If (teclado[SDL_SCANCODE_A] = 1) Or (teclado[SDL_SCANCODE_LEFT] = 1) Then
    gradosRotacion := gradosRotacion - velocidad;
  If (teclado[SDL_SCANCODE_D] = 1) Or (teclado[SDL_SCANCODE_RIGHT] = 1) Then
    gradosRotacion := gradosRotacion + velocidad;
  If teclado[SDL_SCANCODE_SPACE] = 1 Then
      Mix_PlayChannel(3, disparo, 0);

  // ESC pressed
  If (event^.window.event = SDL_WINDOWEVENT_CLOSE) Or (teclado[SDL_SCANCODE_ESCAPE] = 1) Then
    running := False;

  mando := rectangulo;
End;

Begin
  //initilization of video subsystem
  If SDL_Init(SDL_INIT_VIDEO Or SDL_INIT_AUDIO) < 0 Then Halt;
  // Prepare mixer
  If Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, MIX_DEFAULT_CHANNELS, 4096) < 0 Then Halt;

  crearVentaraYRender;
  New(event);

  // prepare rectangle
  generarRectangulo;
  Mix_PlayMusic(spaceship, -1);

  // program loop
  While running Do
    Begin
      SDL_PollEvent(event);
      rectangulo := mando(teclado, rectangulo);

      SDL_RenderClear(render);

      // draw rectangle
      SDL_RenderCopyEx(render, nave, Nil, @rectangulo, gradosRotacion + 90, Nil, 1);
      SDL_RenderPresent(render);
      SDL_Delay(20);
    End;
  salir;
End.
