attribute vec4 PositionIn;
attribute vec2 TexCoordIn;

uniform mat4 ModelViewProjectionMatrix;
uniform vec2 TextureCompressionIn;

varying vec2 TexCoordOut;

void main()
{
    gl_Position = ModelViewProjectionMatrix * PositionIn;
    TexCoordOut = TexCoordIn * TextureCompressionIn;
}