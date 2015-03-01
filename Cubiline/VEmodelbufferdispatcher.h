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
@property VEVertexLightShader* VertexLightShader;
@property VEVertexColorLightShader* VertexColorLightShader;
@property VEDiffuseShader* DiffuseShader;
@property VEColorDiffuseShader* ColorDiffuseShader;
@property VEColorShader* ColorShader;
@property VETextureShader* TextureShader;

- (VEModelBuffer*)GetModelBufferByFileName:(NSString*)filename;
- (void)ReleaseModelBuffer:(VEModelBuffer*)modelbuffer;

@end

#endif
