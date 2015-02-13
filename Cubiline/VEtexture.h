#ifndef VisualEngine_VEtexture_h
#define VisualEngine_VEtexture_h

#import <GLKit/GLKit.h>

@interface VETexture : NSObject

@property unsigned int TextureID;
@property (readonly) NSString* FileName;
@property (readonly) unsigned int Width;
@property (readonly) unsigned int Height;

- (id)initForBufferType:(GLenum)buffertype Width:(GLint)width Height:(GLint)height;
- (id)initFromFile:(NSString*)filename;

@end

#endif
