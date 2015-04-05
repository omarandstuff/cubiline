#import "VEaudiobox.h"

@interface VEAudioBox()
{
    NSMutableArray* m_sources;
    NSMutableArray* m_sounds;
    
    VESoundBufferDispatcher* m_soundBufferDispatcher;
}

- (void)SetUpAudioTools;

@end

@implementation VEAudioBox

static ALCdevice *openALDevice;
static ALCcontext *openALContext;

@synthesize Listener;
@synthesize Mute;

- (id)init
{
    self = [super init];
    
    if(self)
    {
        [self SetUpAudioTools];
    }
    
    return self;
}

+ (instancetype)sharedVEAudioBox
{
	static VEAudioBox* sharedVEAudioBox;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{sharedVEAudioBox = [[VEAudioBox alloc] init];});
	
	return sharedVEAudioBox;
}

- (void)Frame:(float)time
{
    // Frame for every active sound.
    for(VESound* sound in m_sounds)
    {
        [sound Frame:time];
    }
    
    // Listener base camera.
    GLKVector3 position = Listener.Position;
    alListener3f(AL_POSITION, position.x, position.y, position.z);
}

- (void)SetUpAudioTools
{
    // Setup the Audio Session and monitor interruptions.
    AudioSessionInitialize(NULL, NULL, AudioInterruptionListenerCallback, NULL);
    
    // Set the category for the Audio Session.
    UInt32 session_category = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(session_category), &session_category);
    
    // Make the Audio Session active.
    AudioSessionSetActive(true);
    
    // Default device.
    openALDevice = alcOpenDevice(NULL);
    
    // Create the sources holder
    m_sources = [[NSMutableArray alloc] init];
    
    if (openALDevice)
    {
        // We need to create a single context and associate it with the device.
        openALContext = alcCreateContext(openALDevice, NULL);
        
        // Set the context we just created to the current context.
        alcMakeContextCurrent(openALContext);
        
        // Generate the sound sources.
        ALuint sourceID;
        for (int i = 0; i < 32; i++)
        {
            alGenSources(1, &sourceID);
            [m_sources addObject:[NSNumber numberWithUnsignedInt:sourceID]];
        }
    }
    
    // Sound buffer dispatcher object.
    m_soundBufferDispatcher = [[VESoundBufferDispatcher alloc] init];
    
    // Keep tracking
    m_sounds = [[NSMutableArray alloc] init];
}

void AudioInterruptionListenerCallback(void* user_data, UInt32 interruption_state)
{
    if (kAudioSessionBeginInterruption == interruption_state)
    {
        // Give up the context.
        alcMakeContextCurrent(NULL);
    }
    else if (kAudioSessionEndInterruption == interruption_state)
    {
        // Take back the context.
        AudioSessionSetActive(true);
        alcMakeContextCurrent(openALContext);
    }
}

- (VESound*)NewSoundWithFileName:(NSString*)filename
{
    VESound* newSound = [VESound alloc];
    
    // Set the properties for the model.
    newSound.SoundBufferDispatcher = m_soundBufferDispatcher;
    newSound.AudioSources = m_sources;
    
    // Initialize the model.
    newSound = [newSound initWithFileName:filename];
    
    // Keep tracking.
    [m_sounds addObject:newSound];
    
    return newSound;
}

- (void)ReleaseSound:(VESound*)sound
{
    [m_sounds enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(VESound* soundA, NSUInteger index, BOOL *stop)
     {
         if (sound == soundA)
         {
             [m_sounds removeObjectAtIndex:index];
         }
     }];
}

- (void)setMute:(bool)mute
{
	if(mute != Mute)
	{
		Mute = mute;
		for(VESound* sound in m_sounds)
		{
			[sound Stop];
			sound.Mute = Mute;
		}
	}
}

- (bool)Mute
{
	return Mute;
}

@end