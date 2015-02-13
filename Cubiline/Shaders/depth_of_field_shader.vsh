attribute vec4 PositionIn;
attribute vec2 TexCoordIn;

uniform float NearIn;
uniform float FarIn;

varying vec2 TexCoordOut;
varying float NearOut;
varying float NearFar2Out;
varying float NearPlusFarOut;
varying float FarMinusNearOut;
varying highp float normalizedDistance;

void main()
{
    gl_Position = PositionIn;
    TexCoordOut = TexCoordIn;
	NearOut = NearIn;
    NearFar2Out = 2.0 * NearIn * FarIn;
    NearPlusFarOut = FarIn + NearIn;
    FarMinusNearOut = FarIn - NearIn;
	normalizedDistance = 1.0 / FarMinusNearOut;
}