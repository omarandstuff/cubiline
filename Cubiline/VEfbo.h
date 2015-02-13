#ifndef VisualEngine_VEfbo_h
#define VisualEngine_VEfbo_h

#import "VEcommon.h"
#import "VEtexture.h"

@interface VEFBO : NSObject

@property (readonly) GLuint FrameBufferID;
@property (readonly) VETexture* Color;
@property (readonly) VETexture* Depth;
@property (readonly) int Width;
@property (readonly) int Height;

- (id)initAs:(enum VE_FBO_TYPE)fbotype Width:(int)width Height:(int)height;
- (void)ResizeWithWidth:(int)width Height:(int)height;

@end

#endif
