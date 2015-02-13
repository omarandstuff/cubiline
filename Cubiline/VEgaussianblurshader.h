#ifndef VisualEngine_VEgaussianblurshader_h
#define VisualEngine_VEgaussianblurshader_h

#import "VEshader.h"

@interface VEGaussianBlurShader : VEShader

- (void)RenderWithTexture:(GLuint)textureid TextureStep:(float)step BlurRadious:(float)radious VHOption:(bool)vhoption;

@end

#endif
