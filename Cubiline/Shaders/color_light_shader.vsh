attribute vec4 PositionIn;
attribute vec3 NormalIn;

uniform mat4 ModelViewProjectionMatrix;

varying vec4 PositionOut;
varying vec3 NormalOut;

void main()
{
	gl_Position = ModelViewProjectionMatrix * PositionIn;
	
	PositionOut = PositionIn;
	NormalOut = NormalIn;
}