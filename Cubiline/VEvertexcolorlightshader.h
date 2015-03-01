#ifndef Cubiline_VEvertexcolorlightshader_h
#define Cubiline_VEvertexcolorlightshader_h

#import "VEshader.h"
#import "VEcamera.h"
#import "VElight.h"

@interface VEVertexColorLightShader : VEShader

- (void)Render:(GLKMatrix4*)mvpmatrix ModelMatrix:(GLKMatrix4*)modelmatrix NormalMatrix:(GLKMatrix3*)normalmatrix CameraPosition:(GLKVector3)position Lights:(NSMutableArray*)lights MaterialSpecular:(float)specular MaterialSpecularColor:(GLKVector3)specularcolor MaterialGlossiness:(float)glossiness Color:(GLKVector3)color Opasity:(float)opasity;

@end

#endif
