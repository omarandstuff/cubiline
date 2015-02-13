#import "VEdepthoffieldshader.h"

@interface VEDepthOfFieldShader()
{
    enum
    {
        UNIFORM_SOLID,
        UNIFORM_BLUR,
        UNIFORM_DEPTH,
        UNIFORM_FOCUS_DISTANCE,
        UNIFORM_FOCUS_RANGE,
        UNIFORM_NEAR,
        UNIFORM_FAR,
        NUM_UNIFORMS
    };
    GLint uniforms[NUM_UNIFORMS];
}

- (void)SetUpSahder;

@end

@implementation VEDepthOfFieldShader

- (id)init
{
    self = [super initWithShaderName:@"depth_of_field_shader" BufferIn:VE_BUFFER_MODE_POSITION_TEXTURE];
    
    if(self)
        [self SetUpSahder];
    
    return self;
    
}

- (void)RenderWithSolid:(GLuint)solidid Blur:(GLuint)blurid Depth:(GLuint)depthid FocusDistance:(float)focusdist FocusRange:(float)focusrange Near:(float)near Far:(float)far
{
    glUseProgram(m_glProgram);
    
    // Focus params.
    glUniform1f(uniforms[UNIFORM_FOCUS_DISTANCE], (1.0f / (far - near)) * (focusdist - near));
    glUniform1f(uniforms[UNIFORM_FOCUS_RANGE], focusrange);
    
    // The far and bear planes.
    glUniform1f(uniforms[UNIFORM_NEAR], near);
    glUniform1f(uniforms[UNIFORM_FAR], far);
    
    // Set the textures to render and the current texture to render.
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, solidid);
    glUniform1i(uniforms[UNIFORM_SOLID], 0);

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, blurid);
    glUniform1i(uniforms[UNIFORM_BLUR], 1);

    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, depthid);
    glUniform1i(uniforms[UNIFORM_DEPTH], 2);
}

- (void)SetUpSahder
{
    // Get uniform locations.
    uniforms[UNIFORM_SOLID] = glGetUniformLocation(m_glProgram, "SolidOut");
    uniforms[UNIFORM_BLUR] = glGetUniformLocation(m_glProgram, "BlurOut");
    uniforms[UNIFORM_DEPTH] = glGetUniformLocation(m_glProgram, "DepthOut");
    uniforms[UNIFORM_NEAR] = glGetUniformLocation(m_glProgram, "NearIn");
    uniforms[UNIFORM_FAR] = glGetUniformLocation(m_glProgram, "FarIn");
    uniforms[UNIFORM_FOCUS_DISTANCE] = glGetUniformLocation(m_glProgram, "FocusDistIn");
    uniforms[UNIFORM_FOCUS_RANGE] = glGetUniformLocation(m_glProgram, "FocusRangeIn");
}

@end
