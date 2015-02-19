#import "VEmodel.h"

@interface VEModel()
{
	VEModelBuffer* m_modelBuffer;
    
    GLKMatrix4 m_mvpMatrix;
    GLKMatrix3 m_normalMatrix;
}

@end

@implementation VEModel

@synthesize ModelBufferDispatcher;
@synthesize Camera;
@synthesize Lights;
@synthesize DisableLight;
@synthesize EnableNoise;
@synthesize EnableSpecular;

- (id)initWithFileName:(NSString *)filename
{
	self = [super init];
	
	if(self)
	{
        m_modelBuffer = [ModelBufferDispatcher GetModelBufferByFileName:filename];
		self.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
	}
	
	return self;
}

- (void)Frame:(float)time
{
    [super Frame:time];
    // Get the normal matrix
    m_normalMatrix = GLKMatrix4GetMatrix3(m_rotationMatrix);
    
}

- (void)Render:(enum VE_RENDER_MODE)rendermode;
{
    // Get the PVM Matrix.
    m_mvpMatrix = GLKMatrix4Multiply(Camera.ViewMatrix, m_finalMatrix);
    m_mvpMatrix = GLKMatrix4Multiply(Camera.ProjectionMatrix, m_mvpMatrix);
	
	if(rendermode == VE_RENDER_MODE_LIGHT && DisableLight)
		rendermode = VE_RENDER_MODE_TEXTURE;
	
	[m_modelBuffer Render:rendermode ModelViewProjectionMatrix:&m_mvpMatrix ModelMatrix:&m_finalMatrix NormalMatrix:&m_normalMatrix CameraPosition:Camera.Position Lights:Lights EnableSpecular:EnableSpecular EnableNoise:EnableNoise TextureCompression:m_textureCompression.Vector Color:m_color.Vector Opasity:m_opasity.Value];
}

- (void)dealloc
{
    [ModelBufferDispatcher ReleaseModelBuffer:m_modelBuffer];
}

@end
