#ifndef VisualEngine_VEsoundbuffer_h
#define VisualEngine_VEsoundbuffer_h

#import <Foundation/Foundation.h>
#import <OpenAl/al.h>
#import <OpenAl/alc.h>
#include <AudioToolbox/AudioToolbox.h>

@interface VESoundBuffer : NSObject

@property (readonly) ALuint SoundBufferID;
@property (readonly) NSString* FileName;

- (id)initWithFileName:(NSString*)filename;

@end



#endif
