attribute vec4 PositionIn;
attribute vec2 TexCoordIn;
attribute vec3 NormalIn;

uniform vec2 TextureCompressionIn;

uniform mat4 ModelViewProjectionMatrix;
uniform mat3 NormalMatrix;
uniform mat4 ModelMatrix;

uniform lowp float MaterialSpecular;
uniform lowp vec3 MaterialSpecularColor;

uniform lowp vec3 CameraPosition;
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
	
	vec3 surfaceToLight;
	vec3 surfaceToCamera = normalize(CameraPosition - position);
	
	for(int i = 0; i < LightsNumber; i++)
	{
		// Light color;
		colorLight = vec3(lights[i].color) * lights[i].intensity;
		
		// Ambient.
		perLightColor = colorLight * lights[i].ambientCoefficient;
		
		surfaceToLight = normalize(lights[i].position - position);
		
		// Diffuse.
		perLightColor += colorLight * max(0.0, dot(normal, surfaceToLight));
		
		// Specular.
		perLightColor += pow(max(0.0, dot(surfaceToCamera, reflect(-surfaceToLight, normal))), MaterialSpecular) * vec3(MaterialSpecularColor * lights[i].color);
		
		finalColor += perLightColor;
	}
	
	gl_Position = ModelViewProjectionMatrix * PositionIn;
	TexCoordOut = TexCoordIn * TextureCompressionIn;
}
