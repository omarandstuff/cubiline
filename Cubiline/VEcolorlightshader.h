#ifndef VisualEngine_VEcolorlightshader_h
#define VisualEngine_VEcolorlightshader_h

#import "VEshader.h"
#import "VEcamera.h"
#import "VElight.h"

@interface VEColorLightShader : VEShader

- (void)Render:(GLKMatrix4*)mvpmatrix ModelMatrix:(GLKMatrix4*)modelmatrix NormalMatrix:(GLKMatrix3*)normalmatrix CameraPosition:(GLKVector3)position Lights:(NSMutableArray*)lights EnableSpecular:(bool)enablespecular EnableNoise:(bool)enablenoise MaterialSpecular:(float)specular MaterialSpecularColor:(GLKVector3)specularcolor MaterialGlossiness:(float)glossiness Color:(GLKVector3)color Opasity:(float)opasity;

@end

#endif
