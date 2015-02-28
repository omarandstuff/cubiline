#import "VEcolordiffuseshader.h"

@interface VEColorDiffuseShader()
{
	enum
	{
		UNIFORM_MODELVIEWPROJECTION_MATRIX,
		UNIFORM_MODEL_MATRIX,
		UNIFORM_NORMAL_MATRIX,
		UNIFORM_LIGHTS_NUM,
		UNIFORM_TEXTURE,
		UNIFORM_COLOR,
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

@implementation VEColorDiffuseShader

- (id)init
{
	self = [super initWithShaderName:@"color_diffuse_shader" BufferIn:VE_BUFFER_MODE_POSITION_NORMAL];
	
	if(self)
		[self SetUpSahder];
	
	return self;
	
}

- (void)Render:(GLKMatrix4*)mvpmatrix ModelMatrix:(GLKMatrix4*)modelmatrix NormalMatrix:(GLKMatrix3*)normalmatrix Lights:(NSMutableArray*)lights Color:(GLKVector3)color Opasity:(float)opasity;
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

	// Opasity and color.
	glUniform3fv(m_uniforms[UNIFORM_COLOR], 1, color.v);
	glUniform1f(m_uniforms[UNIFORM_OPASITY], opasity);
}

- (void)SetUpSahder
{
	// Get uniform locations.
	m_uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(m_glProgram, "ModelViewProjectionMatrix");
	m_uniforms[UNIFORM_MODEL_MATRIX] = glGetUniformLocation(m_glProgram, "ModelMatrix");
	m_uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(m_glProgram, "NormalMatrix");
	m_uniforms[UNIFORM_LIGHTS_NUM] = glGetUniformLocation(m_glProgram, "LightsNumber");
	m_uniforms[UNIFORM_TEXTURE] = glGetUniformLocation(m_glProgram, "TextureOut");
	m_uniforms[UNIFORM_COLOR] = glGetUniformLocation(m_glProgram, "ColorOut");
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
