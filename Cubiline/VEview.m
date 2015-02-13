#import "VEview.h"

@interface VEView()
{
    enum VE_VIEW_TYPE m_viewType;
    GLKView* m_GLKView;
    
    GLKMatrix4 m_default2DMatrix;
    GLKMatrix4 m_default2DViewMatrix;
    
    GLuint m_fullScreenVertexBufferId;
    GLuint m_fullScreenVertexArrayId;
    
    VEFBO* m_solid;
    VEFBO* m_firstPassBlur;
    VEFBO* m_secondPassBlur;
    VEFBO* m_depthOfFiled;
    
    int m_blurQuality;
}

- (void)ReleaseView;
- (void)SetUpBuffers;
- (void)CreateFullScreen;
- (void)RenderFullScreen;

@end

@implementation VEView

@synthesize FullScreenShader;
@synthesize GaussianBlurShader;
@synthesize DepthOfFieldShader;
@synthesize Camera;
@synthesize Color;
@synthesize Depth;
@synthesize Width;
@synthesize Height;
@synthesize EnableLight;
@synthesize ClearColor;
@synthesize Scene;
@synthesize Fader;

- (id)initAs:(enum VE_VIEW_TYPE)viewtype GLKView:(GLKView*)glkview Width:(GLint)width Height:(GLint)height
{
    self = [super init];
    
    if(self)
    {
        m_viewType = viewtype;
        m_GLKView = glkview;
        
        m_blurQuality = 2;
        
        Width = width;
        Height = height;
        
        [self ResizeWithWidth:width Height:height];
        [self CreateFullScreen];
    }
    
    return self;
}

- (void)Render
{
    // Render the solid color map.
    if(!Camera.DepthOfField && m_viewType == VE_VIEW_TYPE_DIRECT)
        [m_GLKView bindDrawable];
    else
        glBindFramebuffer(GL_FRAMEBUFFER, m_solid.FrameBufferID);
    
    // View settings.
    glViewport(0, 0, Width, Height);
    glClearColor(ClearColor.r, ClearColor.g, ClearColor.b, ClearColor.a);
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_CULL_FACE);
    glCullFace(GL_FRONT);
    glEnable(GL_DEPTH_TEST);
    
    [Scene.Models enumerateObjectsUsingBlock:^(VEModel* model, NSUInteger index, BOOL *stop)
     {
         model.Camera = Camera;
         model.Lights = Scene.Lights;
         
         if(EnableLight)
             [model Render:VE_RENDER_MODE_LIGHT];
         else
             [model Render:VE_RENDER_MODE_TEXTURE];
     }];
	
    if(Camera.DepthOfField)
    {
        // First pass blur.
        glViewport(0, 0, Width / m_blurQuality, Height / m_blurQuality);
        glBindFramebuffer(GL_FRAMEBUFFER, m_firstPassBlur.FrameBufferID);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        [GaussianBlurShader RenderWithTexture:m_solid.Color.TextureID TextureStep:1.0f / (float)Width BlurRadious:1.25f VHOption:true];
        
        [self RenderFullScreen];
        
        // Second pass blur.
        glViewport(0, 0, Width / m_blurQuality, Height / m_blurQuality);
        glBindFramebuffer(GL_FRAMEBUFFER, m_secondPassBlur.FrameBufferID);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        [GaussianBlurShader RenderWithTexture:m_firstPassBlur.Color.TextureID TextureStep:1.0f / (float)Width BlurRadious:1.25f VHOption:false];
        
        [self RenderFullScreen];
        
        // Depth of field.
        glViewport(0, 0, Width, Height);
        if(m_viewType == VE_VIEW_TYPE_DIRECT)
            [m_GLKView bindDrawable];
        else
            glBindFramebuffer(GL_FRAMEBUFFER, m_depthOfFiled.FrameBufferID);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        //[FullScreenShader Render:m_solid.Depth.TextureID];
        [DepthOfFieldShader RenderWithSolid:m_solid.Color.TextureID Blur:m_secondPassBlur.Color.TextureID Depth:m_solid.Depth.TextureID FocusDistance:Camera.FocusDistance FocusRange:Camera.FocusRange Near:Camera.Near Far:Camera.Far];
        
        [self RenderFullScreen];
        
        Color = m_depthOfFiled.Color;
    }
    else if (m_viewType == VE_VIEW_TYPE_TEXTURE)
        Color = m_solid.Color;
	
	if(m_viewType == VE_VIEW_TYPE_DIRECT)
		[m_GLKView bindDrawable];
	else
		glBindFramebuffer(GL_FRAMEBUFFER, m_solid.FrameBufferID);
	
	glDisable(GL_CULL_FACE);
	glDisable(GL_DEPTH_TEST);
	
	[Scene.Elements2D enumerateObjectsUsingBlock:^(SceneElement* element, NSUInteger index, BOOL *stop)
	 {
		 if([element.Kind isEqualToString:@"Sp"])
		 {
			 VESprite* toRender = element.Element;
			 
			 toRender.ViewMatrix = &m_default2DViewMatrix;
			 toRender.ProjectionMatrix = &m_default2DMatrix;
			 
			 [toRender Render];
		 }
		 else
		 {
			 VEText* toRender = element.Element;
			 
			 toRender.ViewMatrix = &m_default2DViewMatrix;
			 toRender.ProjectionMatrix = &m_default2DMatrix;
			 
			 [toRender Render];
		 }
		
	 }];
	
	[Fader Render];
}

