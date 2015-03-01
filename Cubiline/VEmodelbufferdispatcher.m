#import "VEmodelbufferdispatcher.h"

@implementation BufferHolder
@end

@interface VEModelDispatcher()
{
    NSMutableDictionary* m_modelBuffers;
}
@end

@implementation VEModelDispatcher

@synthesize TextureDispatcher;
@synthesize LightShader;
@synthesize ColorLightShader;
@synthesize ColorShader;
@synthesize VertexLightShader;
@synthesize VertexColorLightShader;
@synthesize DiffuseShader;
@synthesize ColorDiffuseShader;
@synthesize DepthShader;
@synthesize TextureShader;

- (id)init
{
    self = [super init];
    
    if(self)
    {
        m_modelBuffers = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (VEModelBuffer*)GetModelBufferByFileName:(NSString*)filename
{
    BufferHolder* currentBuffer = [m_modelBuffers objectForKey:filename];
    if(currentBuffer)
    {
        currentBuffer.Active++;
        return currentBuffer.ModelBuffer;
    }
    
    currentBuffer = [[BufferHolder alloc] init];
    currentBuffer.Active = 1;
    currentBuffer.ModelBuffer = [VEModelBuffer alloc];
    currentBuffer.ModelBuffer.TextureDispatcher = TextureDispatcher;
    currentBuffer.ModelBuffer.LightShader = LightShader;
    currentBuffer.ModelBuffer.ColorLightSahder = ColorLightShader;
	currentBuffer.ModelBuffer.ColorShader = ColorShader;
	currentBuffer.ModelBuffer.VertexLightShader = VertexLightShader;
	currentBuffer.ModelBuffer.VertexColorLightShader = VertexColorLightShader;
	currentBuffer.ModelBuffer.DiffuseShader = DiffuseShader;
	currentBuffer.ModelBuffer.ColorDiffuseShader = ColorDiffuseShader;
    currentBuffer.ModelBuffer.DepthShader = DepthShader;
    currentBuffer.ModelBuffer.TextureShader = TextureShader;
    currentBuffer.ModelBuffer = [currentBuffer.ModelBuffer initWithFileName:filename];
    
    [m_modelBuffers setObject:currentBuffer forKey:filename];
    
    return currentBuffer.ModelBuffer;
}

- (void)ReleaseModelBuffer:(VEModelBuffer*)modelbuffer
{
    BufferHolder* currentBuffer = [m_modelBuffers objectForKey:modelbuffer.FileName];
    
    if(currentBuffer)
    {
        if(currentBuffer.Active == 1)
            [m_modelBuffers removeObjectForKey:currentBuffer.ModelBuffer.FileName];
        else
            currentBuffer.Active--;
    }
}

@end
