#ifndef VisualEngine_VEtextshader_h
#define VisualEngine_VEtextshader_h

#import "VEshader.h"

@interface VETextShader : VEShader

- (void)Render:(GLKMatrix4*)mvpmatrix TextureID:(GLuint)textureid Color:(GLKVector3)color Opasity:(float)opasity;

@end

#endif
