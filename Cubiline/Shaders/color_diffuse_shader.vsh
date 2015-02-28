attribute vec4 PositionIn;
attribute vec3 NormalIn;

uniform mat4 ModelViewProjectionMatrix;
uniform highp mat3 NormalMatrix;
uniform lowp mat4 ModelMatrix;

varying vec3 PositionOut;
varying vec3 NormalOut;

void main()
{
    gl_Position = ModelViewProjectionMatrix * PositionIn;
	PositionOut = (ModelMatrix * PositionIn).xyz;
	NormalOut = normalize(NormalMatrix * NormalIn);
}