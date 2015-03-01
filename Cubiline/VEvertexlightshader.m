#import "VEvertexlightshader.h"

@interface VEVertexLightShader()
{
	enum
	{
		UNIFORM_MODELVIEWPROJECTION_MATRIX,
		UNIFORM_MODEL_MATRIX,
		UNIFORM_NORMAL_MATRIX,
		UNIFORM_CAMERA_POSITION,
		UNIFORM_LIGHTS_NUM,
		UNIFORM_TEXTURE,
		UNIFORM_MATERIAL_SPECULAR,
		UNIFORM_MATERIAL_SPECULAR_COLOR,
		UNIFORM_OPASITY,
		UNIFORM_TEXTURE_COMPRESSION,
		NUM_UNIFORMS
	};
	enum
	{
		UNIFORM_LIGHT_POSITION,
		UNIFORM_LIGHT_COLOR,
		UNIFORM_LIGHT_INTENSITY,
		UNIFORM_LIGHT_ATTENUATION,
		UNIFORM_LIGHT_AMBIENT_COEFFICIENT,
		UNIFORM_LIGHT_CONE_ANGLE,
		UNIFORM_LIGHT_CONE_DIRECTION,
		NUM_LIGHT_UNIFORMS
	};
	GLint m_uniforms[NUM_UNIFORMS];
	GLint m_lightUniforms[10][NUM_LIGHT_UNIFORMS];
}

- (void)SetUpSahder;

@end

@implementation VEVertexLightShader

- (id)init
{
	self = [super initWithShaderName:@"vertex_light_shader" BufferIn:VE_BUFFER_MODE_ALL];
	
	if(self)
		[self SetUpSahder];
	
	return self;
	
}

- (void)Render:(GLKMatrix4*)mvpmatrix ModelMatrix:(GLKMatrix4*)modelmatrix NormalMatrix:(GLKMatrix3*)normalmatrix CameraPosition:(GLKVector3)position Lights:(NSMutableArray*)lights TextureID:(GLuint)textureid TextureCompression:(GLKVector3)texturecompression MaterialSpecular:(float)specular MaterialSpecularColor:(GLKVector3)specularcolor MaterialGlossiness:(float)glossiness Opasity:(float)opasity
{
	glUseProgram(m_glProgram);
	
	// Lights
	[lights enumerateObjectsUsingBlock:^(VELight* light, NSUInteger index, BOOL *stop)
	 {
		 glUniform3fv(m_lightUniforms[index][UNIFORM_LIGHT_POSITION], 1, light.Position.v);
		 glUniform3fv(m_lightUniforms[index][UNIFORM_LIGHT_COLOR], 1, light.Color.v);
		 glUniform1f(m_lightUniforms[index][UNIFORM_LIGHT_INTENSITY], light.Intensity);
		 glUniform1f(m_lightUniforms[index][UNIFORM_LIGHT_ATTENUATION], light.AttenuationDistance);
		 glUniform1f(m_lightUniforms[index][UNIFORM_LIGHT_AMBIENT_COEFFICIENT], light.AmbientCoefficient);
		 glUniform1f(m_lightUniforms[index][UNIFORM_LIGHT_CONE_ANGLE], 0.0f);
		 glUniform3fv(m_lightUniforms[index][UNIFORM_LIGHT_CONE_DIRECTION], 1, light.Position.v);
	 }];
	
	// Lights number.
	glUniform1i(m_uniforms[UNIFORM_LIGHTS_NUM], (GLint)[lights count]);
	
	// Set the Projection View Model Matrix to the shader.
	glUniformMatrix4fv(m_uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, mvpmatrix->m);
	glUniformMatrix4fv(m_uniforms[UNIFORM_MODEL_MATRIX], 1, 0, modelmatrix->m);
	glUniformMatrix3fv(m_uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalmatrix->m);
	glUniform3fv(m_uniforms[UNIFORM_CAMERA_POSITION], 1, position.v);
	
	// Opasity.
	glUniform1f(m_uniforms[UNIFORM_OPASITY], opasity);
	
	// Testure compression.
	glUniform2f(m_uniforms[UNIFORM_TEXTURE_COMPRESSION], texturecompression.x, texturecompression.y);
	
	// Material
	glUniform1f(m_uniforms[UNIFORM_MATERIAL_SPECULAR], specular);
	glUniform3fv(m_uniforms[UNIFORM_MATERIAL_SPECULAR_COLOR], 1, GLKVector3MultiplyScalar(specularcolor, glossiness).v);
	
	// Set one texture to render and the current texture to render.
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, textureid);
	glUniform1i(m_uniforms[UNIFORM_TEXTURE], 0);
}

