#import "VEfullscreenshader.h"

@interface VEFullScreenShader()
{
    enum
    {
        UNIFORM_TEXTURE,
        NUM_UNIFORMS
    };
    GLint uniforms[NUM_UNIFORMS];
}

- (void)SetUpSahder;

@end

@implementation VEFullScreenShader

- (id)init
{
    self = [super initWithShaderName:@"fullscreen_shader" BufferIn:VE_BUFFER_MODE_POSITION_TEXTURE];
    
    if(self)
        [self SetUpSahder];
    
    return self;
    
}

- (void)Render:(GLuint)textureid
{
    glUseProgram(m_glProgram);
    
    // Set one texture to render and the current texture to render.
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureid);
    glUniform1i(uniforms[UNIFORM_TEXTURE], 0);
}

- (void)SetUpSahder
{
    // Get uniform locations.
    uniforms[UNIFORM_TEXTURE] = glGetUniformLocation(m_glProgram, "TextureOut");
}

@end
