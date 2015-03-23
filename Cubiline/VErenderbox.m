#import "VErenderbox.h"

@interface VERenderBox()
{
	VETextureShader* m_textureShader;
    VELightShader* m_lightShader;
    VEColorLightShader* m_colorLightShader;
	VEColorShader* m_colorShader;
	VEVertexLightShader* m_vertexLightShader;
	VEVertexColorLightShader* m_vertexColorLightShader;
	VEDiffuseShader* m_diffuseShader;
	VEColorDiffuseShader* m_colorDiffuseShader;
    VEDepthShader* m_depthShader;
    VEFullScreenShader* m_fullScreenShader;
    VEGaussianBlurShader* m_gaussianBlurShader;
    VEDepthOfFieldShader* m_depthOfFieldShader;
	VETextShader* m_textShader;
    VETextureDispatcher* m_textureDispatcher;
    VEModelDispatcher* m_modelBufferDispatcher;
    
    NSMutableArray* m_models;
    NSMutableArray* m_sprites;
    NSMutableArray* m_scenes;
    NSMutableArray* m_cameras;
    NSMutableArray* m_lights;
	NSMutableArray* m_texts;
	NSMutableArray* m_watches;
    
    EAGLContext* m_context;
    GLKView* m_GLKView;
}

- (void)SetUpRenderTools;

@end

@implementation VERenderBox

@synthesize MainView;
@synthesize ScreenWidth;
@synthesize ScreenHeight;
@synthesize Timer;
@synthesize MaxTextureSize;

- (id)initWithContext:(EAGLContext *)context GLKView:(GLKView*)glkview Timer:(VETimer*)timer Width:(int)width Height:(int)height
{
	self = [super init];
	
	if(self)
	{
		m_textureShader = nil;
		m_textureDispatcher = nil;
        
        ScreenWidth = width;
        ScreenHeight = height;
        
        m_context = context;
        m_GLKView = glkview;
		Timer = timer;
		
		[self SetUpRenderTools];
	}
	
	return self;
}

- (void)Frame:(float)time
{
    // Frame for every active camera.
    for(VECamera* camera in m_cameras)
    {
        [camera Frame:time];
    }
    
    // Frame for every active model.
    for(VEModel* model in m_models)
    {
        [model Frame:time];
    }
    
    // Frame for every active sprite.
    for(VESprite* sprite in m_sprites)
    {
        [sprite Frame:time];
    }
	
	// Frame for every active Text.
	for(VEText* text in m_texts)
	{
		[text Frame:time];
	}
	
    // Frame for every light.
    for(VELight* light in m_lights)
    {
        [light Frame:time];
    }
    
    // Frame for every scene.
    for(VEScene* scene in m_scenes)
    {
        [scene Frame:time];
    }
	
	// Frame for every watch.
	for(VEWatch* watch in m_watches)
	{
		[watch Frame:time];
	}
}

- (void)Render
{
    [MainView Render];
}

- (void)Resize
{
    [MainView ResizeWithWidth:ScreenWidth Height:ScreenHeight];
}

