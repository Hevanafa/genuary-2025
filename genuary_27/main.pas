unit main;

{$mode Delphi}

interface
uses
  Classes, SysUtils,
  math,
  { Raylib elements }
  cmem,
  {uncomment if necessary}
  //raymath,
  //rlgl,
  raylib;


type
  TRGB = packed record
    R: integer;
    G: integer;
    B: integer
  end;

  TProgram = class
    private
      var
        t, n: integer;
        up: boolean;

      const
        screenWidth = 640;
        screenHeight = 360;

        CORNFLOWERBLUE: TColorB = (r: 100; g: 149; b: 237; a: 255);

      procedure init;
      procedure update;
      procedure draw;

      function hsv2rgb(h, s, v: single): TRGB;

      function lerp(a, z, perc: single): single;
      function easeOutQuad(n: single): single;
      function lerpEaseOutQuad(a, z, perc: single): single;

    public
      constructor create;

  end;

implementation

procedure TProgram.init;
begin
  InitWindow(screenWidth, screenHeight, 'Raylib + Pascal');
  SetTargetFPS(60);

  t:=0; n:=0; up:=true;
end;

procedure TProgram.update;
begin
  t:=t + 1;
  n:=(n mod 60)+1;

  //if up then n:=n + 1 else n:=n - 1;
  //if n > 300 then begin
  //  n:=n-1
  //end;
  //if (t-600) mod 900 = 0 then
  //  up:=not up;
end;

function TProgram.lerp(a, z, perc: single): single;
begin
  result := (z - a) * perc + a
end;

function TProgram.easeOutQuad(n: single): single;
begin
  result := n * n
end;

function TProgram.lerpEaseOutQuad(a, z, perc: single): single;
begin
  result := lerp(a, z, easeOutQuad(perc))
end;

procedure TProgram.draw;
var
  a, x, y: integer;
  colour: TColorB = (r:0; g:0; b:0; a:255);
  tempRGB: TRGB;
begin
  BeginDrawing;

  ClearBackground(BLACK);
  //DrawText(pchar(format('%d', [t])), 10, 10, 12, RAYWHITE);

  a:=0;
  while a <= 10 do begin
    tempRGB := hsv2rgb((a + t) / 30, 0.5, 1);
    colour.r := tempRGB.R;
    colour.g := tempRGB.G;
    colour.b := tempRGB.B;

    x:=trunc(lerpEaseOutQuad(0, screenWidth, (a + n / 60) / 10));

    drawline(
      trunc(x), 0,
      trunc(x), screenHeight,
      colour);

    drawline(
      screenWidth - trunc(x), 0,
      screenWidth - trunc(x), screenHeight,
      colour);

    y:=trunc(lerpEaseOutQuad(0, screenHeight, (a + n / 60) / 10));
    drawline(
      0, trunc(y),
      screenWidth, trunc(y),
      colour);

    drawline(
      0, screenHeight - trunc(y),
      screenWidth, screenHeight - trunc(y),
      colour);

    a:=a + 1
  end;

  EndDrawing
end;

function TProgram.hsv2rgb(h, s, v: single): TRGB;
var
  r, g, b, f, p, q, t: single;
  i: integer;
begin
  r := 0; g := 0; b := 0;
  i := floor(h * 6);
  f := h * 6 - i;
  p := v * (1.0 - s);
  q := v * (1.0 - f * s);
  t := v * (1.0 - (1.0 - f) * s);

  case i mod 6 of
    0: begin r:=v; g:=t; b:=p; end;
    1: begin r:=q; g:=v; b:=p; end;
    2: begin r:=p; g:=v; b:=t; end;
    3: begin r:=p; g:=q; b:=v; end;
    4: begin r:=t; g:=p; b:=v; end;
    5: begin r:=v; g:=p; b:=q; end;
  end;

  result.R := round(r * 255);
  result.G := round(g * 255);
  result.B := round(b * 255)
end;

constructor TProgram.create;
begin
  init;

  // Main game loop
  while not WindowShouldClose do begin
    update;
    draw;
  end;

  // De-Initialization
  // Close window and OpenGL context
  CloseWindow;
end;

end.

