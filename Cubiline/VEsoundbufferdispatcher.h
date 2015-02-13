#ifndef VisualEngine_VEsoundbufferdispatcher_h
#define VisualEngine_VEsoundbufferdispatcher_h

#import "VEsoundbuffer.h"

@interface SoundBufferHolder : NSObject
@property VESoundBuffer* SoundBuffer;
@property unsigned int Active;
@end

@interface VESoundBufferDispatcher : NSObject

- (VESoundBuffer*)GetSoundByFileName:(NSString*)filename;
- (void)ReleaseSound:(VESoundBuffer*)soundbuffer;

@end

#endif
