attribute vec4 PositionIn;
attribute vec2 TexCoordIn;

uniform float Radious;
uniform bool VHOption;
uniform float Step;

varying vec2 TexCoordOut;
varying vec2 BlurTexCoords[4];

void main()
{
    gl_Position = PositionIn;
    TexCoordOut = TexCoordIn;

	if(VHOption)
	{
		BlurTexCoords[0] = TexCoordIn + vec2(Step * Radious * 3.294215, 0.0);
		BlurTexCoords[1] = TexCoordIn + vec2(Step * Radious * 1.407333, 0.0);
		BlurTexCoords[2] = TexCoordIn + vec2(Step * Radious * -1.407333, 0.0);
		BlurTexCoords[3] = TexCoordIn + vec2(Step * Radious * -3.294215, 0.0);
	}
	else
	{
		BlurTexCoords[0] = TexCoordIn + vec2(0.0, Step * float(Radious) * 3.294215);
		BlurTexCoords[1] = TexCoordIn + vec2(0.0, Step * float(Radious) * 1.407333);
		BlurTexCoords[2] = TexCoordIn + vec2(0.0, Step * float(Radious) * -1.407333);
		BlurTexCoords[3] = TexCoordIn + vec2(0.0, Step * float(Radious) * -3.294215);
	}
}