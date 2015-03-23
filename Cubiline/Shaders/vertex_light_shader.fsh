uniform lowp float OpasityOut;
uniform lowp vec4 ColorOut;
uniform sampler2D TextureOut;
varying lowp vec2 TexCoordOut;
varying lowp vec3 finalColor;

void main()
{
	//lowp vec4 textureColor = texture2D(TextureOut, TexCoordOut) * ColorOut;
	lowp vec4 textureColor = ColorOut;
	gl_FragColor = vec4(textureColor.rgb * finalColor, textureColor.a * OpasityOut);
}
