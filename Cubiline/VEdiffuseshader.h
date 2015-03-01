#ifndef Cubiline_VEdiffuseshader_h
#define Cubiline_VEdiffuseshader_h

#import "VEshader.h"
#import "VElight.h"

@interface VEDiffuseShader : VEShader

- (void)Render:(GLKMatrix4*)mvpmatrix ModelMatrix:(GLKMatrix4*)modelmatrix NormalMatrix:(GLKMatrix3*)normalmatrix Lights:(NSMutableArray*)lights TextureID:(GLuint)textureid TextureCompression:(GLKVector3)texturecompression Opasity:(float)opasity;

@end

#endif
