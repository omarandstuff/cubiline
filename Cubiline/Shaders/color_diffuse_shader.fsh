uniform lowp float OpasityOut;
varying lowp vec3 finalColor;

void main()
{
	gl_FragColor = vec4(finalColor, OpasityOut);
}
