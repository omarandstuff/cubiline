#import "VEfbo.h"

@interface VEFBO()
{
    GLuint m_renderBufferForDepth;
    
    enum VE_FBO_TYPE m_FBOType;
}

- (void)ReleaseFBO;
- (void)SetUpBuffers;

@end

@implementation VEFBO

@synthesize FrameBufferID;
@synthesize Color;
@synthesize Depth;
@synthesize Width;
@synthesize Height;

- (id)initAs:(enum VE_FBO_TYPE)fbotype Width:(int)width Height:(int)height
{
    self = [super init];
    
    if(self)
    {
        m_FBOType = fbotype;
        Width = width;
        Height = height;
        [self SetUpBuffers];
    }
    
    return self;
}

- (void)ResizeWithWidth:(int)width Height:(int)height
{
	if(width == Width && Height == height) return;
    Width = width;
    Height = height;
    [self SetUpBuffers];
}

- (void)SetUpBuffers
{
    // Bind nothing;
    Color = nil;
    Depth = nil;
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    
    // Reset buffer if it is the case.
    if(FrameBufferID)
        glDeleteFramebuffers(1, &FrameBufferID);
    if(m_renderBufferForDepth)
        glDeleteRenderbuffers(1, &m_renderBufferForDepth);
    
    if(m_FBOType == VE_FBO_TYPE_COLOR)
    {
        Color = [[VETexture alloc] initForBufferType:GL_COLOR_ATTACHMENT0 Width:Width Height:Height];
        
        // Generate the frame buffer.
        glGenFramebuffers(1, &FrameBufferID);
        
        // Bind that frame buffer.
        glBindFramebuffer(GL_FRAMEBUFFER, FrameBufferID);
        
        //Attach 2D texture to this FBO
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, Color.TextureID, 0);
    }
    
    if(m_FBOType == VE_FBO_TYPE_COLOR_DEPTH_TEST)
    {
        Color = [[VETexture alloc] initForBufferType:GL_COLOR_ATTACHMENT0 Width:Width Height:Height];
        
        // Generate the depth render buffer.
        glGenRenderbuffers(1, &m_renderBufferForDepth);
        
        // Bind that render buffer.
        glBindRenderbuffer(GL_RENDERBUFFER, m_renderBufferForDepth);
        
        // Allocate the data for depth storage.
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, Width, Height);
        
        // Generate the frame buffer.
        glGenFramebuffers(1, &FrameBufferID);
        
        // Bind that frame buffer.
        glBindFramebuffer(GL_FRAMEBUFFER, FrameBufferID);
        
        //Attach 2D texture to this FBO
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, Color.TextureID, 0);
        
        // Attach depth buffer to FBO
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, m_renderBufferForDepth);
    }
    
    if(m_FBOType == VE_FBO_TYPE_DEPTH)
    {
        Depth = [[VETexture alloc] initForBufferType:GL_DEPTH_ATTACHMENT Width:Width Height:Height];
        
        // Generate the frame buffer.
        glGenFramebuffers(1, &FrameBufferID);
        
        // Bind that frame buffer.
        glBindFramebuffer(GL_FRAMEBUFFER, FrameBufferID);
        
        //Attach 2D texture to this FBO
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, Depth.TextureID, 0);
    }
    
    if(m_FBOType == VE_FBO_TYPE_BOTH)
    {
        Color = [[VETexture alloc] initForBufferType:GL_COLOR_ATTACHMENT0 Width:Width Height:Height];
        Depth = [[VETexture alloc] initForBufferType:GL_DEPTH_ATTACHMENT Width:Width Height:Height];
        
        // Generate the frame buffer.
        glGenFramebuffers(1, &FrameBufferID);
        
        // Bind that frame buffer.
        glBindFramebuffer(GL_FRAMEBUFFER, FrameBufferID);
        
        //Attach 2D texture to this FBO
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, Color.TextureID, 0);
        
        //Attach 2D texture to this FBO
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, Depth.TextureID, 0);
    }
    
    // Check for completness.
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(status != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"The Framebuffer was not completed.");
    
}

- (void)ReleaseFBO
{
    // Bind nothing;
    Color = nil;
    Depth = nil;
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    
    // Delete frame buffer and render buffer.
    if(FrameBufferID)
        glDeleteFramebuffers(1, &FrameBufferID);
    if(m_renderBufferForDepth)
        glDeleteRenderbuffers(1, &m_renderBufferForDepth);
}

- (void)dealloc
{
    [self ReleaseFBO];
}

@end
