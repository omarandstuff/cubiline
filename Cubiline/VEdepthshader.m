#import "VEdepthshader.h"

@interface VEDepthShader()
{
    enum
    {
        UNIFORM_MODELVIEWPROJECTION_MATRIX,
        NUM_UNIFORMS
    };
    GLint uniforms[NUM_UNIFORMS];
}

- (void)SetUpSahder;

@end

@implementation VEDepthShader

- (id)init
{
    self = [super initWithShaderName:@"depth_shader" BufferIn:VE_BUFFER_MODE_POSITION];
    
    if(self)
        [self SetUpSahder];
    
    return self;
    
}

- (void)Render:(GLKMatrix4*)mvpmatrix
{
    glUseProgram(m_glProgram);
    
    // Set the Projection View Model Matrix to the shader.
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, mvpmatrix->m);
}

- (void)SetUpSahder
{
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(m_glProgram, "ModelViewProjectionMatrix");
}

@end
