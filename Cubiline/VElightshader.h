#ifndef VisualEngine_VElightshader_h
#define VisualEngine_VElightshader_h

#import "VEshader.h"
#import "VEcamera.h"
#import "VElight.h"

@interface VELightShader : VEShader

- (void)Render:(GLKMatrix4*)mvpmatrix ModelMatrix:(GLKMatrix4*)modelmatrix NormalMatrix:(GLKMatrix3*)normalmatrix CameraPosition:(GLKVector3)position Lights:(NSMutableArray*)lights TextureID:(GLuint)textureid TextureCompression:(GLKVector3)texturecompression MaterialSpecular:(float)specular MaterialSpecularColor:(GLKVector3)specularcolor MaterialGlossiness:(float)glossiness Opasity:(float)opasity;

@end

#endif
