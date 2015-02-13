varying lowp vec2 TexCoordOut;
varying lowp vec2 BlurTexCoords[4];
uniform sampler2D TextureOut;

void main()
{
    gl_FragColor = vec4(0.0);
	gl_FragColor += texture2D(TextureOut, BlurTexCoords[0]) * 0.093913;
	gl_FragColor += texture2D(TextureOut, BlurTexCoords[1]) * 0.304005;
	gl_FragColor += texture2D(TextureOut, TexCoordOut)		* 0.204164;
	gl_FragColor += texture2D(TextureOut, BlurTexCoords[2]) * 0.304005;
	gl_FragColor += texture2D(TextureOut, BlurTexCoords[3]) * 0.093913;
}