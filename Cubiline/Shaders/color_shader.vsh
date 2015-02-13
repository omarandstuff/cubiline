attribute vec4 PositionIn;

uniform mat4 ModelViewProjectionMatrix;

void main()
{
    gl_Position = ModelViewProjectionMatrix * PositionIn;
}