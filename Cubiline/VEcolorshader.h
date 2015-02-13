#ifndef VisualEngine_VEcolorshader_h
#define VisualEngine_VEcolorshader_h

#import "VEshader.h"

@interface VEColorShader : VEShader

- (void)Render:(GLKMatrix4*)mvpmatrix Color:(GLKVector3)color Opasity:(float)opasity;

@end

#endif