- (void)SetUpRenderTools
{
    // Context
    [EAGLContext setCurrentContext:m_context];
    
    // OpenGl setup.
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glGetIntegerv(GL_MAX_TEXTURE_SIZE, &MaxTextureSize);
	//glBlendEquation(GL_FUNC_ADD);
    
	// Create the shader objects.
	m_textureShader = [[VETextureShader alloc] init];
    m_lightShader = [[VELightShader alloc] init];
    m_colorLightShader = [[VEColorLightShader alloc] init];
	m_colorShader = [[VEColorShader alloc] init];
	m_vertexLightShader = [[VEVertexLightShader alloc] init];
	m_vertexColorLightShader = [[VEVertexColorLightShader alloc] init];
	m_diffuseShader = [[VEDiffuseShader alloc] init];
	m_colorDiffuseShader = [[VEColorDiffuseShader alloc] init];
    m_depthShader = [[VEDepthShader alloc] init];
    m_fullScreenShader = [[VEFullScreenShader alloc] init];
    m_gaussianBlurShader = [[VEGaussianBlurShader alloc] init];
    m_depthOfFieldShader = [[VEDepthOfFieldShader alloc] init];
	m_textShader = [[VETextShader alloc] init];
    
	// Create the texture dispatcher object.
	m_textureDispatcher = [[VETextureDispatcher alloc] init];
    
    // Create the model buffer dispatcher object.
    m_modelBufferDispatcher = [[VEModelDispatcher alloc] init];
    m_modelBufferDispatcher.TextureDispatcher = m_textureDispatcher;
    m_modelBufferDispatcher.LightShader = m_lightShader;
    m_modelBufferDispatcher.ColorLightShader = m_colorLightShader;
	m_modelBufferDispatcher.ColorShader = m_colorShader;
	m_modelBufferDispatcher.DiffuseShader = m_diffuseShader;
	m_modelBufferDispatcher.ColorDiffuseShader = m_colorDiffuseShader;
    m_modelBufferDispatcher.DepthShader = m_depthShader;
    m_modelBufferDispatcher.TextureShader = m_textureShader;
	m_modelBufferDispatcher.VertexLightShader = m_vertexLightShader;
	m_modelBufferDispatcher.VertexColorLightShader = m_vertexColorLightShader;
    
    // Keep tracking.
    m_models = [[NSMutableArray alloc] init];
    m_sprites = [[NSMutableArray alloc] init];
    m_scenes = [[NSMutableArray alloc] init];
    m_cameras = [[NSMutableArray alloc] init];
    m_lights = [[NSMutableArray alloc] init];
    m_texts = [[NSMutableArray alloc] init];
	m_watches = [[NSMutableArray alloc] init];
	
    // Create the main view object
    MainView = [self NewViewAs:VE_VIEW_TYPE_DIRECT Width:ScreenWidth Height:ScreenHeight];
}

- (VESprite*)NewSpriteFromFileName:(NSString*)filename
{
	VESprite* newSprite = [VESprite alloc];
    
    // Set the properties for the sprite.
	newSprite.TextureShader = m_textureShader;
	newSprite.TextureDispatcher = m_textureDispatcher;
	newSprite.ColorShader = m_colorShader;
	
    // Initialize the sprite.
	newSprite = [newSprite initFromFileName:filename];
    
    // Keep tracking.
    [m_sprites addObject:newSprite];
	
	return newSprite;
}

- (VESprite*)NewSolidSpriteWithColor:(GLKVector3)color
{
	VESprite* newSprite = [VESprite alloc];
	
	// Set the properties for the sprite.
	newSprite.TextureShader = m_textureShader;
	newSprite.TextureDispatcher = m_textureDispatcher;
	newSprite.ColorShader = m_colorShader;
	
	// Initialize the sprite.
	newSprite = [newSprite init];
	newSprite.Color = color;
	
	// Keep tracking.
	[m_sprites addObject:newSprite];
	
	return newSprite;
}

- (VESprite*)NewSpriteFromTexture:(VETexture*)texture
{
    VESprite* newSprite = [VESprite alloc];
    
    // Set the properties for the sprite.
    newSprite.TextureShader = m_textureShader;
    newSprite.TextureDispatcher = m_textureDispatcher;
	newSprite.ColorShader = m_colorShader;
    
    // Initialize the sprite.
    newSprite = [newSprite initFromTexture:texture];
    
    // Keep tracking.
    [m_sprites addObject:newSprite];
    
    return newSprite;
}

- (VEModel*)NewModelFromFileName:(NSString*)filename
{
	VEModel* newModel = [VEModel alloc];
    
    // Set the properties for the model.
    newModel.ModelBufferDispatcher = m_modelBufferDispatcher;
    
    // Initialize the model.
	newModel = [newModel initWithFileName:filename];
    
    // Keep tracking.
    [m_models addObject:newModel];
    
	return newModel;
}

