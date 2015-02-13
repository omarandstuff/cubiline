#import "VEcolorshader.h"

@interface VEColorShader()
{
	enum
	{
		UNIFORM_MODELVIEWPROJECTION_MATRIX,
		UNIFORM_COLOR,
		UNIFORM_OPASITY,
		NUM_UNIFORMS
	};
	GLint m_uniforms[NUM_UNIFORMS];
}

- (void)SetUpSahder;

@end

@implementation VEColorShader

- (id)init
{
	self = [super initWithShaderName:@"color_shader" BufferIn:VE_BUFFER_MODE_POSITION];
	
	if(self)
		[self SetUpSahder];
	
	return self;
	
}

- (void)Render:(GLKMatrix4*)mvpmatrix Color:(GLKVector3)color Opasity:(float)opasity;
{
	glUseProgram(m_glProgram);
	
	// Set the Projection View Model Matrix to the shader.
	glUniformMatrix4fv(m_uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, mvpmatrix->m);
	
	// Opasity and color.
	glUniform3fv(m_uniforms[UNIFORM_COLOR], 1, color.v);
	glUniform1f(m_uniforms[UNIFORM_OPASITY], opasity);
}

- (void)SetUpSahder
{
	// Get uniform locations.
	m_uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(m_glProgram, "ModelViewProjectionMatrix");
	m_uniforms[UNIFORM_COLOR] = glGetUniformLocation(m_glProgram, "ColorOut");
	m_uniforms[UNIFORM_OPASITY] = glGetUniformLocation(m_glProgram, "OpasityOut");
}

@end
