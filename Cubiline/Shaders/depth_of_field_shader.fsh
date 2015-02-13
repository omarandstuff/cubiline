uniform sampler2D SolidOut;
uniform sampler2D BlurOut;
uniform sampler2D DepthOut;
uniform mediump float FocusDistIn;
uniform mediump float FocusRangeIn;

varying mediump vec2 TexCoordOut;
varying highp float NearOut;
varying highp float NearFar2Out;
varying highp float NearPlusFarOut;
varying highp float FarMinusNearOut;
varying highp float normalizedDistance;

void main()
{
    highp vec3 solidColor = texture2D(SolidOut, TexCoordOut).rgb;
    highp vec3 blurColor = texture2D(BlurOut, TexCoordOut).rgb;
	highp float z = texture2D(DepthOut, TexCoordOut).r;
    highp float depthDist =  NearFar2Out / (NearPlusFarOut - (z * 2.0 - 1.0) * FarMinusNearOut);
	depthDist = normalizedDistance * (depthDist - NearOut);
    depthDist = clamp(FocusRangeIn * abs(depthDist - FocusDistIn), 0.0, 1.0);

    gl_FragColor = vec4(mix(solidColor, blurColor, depthDist), 1.0);
}