attribute vec4 PositionIn;
attribute vec2 TexCoordIn;
attribute vec3 NormalIn;

uniform mat4 ModelViewProjectionMatrix;
uniform mat3 NormalMatrix;
uniform mat4 ModelMatrix;

uniform int LightsNumber;

struct Light
{
	vec3 position;
	vec3 color;
	float intensity;
	float attenuation;
	float ambientCoefficient;
	float coneAngle;
	vec3 ConeDirection;
};

uniform Light lights[10];

varying lowp vec3 finalColor = vec3(0.0);
varying vec2 TexCoordOut;

void main()
{
	vec3 position  = (ModelMatrix * PositionIn).xyz;
	vec3 normal = normalize(NormalMatrix * NormalIn);
	vec3 perLightColor;
	vec3 colorLight;
	
	for(int i = 0; i < LightsNumber; i++)
	{
		// Light color;
		colorLight = vec3(lights[i].color) * lights[i].intensity;
		
		// Ambient.
		perLightColor = colorLight * lights[i].ambientCoefficient;
		
		// Diffuse.
		perLightColor += colorLight * max(0.0, dot(normal, normalize(lights[i].position - position)));
		
		finalColor += perLightColor;
	}
	
	gl_Position = ModelViewProjectionMatrix * PositionIn;
	TexCoordOut = TexCoordIn;
}