- (void)SetUpSahder
{
	// Get uniform locations.
	m_uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(m_glProgram, "ModelViewProjectionMatrix");
	m_uniforms[UNIFORM_MODEL_MATRIX] = glGetUniformLocation(m_glProgram, "ModelMatrix");
	m_uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(m_glProgram, "NormalMatrix");
	m_uniforms[UNIFORM_CAMERA_POSITION] = glGetUniformLocation(m_glProgram, "CameraPosition");
	m_uniforms[UNIFORM_LIGHTS_NUM] = glGetUniformLocation(m_glProgram, "LightsNumber");
	m_uniforms[UNIFORM_TEXTURE] = glGetUniformLocation(m_glProgram, "TextureOut");
	m_uniforms[UNIFORM_MATERIAL_SPECULAR] = glGetUniformLocation(m_glProgram, "MaterialSpecular");
	m_uniforms[UNIFORM_MATERIAL_SPECULAR_COLOR] = glGetUniformLocation(m_glProgram, "MaterialSpecularColor");
	m_uniforms[UNIFORM_OPASITY] = glGetUniformLocation(m_glProgram, "OpasityOut");
	m_uniforms[UNIFORM_TEXTURE_COMPRESSION] = glGetUniformLocation(m_glProgram, "TextureCompressionIn");
	
	for(int i = 0; i < 10; i++)
	{
		m_lightUniforms[i][UNIFORM_LIGHT_POSITION] = glGetUniformLocation(m_glProgram, [[NSString stringWithFormat:@"%@%@%@", @"lights[", [@(i) stringValue], @"].position"] UTF8String]);
		m_lightUniforms[i][UNIFORM_LIGHT_COLOR] = glGetUniformLocation(m_glProgram, [[NSString stringWithFormat:@"%@%@%@", @"lights[", [@(i) stringValue], @"].color"] UTF8String]);
		m_lightUniforms[i][UNIFORM_LIGHT_INTENSITY] = glGetUniformLocation(m_glProgram, [[NSString stringWithFormat:@"%@%@%@", @"lights[", [@(i) stringValue], @"].intensity"] UTF8String]);
		m_lightUniforms[i][UNIFORM_LIGHT_ATTENUATION] = glGetUniformLocation(m_glProgram, [[NSString stringWithFormat:@"%@%@%@", @"lights[", [@(i) stringValue], @"].attenuation"] UTF8String]);
		m_lightUniforms[i][UNIFORM_LIGHT_AMBIENT_COEFFICIENT] = glGetUniformLocation(m_glProgram, [[NSString stringWithFormat:@"%@%@%@", @"lights[", [@(i) stringValue], @"].ambientCoefficient"] UTF8String]);
		m_lightUniforms[i][UNIFORM_LIGHT_CONE_ANGLE] = glGetUniformLocation(m_glProgram, [[NSString stringWithFormat:@"%@%@%@", @"lights[", [@(i) stringValue], @"].coneAngle"] UTF8String]);
		m_lightUniforms[i][UNIFORM_LIGHT_CONE_DIRECTION] = glGetUniformLocation(m_glProgram, [[NSString stringWithFormat:@"%@%@%@", @"lights[", [@(i) stringValue], @"].ConeDirection"] UTF8String]);
	}
}

@end
