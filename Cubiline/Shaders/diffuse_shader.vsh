attribute vec4 PositionIn;
attribute vec2 TexCoordIn;
attribute vec3 NormalIn;

uniform mat4 ModelViewProjectionMatrix;
uniform highp mat3 NormalMatrix;
uniform lowp mat4 ModelMatrix;
uniform vec2 TextureCompressionIn;

varying vec3 PositionOut;
varying vec2 TexCoordOut;
varying vec3 NormalOut;

void main()
{
    gl_Position = ModelViewProjectionMatrix * PositionIn;
    
    PositionOut = (ModelMatrix * PositionIn).xyz;;
    TexCoordOut = TexCoordIn * TextureCompressionIn;
	NormalOut = normalize(NormalMatrix * NormalIn);
}