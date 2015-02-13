#import "VEgaussianblurshader.h"

@interface VEGaussianBlurShader()
{
    enum
    {
        UNIFORM_TEXTURE,
        UNIFORM_STEP,
        UNIFORM_RADIOUS,
        UNIFORM_VHOPTION,
        NUM_UNIFORMS
    };
    GLint uniforms[NUM_UNIFORMS];
}

- (void)SetUpSahder;

@end

@implementation VEGaussianBlurShader

- (id)init
{
    self = [super initWithShaderName:@"gaussian_blur_shader" BufferIn:VE_BUFFER_MODE_POSITION_TEXTURE];
    
    if(self)
        [self SetUpSahder];
    
    return self;
    
}

- (void)RenderWithTexture:(GLuint)textureid TextureStep:(float)step BlurRadious:(float)radious VHOption:(bool)vhoption
{
    glUseProgram(m_glProgram);
    
    // The radious, texture step and option for vertial or horizontal
    glUniform1f(uniforms[UNIFORM_STEP], step);
    glUniform1f(uniforms[UNIFORM_RADIOUS], radious);
    glUniform1i(uniforms[UNIFORM_VHOPTION], vhoption);
    
    // Set one texture to render and the current texture to render.
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureid);
    glUniform1i(uniforms[UNIFORM_TEXTURE], 0);
}

- (void)SetUpSahder
{
    // Get uniform locations.
    uniforms[UNIFORM_TEXTURE] = glGetUniformLocation(m_glProgram, "TextureOut");
    uniforms[UNIFORM_STEP] = glGetUniformLocation(m_glProgram, "Step");
    uniforms[UNIFORM_RADIOUS] = glGetUniformLocation(m_glProgram, "Radious");
    uniforms[UNIFORM_VHOPTION] = glGetUniformLocation(m_glProgram, "VHOption");
}

@end
