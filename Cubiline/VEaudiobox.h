#ifndef VisualEngine_VEaudiobox_h
#define VisualEngine_VEaudiobox_h

#import "VEsound.h"
#import "VEcamera.h"
#import "VEtimer.h"
#import <AVFoundation/AVFoundation.h>

@interface VEAudioBox : NSObject

@property VECamera* Listener;

- (void)Frame:(float)time;
- (VESound*)NewSoundWithFileName:(NSString*)filename;
- (void)ReleaseSound:(VESound*)sound;

@end

#endif
