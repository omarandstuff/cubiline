uniform lowp float OpasityOut;
uniform lowp vec4 ColorOut;
uniform sampler2D TextureOut;
varying lowp vec2 TexCoordOut;
varying lowp vec4 finalColor;

void main()
{
	lowp vec4 textureColor = texture2D(TextureOut, TexCoordOut) * ColorOut;
	gl_FragColor = vec4(textureColor.rgb * finalColor.rgb, finalColor.a * textureColor.a * OpasityOut);
}
