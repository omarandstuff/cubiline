varying lowp vec2 TexCoordOut;
uniform sampler2D TextureOut;
uniform lowp vec4 ColorOut;
uniform lowp float OpasityOut;

void main()
{
    gl_FragColor = texture2D(TextureOut, TexCoordOut) * ColorOut;
    gl_FragColor.a *= OpasityOut;
}