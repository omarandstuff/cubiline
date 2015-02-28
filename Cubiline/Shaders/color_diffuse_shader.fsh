varying lowp vec3 PositionOut;
varying lowp vec3 NormalOut;

uniform int LightsNumber;

uniform lowp vec3 ColorOut;
uniform lowp float OpasityOut;

struct Light
{
    lowp vec3 position;
    lowp vec3 color;
    lowp float intensity;
    lowp float attenuation;
    lowp float ambientCoefficient;
    lowp float coneAngle;
    lowp vec3 ConeDirection;
};

uniform Light lights[10];

void main()
{
    highp vec3 surfaceToLight;
    highp vec4 colorLight;
    highp float diffuseCoefficient;
    highp vec4 perLightColor;
    highp vec4 finalColor = vec4(0.0, 0.0, 0.0, 1.0);
	
	// Color component.
	highp vec4 surfaceColor = vec4(ColorOut, 1.0);
    
    for(int i = 0; i < LightsNumber; i++)
    {
        // Light and texture color result;
        colorLight = surfaceColor * vec4(lights[i].color, 1.0) * lights[i].intensity;
        
        // Ambient.
        perLightColor = vec4(colorLight.rgb * lights[i].ambientCoefficient, 0.0);
        
        // Vector from surfice to light.
        surfaceToLight = normalize(lights[i].position - PositionOut);
        
        // Diffuse.
        diffuseCoefficient = max(0.0, dot(NormalOut, surfaceToLight));
        
        if(diffuseCoefficient == 0.0)
        {
            finalColor += perLightColor;
            continue;
        }
        
        // Add diffuce.
        perLightColor += vec4(colorLight.rgb * diffuseCoefficient, 0.0);
        
        finalColor += perLightColor;
    }
    
    gl_FragColor = finalColor * OpasityOut;
}
