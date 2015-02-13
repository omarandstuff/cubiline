attribute vec4 PositionIn;
attribute vec2 TexCoordIn;
attribute vec3 NormalIn;

uniform mat4 ModelViewProjectionMatrix;
uniform vec2 TextureCompressionIn;

varying vec4 PositionOut;
varying vec2 TexCoordOut;
varying vec3 NormalOut;

void main()
{
    gl_Position = ModelViewProjectionMatrix * PositionIn;
    
    PositionOut = PositionIn;
    TexCoordOut = TexCoordIn * TextureCompressionIn;
    NormalOut = NormalIn;
}