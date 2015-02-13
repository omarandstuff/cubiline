#ifndef VisualEngine_VEdepthoffieldshader_h
#define VisualEngine_VEdepthoffieldshader_h

#import "VEshader.h"

@interface VEDepthOfFieldShader : VEShader

- (void)RenderWithSolid:(GLuint)solidid Blur:(GLuint)blurid Depth:(GLuint)depthid FocusDistance:(float)focusdist FocusRange:(float)focusrange Near:(float)near Far:(float)far;

@end

#endif
