#ifndef VisualEngine_VEfullscreenshader_h
#define VisualEngine_VEfullscreenshader_h

#import "VEshader.h"

@interface VEFullScreenShader : VEShader

- (void)Render:(GLuint)textureid;

@end

#endif
