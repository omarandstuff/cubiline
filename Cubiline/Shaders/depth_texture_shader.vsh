attribute vec4 PositionIn;
attribute vec2 TexCoordIn;

varying vec2 TexCoordOut;

void main()
{
    gl_Position = PositionIn;
    TexCoordOut = TexCoordIn;
}