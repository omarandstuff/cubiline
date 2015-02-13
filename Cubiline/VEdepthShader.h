#ifndef VisualEngine_VEdepthShader_h
#define VisualEngine_VEdepthShader_h

#import "VEshader.h"

@interface VEDepthShader : VEShader

- (void)Render:(GLKMatrix4*)mvpmatrix;

@end

#endif
