#ifndef VisualEngine_VEview_h
#define VisualEngine_VEview_h

#import "VEscene.h"
#import "VEfullscreenshader.h"
#import "VEgaussianblurshader.h"
#import "VEdepthoffieldshader.h"
#import "VEfbo.h"

@interface VEView : NSObject

@property VEFullScreenShader* FullScreenShader;
@property VEGaussianBlurShader* GaussianBlurShader;
@property VEDepthOfFieldShader* DepthOfFieldShader;
@property VECamera* Camera;
@property VETexture* Color;
@property VETexture* Depth;
@property (readonly) int Width;
@property (readonly) int Height;
@property bool EnableLight;
@property GLKVector4 ClearColor;
@property VEScene* Scene;
@property VESprite* Fader;

- (id)initAs:(enum VE_VIEW_TYPE)viewtype GLKView:(GLKView*)glkview Width:(GLint)width Height:(GLint)height;
- (void)ResizeWithWidth:(GLint)width Height:(GLint)height;
- (void)Render;

@end

#endif
