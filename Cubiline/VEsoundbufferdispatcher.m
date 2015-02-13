#import "VEsoundbufferdispatcher.h"

@implementation SoundBufferHolder
@end

@interface VESoundBufferDispatcher()
{
    NSMutableDictionary* m_soundBuffers;
}

@end

@implementation VESoundBufferDispatcher

- (id)init
{
    self = [super init];
    
    if(self)
    {
        m_soundBuffers = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (VESoundBuffer*)GetSoundByFileName:(NSString *)filename
{
    SoundBufferHolder* currentSounndBuffer = [m_soundBuffers objectForKey:filename];
    if(currentSounndBuffer)
    {
        currentSounndBuffer.Active++;
        return currentSounndBuffer.SoundBuffer;
    }
    
    currentSounndBuffer = [[SoundBufferHolder alloc] init];
    currentSounndBuffer.Active = 1;
    currentSounndBuffer.SoundBuffer = [[VESoundBuffer alloc] initWithFileName:filename];

    
    [m_soundBuffers setObject:currentSounndBuffer forKey:filename];
    
    return currentSounndBuffer.SoundBuffer;
}

- (void)ReleaseSound:(VESoundBuffer*)soundbuffer
{
    SoundBufferHolder* currentSoundBuffer = [m_soundBuffers objectForKey:soundbuffer.FileName];
    
    if(currentSoundBuffer)
    {
        if(currentSoundBuffer.Active == 1)
            [m_soundBuffers removeObjectForKey:currentSoundBuffer.SoundBuffer.FileName];
        else
            currentSoundBuffer.Active--;
    }
}

@end
