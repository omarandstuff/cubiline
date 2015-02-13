#ifndef VisualEngine_VEsahder_h
#define VisualEngine_VEsahder_h

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>
#import "VEcommon.h"

@interface VEShader : NSObject
{
	GLuint m_glProgram;
}

- (id)initWithShaderName:(NSString*)shadername BufferIn:(enum VE_BUFFER_MODE)bufferin;

@end

#endif