- (VEScene*)NewSceneWithName:(NSString*)name
{
    // Initialize the camera.
    VEScene* newScene = [[VEScene alloc] initWithName:name];
    
    // Keep tracking.
    [m_scenes addObject:newScene];
    
    return newScene;
}

- (VEView*)NewViewAs:(enum VE_VIEW_TYPE)viewtype Width:(GLint)width Height:(GLint)height
{
    VEView* newView = [VEView alloc];
    
    // Set the properties for the model.
    newView.FullScreenShader = m_fullScreenShader;
    newView.GaussianBlurShader = m_gaussianBlurShader;
    newView.DepthOfFieldShader = m_depthOfFieldShader;
    
    // Initialize the model.
    newView = [newView initAs:viewtype GLKView:m_GLKView Width:width Height:height];
    
    return newView;
}

- (VECamera*)NewCamera:(enum VE_CAMERA_TYPE)cameratype
{
    // Initialize the camera.
    VECamera* newCamera = [[VECamera alloc] initAs:cameratype];
	
    // Keep tracking.
    [m_cameras addObject:newCamera];
    
    return newCamera;
}

- (VELight*)NewLight
{
    // Initialize the camera.
    VELight* newLight = [[VELight alloc] init];
    
    // Keep tracking.
    [m_lights addObject:newLight];
    
    return newLight;
}

- (VEText*)NewTextWithFontName:(NSString*)fontname Text:(NSString*)text
{
	VEText* newText = [VEText alloc];
	
	// Set the properties for the text.
	newText.TextureDispatcher = m_textureDispatcher;
	newText.TextShader = m_textShader;
	
	newText = [newText initWithFontName:fontname Text:text];
	
	// Keep tracking.
	[m_texts addObject:newText];
	
	return newText;
}

- (VEWatch*)NewWatchWithStyle:(enum VE_WATCH_STYLE)style
{
	VEWatch* newWatch = [[VEWatch alloc] init];
	newWatch.Style = style;
	
	// Keep tracking.
	[m_watches addObject:newWatch];
	
	return newWatch;
}

- (void)ReleaseModel:(VEModel*)model
{
    [m_models enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(VEModel* modelA, NSUInteger index, BOOL *stop)
    {
        if (model == modelA)
        {
            [m_models removeObjectAtIndex:index];
        }
    }];
}

- (void)ReleaseSprite:(VESprite*)sprite
{
    [m_sprites enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(VESprite* spriteA, NSUInteger index, BOOL *stop)
     {
         if (sprite == spriteA)
         {
             [m_models removeObjectAtIndex:index];
         }
     }];
}

- (void)ReleaseScene:(VEScene*)scene
{
    [m_scenes enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(VEScene* sceneA, NSUInteger index, BOOL *stop)
     {
         if (scene == sceneA)
         {
             [m_scenes removeObjectAtIndex:index];
         }
     }];
}

- (void)ReleaseCamera:(VECamera*)camera
{
    [m_cameras enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(VECamera* cameraA, NSUInteger index, BOOL *stop)
     {
         if (camera == cameraA)
         {
             [m_cameras removeObjectAtIndex:index];
         }
     }];
}

- (void)ReleaseLight:(VELight*)light
{
    [m_lights enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(VELight* lightA, NSUInteger index, BOOL *stop)
     {
         if (light == lightA)
         {
             [m_lights removeObjectAtIndex:index];
         }
     }];
}

- (void)ReleaseText:(VEText*)text
{
	[m_texts enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(VEText* textA, NSUInteger index, BOOL *stop)
	 {
		 if (text == textA)
		 {
			 [m_texts removeObjectAtIndex:index];
		 }
	 }];
}

- (void)ReleaseWatch:(VEWatch *)watch
{
	[m_watches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(VEWatch* watchA, NSUInteger index, BOOL *stop)
	 {
		 if (watch == watchA)
		 {
			 [m_watches removeObjectAtIndex:index];
		 }
	 }];
}

@end
