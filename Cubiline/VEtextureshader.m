#import "VEtextureshader.h"

@interface VETextureShader()
{
	enum
	{
		UNIFORM_MODELVIEWPROJECTION_MATRIX,
		UNIFORM_TEXTURE,
		UNIFORM_COLOR,
		UNIFORM_TEXTURE_COMPRESSION,
		UNIFORM_OPASITY,
		NUM_UNIFORMS
	};
	GLint uniforms[NUM_UNIFORMS];
}

- (void)SetUpSahder;

@end

@implementation VETextureShader

- (id)init
{
	self = [super initWithShaderName:@"texture_shader" BufferIn:VE_BUFFER_MODE_POSITION_TEXTURE];
	
	if(self)
	   [self SetUpSahder];
	
	return self;
	
}

- (void)Render:(GLKMatrix4*)mvpmatrix TextureID:(GLuint)textureid TextureCompression:(GLKVector3)texturecompression Color:(GLKVector3)color Opasity:(float)opasity
{
	glUseProgram(m_glProgram);
	
	// Set the Projection View Model Matrix to the shader.
	glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, mvpmatrix->m);
	
	// The color what we want to tint the image and the opasity.
	glUniform4fv(uniforms[UNIFORM_COLOR], 1, GLKVector4Make(color.r, color.g, color.b, 1.0f).v);
	glUniform1f(uniforms[UNIFORM_OPASITY], opasity);
	
	// Texture compression
	glUniform2f(uniforms[UNIFORM_TEXTURE_COMPRESSION], texturecompression.x, texturecompression.y);
	
	// Set one texture to render and the current texture to render.
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, textureid);
	glUniform1i(uniforms[UNIFORM_TEXTURE], 0);
}

- (void)SetUpSahder
{
	// Get uniform locations.
	uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(m_glProgram, "ModelViewProjectionMatrix");
	uniforms[UNIFORM_TEXTURE] = glGetUniformLocation(m_glProgram, "TextureOut");
	uniforms[UNIFORM_COLOR] = glGetUniformLocation(m_glProgram, "ColorOut");
	uniforms[UNIFORM_TEXTURE_COMPRESSION] = glGetUniformLocation(m_glProgram, "TextureCompressionIn");
	uniforms[UNIFORM_OPASITY] = glGetUniformLocation(m_glProgram, "OpasityOut");
}

@end
