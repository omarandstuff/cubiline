varying lowp vec4 PositionOut;
varying lowp vec3 NormalOut;
varying lowp vec2 TexCoordOut;

uniform lowp vec3 CameraPosition;
uniform int LightsNumber;

uniform lowp mat4 ModelMatrix;
uniform highp mat3 NormalMatrix;

uniform lowp float MaterialSpecular;
uniform lowp vec3 MaterialSpecularColor;
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

highp float rand(highp vec2 co)
{
	return fract(sin(dot(co ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
    highp float distanceToLight;
    highp vec3 surfaceToLight;
    highp vec4 colorLight;
    highp float diffuseCoefficient;
    highp vec4 perLightColor;
    highp vec4 finalColor = vec4(0.0);
	
    // Normal per fragment.
    highp vec3 normal = normalize(NormalMatrix * NormalOut);
    
    // Position per fragment.
    highp vec3 surfacePosition = (ModelMatrix * PositionOut).xyz;
	
	// Color of the texture by the color component.
	highp vec4 surfaceColor = vec4(ColorOut + clamp(rand(TexCoordOut), 0.0, 0.1), 1.0);
	
    // Vector from surfice to camera.
    highp vec3 surfaceToCamera = normalize(CameraPosition - surfacePosition);
    
    for(int i = 0; i < LightsNumber; i++)
    {
        // Distance from fragment to light.
        distanceToLight = length(lights[i].position - surfacePosition);
        
        // If it is out of range do nothing.
        if(distanceToLight >= lights[i].attenuation)
            continue;
        
        // Light and texture color result;
        colorLight = surfaceColor * vec4(lights[i].color, 1.0) * lights[i].intensity;
        
        // Ambient.
        perLightColor = vec4(colorLight.rgb * lights[i].ambientCoefficient, 0.0);
        
        // Vector from surfice to light.
        surfaceToLight = normalize(lights[i].position - surfacePosition);
        
        // Diffuse.
        diffuseCoefficient = max(0.0, dot(normal, surfaceToLight));
        
        if(diffuseCoefficient == 0.0)
        {
            finalColor += perLightColor;
            continue;
        }
        
        // Add diffuce.
        perLightColor += vec4(colorLight.rgb * diffuseCoefficient, 0.0);
        
        // Specular.
        perLightColor += pow(max(0.0, dot(surfaceToCamera, reflect(-surfaceToLight, normal))), MaterialSpecular) * vec4(MaterialSpecularColor * lights[i].color, 0.5);
		
		// Atenuation.
		perLightColor *= 1.0 - distanceToLight / lights[i].attenuation;
        
        finalColor += perLightColor;
    }
    finalColor.a += surfaceColor.a;
    
    gl_FragColor = finalColor * OpasityOut;
}