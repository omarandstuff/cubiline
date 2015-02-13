uniform lowp vec3 ColorOut;
uniform lowp float OpasityOut;

void main()
{
    // Color of the texture by the color component.
    gl_FragColor = vec4(ColorOut, OpasityOut);
}