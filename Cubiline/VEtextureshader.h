#ifndef VisualEngine_VEtextureshader_h
#define VisualEngine_VEtextureshader_h

#import "VEshader.h"

@interface VETextureShader : VEShader

- (void)Render:(GLKMatrix4*)mvpmatrix TextureID:(GLuint)textureid TextureCompression:(GLKVector3)texturecompression Color:(GLKVector3)color Opasity:(float)opasity;

@end

#endif
