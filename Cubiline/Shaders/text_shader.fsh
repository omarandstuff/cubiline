varying lowp vec2 TexCoordOut;
uniform sampler2D TextureOut;
uniform lowp vec4 ColorOut;
uniform lowp float OpasityOut;

void main()
{
	gl_FragColor = vec4(ColorOut.rgb, texture2D(TextureOut, TexCoordOut).a);
	gl_FragColor.a *= OpasityOut;
}