#ifndef VisualEngine_VEmodeldispatcher_h
#define VisualEngine_VEmodeldispatcher_h

#import "VEmodelbuffer.h"

@interface BufferHolder : NSObject
@property VEModelBuffer* ModelBuffer;
@property unsigned int Active;
@end

@interface VEModelDispatcher : NSObject

@property VETextureDispatcher* TextureDispatcher;
@property VEDepthShader* DepthShader;
@property VELightShader* LightShader;
@property VEColorLightShader* ColorLightShader;
@property VEColorShader* ColorShader;
@property VETextureShader* TextureShader;

- (VEModelBuffer*)GetModelBufferByFileName:(NSString*)filename;
- (void)ReleaseModelBuffer:(VEModelBuffer*)modelbuffer;

@end

#endif
