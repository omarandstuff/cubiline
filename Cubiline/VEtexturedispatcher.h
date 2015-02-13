#ifndef VisualEngine_VEtexturedispatcher_h
#define VisualEngine_VEtexturedispatcher_h

#import "VEtexture.h"

/// Texture holder ///
@interface TextureHolder : NSObject
@property VETexture* Texture;
@property unsigned int Active;
@end
///////////

@interface VETextureDispatcher : NSObject

- (VETexture*)GetTextureByFileName:(NSString*)filename;
- (void)ReleaseTexture:(VETexture*)texture;

@end

#endif
