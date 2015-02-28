
#ifndef Cubiline_VEcolordiffuseshader_h
#define Cubiline_VEcolordiffuseshader_h

#import "VEshader.h"
#import "VElight.h"

@interface VEColorDiffuseShader : VEShader

- (void)Render:(GLKMatrix4*)mvpmatrix ModelMatrix:(GLKMatrix4*)modelmatrix NormalMatrix:(GLKMatrix3*)normalmatrix Lights:(NSMutableArray*)lights Color:(GLKVector3)color Opasity:(float)opasity;

@end

#endif