- (void)ResizeWithWidth:(GLint)width Height:(GLint)height
{
    Width = width;
    Height = height;
    
    // Dafault 2Dmatrix;
    m_default2DViewMatrix = GLKMatrix4Identity;
    float sw2 = (float)Width / 2.0f;
    float sh2 = (float)Height / 2.0f;
    m_default2DMatrix = GLKMatrix4MakeOrtho(-sw2, sw2, -sh2, sh2, -10.0f, 10.0f);
    
    if(Camera) Camera.Aspect = (float)Width / (float)Height;
    
    [self SetUpBuffers];
}

- (void)SetUpBuffers
{
    // First pass.
    if(!m_solid)
        m_solid = [[VEFBO alloc] initAs:VE_FBO_TYPE_BOTH Width:Width Height:Height];
    else
        [m_solid ResizeWithWidth:Width Height:Height];
    
    // Fisrt pass blur.
    if(!m_firstPassBlur)
        m_firstPassBlur = [[VEFBO alloc] initAs:VE_FBO_TYPE_COLOR Width:Width / m_blurQuality Height:Height / m_blurQuality];
    else
        [m_firstPassBlur ResizeWithWidth:Width / m_blurQuality Height:Height / m_blurQuality];
    
    // Second pass blur.
    if(!m_secondPassBlur)
        m_secondPassBlur = [[VEFBO alloc] initAs:VE_FBO_TYPE_COLOR Width:Width / m_blurQuality Height:Height / m_blurQuality];
    else
        [m_secondPassBlur ResizeWithWidth:Width / m_blurQuality Height:Height / m_blurQuality];
    
    // Depth of field.
    if(!m_depthOfFiled)
        m_depthOfFiled = [[VEFBO alloc] initAs:VE_FBO_TYPE_COLOR Width:Width Height:Height];
    else
        [m_depthOfFiled ResizeWithWidth:Width Height:Height];
	
	Color = m_solid.Color;
}

- (void)CreateFullScreen
{
    GLfloat vertices[30] =
    {
        -1.0f, -1.0f, 0.0f,		0.0f, 0.0f,
        -1.0f,  1.0f, 0.0f,		0.0f, 1.0f,
         1.0f, -1.0f, 0.0f,		1.0f, 0.0f,
        -1.0f,  1.0f, 0.0f,		0.0f, 1.0f,
         1.0f,  1.0f, 0.0f,		1.0f, 1.0f,
         1.0f, -1.0f, 0.0f,		1.0f, 0.0f
    };
    
    
    glGenVertexArraysOES(1, &m_fullScreenVertexArrayId);
    glBindVertexArrayOES(m_fullScreenVertexArrayId);
    
    glGenBuffers(1, &m_fullScreenVertexBufferId);
    glBindBuffer(GL_ARRAY_BUFFER, m_fullScreenVertexBufferId);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 5, 0);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 5, (unsigned char*)NULL + (3 * sizeof(float)));
    
    glBindVertexArrayOES(0);
}

- (void)RenderFullScreen
{
    // Bind the vertex array object that stored all the information about the vertex and index buffers.
    glBindVertexArrayOES(m_fullScreenVertexArrayId);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glDisableVertexAttribArray(GLKVertexAttribNormal);
    
    // Draw call.
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void)setCamera:(VECamera*)camera
{
    Camera = camera;
	Camera.ViewWidth = Width;
	Camera.ViewHeigt = Height;
    Camera.Aspect = (float)Width / (float)Height;
}

- (VECamera*)Camera
{
    return Camera;
}

- (void)setFader:(VESprite *)fader
{
	Fader =fader;
	Fader.ViewMatrix = &m_default2DViewMatrix;
	Fader.ProjectionMatrix = &m_default2DMatrix;
}

- (VESprite*)Fader
{
	return Fader;
}

- (void)ReleaseView
{
    // Release the vertex buffer.
    if (m_fullScreenVertexBufferId)
    {
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glDeleteBuffers(1, &m_fullScreenVertexBufferId);
    }
    
    // Release the VertexArray.
    if(m_fullScreenVertexArrayId)
    {
        glBindVertexArrayOES(0);
        glDeleteVertexArraysOES(1, &m_fullScreenVertexArrayId);
    }
}

- (void)dealloc
{
    [self ReleaseView];
}

@end
