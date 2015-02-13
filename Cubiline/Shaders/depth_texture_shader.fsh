varying lowp vec2 TexCoordOut;
uniform sampler2D TextureOut;

void main()
{
    gl_FragColor = texture2D(TextureOut, TexCoordOut);
}