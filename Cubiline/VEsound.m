#import "VEsound.h"

@interface VESound()
{
    VESoundBuffer* m_soundBuffer;
    bool m_inSource;
    bool m_pause;
    ALuint m_audioSource;
}

- (void)ReleaseBuffer;

@end

@implementation VESound

/// Position
@synthesize Position;
@synthesize PositionTransitionEffect;
@synthesize PositionTransitionTime;
@synthesize PositionTransitionSpeed;
@synthesize PositionEase;
@synthesize PositionIsActive;

/// Gain
@synthesize Gain;
@synthesize GainTransitionEffect;
@synthesize GainTransitionTime;
@synthesize GainTransitionSpeed;
@synthesize GainEase;
@synthesize GainIsActive;

/// Pitch
@synthesize Pitch;
@synthesize PitchTransitionEffect;
@synthesize PitchTransitionTime;
@synthesize PitchTransitionSpeed;
@synthesize PitchEase;
@synthesize PitchIsActive;

@synthesize Loop;
@synthesize SoundBufferDispatcher;
@synthesize AudioSources;

- (id)initWithFileName:(NSString*)filename
{
    self = [super init];
    
    if(self)
    {
        m_position = [[VEEffect3 alloc] init];
        m_gain = [[VEEffect1 alloc] init];
        m_gain.Value = 1.0f;
        m_pitch = [[VEEffect1 alloc] init];
        m_pitch.Value = 1.0f;
        Loop = false;
        
        m_soundBuffer = [SoundBufferDispatcher GetSoundByFileName:filename];
    }
    
    return self;
}

- (void)Frame:(float)time
{
    if(m_position.IsActive || m_recalPosition)
    {
        [m_position Frame:time];
        if(m_inSource)
        {
            GLKVector3 position = m_position.Vector;
            alSource3f(m_audioSource, AL_POSITION, position.x, position.y, position.z);
        }
            
    }
    if(m_gain.IsActive || m_recalGain)
    {
        [m_gain Frame:time];
        if(m_inSource)
            alSourcef(m_audioSource, AL_GAIN, m_gain.Value);
    }
    if(m_pitch.IsActive || m_recalPitch)
    {
        [m_pitch Frame:time];
        if(m_inSource)
            alSourcef(m_audioSource, AL_PITCH, m_pitch.Value);
    }
    
    if(m_inSource && !m_pause)
    {
        ALint sourceState;
        alGetSourcei(m_audioSource, AL_SOURCE_STATE, &sourceState);
        if (sourceState != AL_PLAYING)
        {
            [AudioSources addObject:[NSNumber numberWithUnsignedInt:m_audioSource]];
            m_audioSource = 0;
            m_inSource = false;
            m_pause = false;
        }
    }
}

- (void)Play
{
    if(m_pause)
    {
        alSourcePlay(m_audioSource);
        m_pause = false;
        return;
    }
    if(m_inSource) return;
    if([AudioSources count])
    {
        m_audioSource = (ALuint)[[AudioSources lastObject] integerValue];
        [AudioSources removeLastObject];
        
        alSourcei(m_audioSource, AL_BUFFER, m_soundBuffer.SoundBufferID);
        
        alSourcef(m_audioSource, AL_GAIN, m_gain.Value);
        alSourcef(m_audioSource, AL_PITCH, m_pitch.Value);
        
        GLKVector3 position = m_position.Vector;
        
        alSource3f(m_audioSource, AL_POSITION, position.x, position.y, position.z);
        
        alSourcePlay(m_audioSource);
        
        m_inSource = true;
    }
}

- (void)Pause
{
    if(m_inSource)
    {
        alSourcePause(m_audioSource);
        m_pause = true;
    }
}

- (void)Stop
{
    if(m_inSource)
    {
        alSourceStop(m_audioSource);
        [AudioSources addObject:[NSNumber numberWithUnsignedInt:m_audioSource]];
        m_audioSource = 0;
        m_inSource = false;
        m_pause = false;
    }
}

////////// Position /////////////////
- (void)setPosition:(GLKVector3)position
{
    m_position.Vector = position;
    m_recalPosition = true;
}

- (GLKVector3)Position
{
    return m_position.Vector;
}

- (void)setPositionTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_position.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)PositionTransitionEffect
{
    return m_position.TransitionEffect;
}

- (void)setPositionTransitionTime:(float)transitiontime
{
    m_position.TransitionTime = transitiontime;
}

- (float)PositionTransitionTime
{
    return m_position.TransitionTime;
}

- (void)setPositionTransitionSpeed:(float)transitionspeed
{
    m_position.TransitionSpeed = transitionspeed;
}

- (float)PositionTransitionSpeed
{
    return m_position.TransitionSpeed;
}

- (void)setPositionEase:(float)ease
{
    m_position.Ease = ease;
}

- (float)PositionEase
{
    return m_position.Ease;
}

- (bool)PositionIsActive
{
    return m_position.IsActive;
}

- (void)ResetPosition
{
    [m_position Reset];
    m_recalPosition = true;
}

- (void)ResetPosition:(GLKVector3)state
{
    [m_position Reset:state];
    m_recalPosition = true;
}

////////// Gain /////////////////
- (void)setGain:(float)gain
{
    m_gain.Value = gain;
    m_recalGain = true;
}

- (float)Gain
{
    return m_gain.Value;
}

- (void)setGainTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_gain.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)GainTransitionEffect
{
    return m_gain.TransitionEffect;
}

- (void)setGainTransitionTime:(float)transitiontime
{
    m_gain.TransitionTime = transitiontime;
}

- (float)GainTransitionTime
{
    return m_gain.TransitionTime;
}

- (void)setGainTransitionSpeed:(float)transitionspeed
{
    m_gain.TransitionSpeed = transitionspeed;
}

- (float)GainTransitionSpeed
{
    return m_gain.TransitionSpeed;
}

- (void)setGainEase:(float)ease
{
    m_gain.Ease = ease;
}

- (float)GainEase
{
    return m_gain.Ease;
}

- (bool)GainIsActive
{
    return m_gain.IsActive;
}

////////// pitch /////////////////
- (void)setPitch:(float)pitch
{
    m_pitch.Value = pitch;
    m_recalPitch = true;
}

- (float)Pitch
{
    return m_pitch.Value;
}

- (void)setPitchTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_pitch.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)PitchTransitionEffect
{
    return m_pitch.TransitionEffect;
}

- (void)setPitchTransitionTime:(float)transitiontime
{
    m_pitch.TransitionTime = transitiontime;
}

- (float)PitchTransitionTime
{
    return m_pitch.TransitionTime;
}

- (void)setPitchTransitionSpeed:(float)transitionspeed
{
    m_pitch.TransitionSpeed = transitionspeed;
}

- (float)PitchTransitionSpeed
{
    return m_pitch.TransitionSpeed;
}

- (void)setPitchEase:(float)ease
{
    m_pitch.Ease = ease;
}

- (float)PitchEase
{
    return m_pitch.Ease;
}

- (bool)PitchIsActive
{
    return m_pitch.IsActive;
}

////////// Loop /////////////////
- (void)setLoop:(bool)loop
{
    Loop = loop;
}

- (bool)Loop
{
    return Loop;
}

- (void)ReleaseBuffer
{
    if(m_inSource)
        [self Stop];
    [SoundBufferDispatcher ReleaseSound:m_soundBuffer];
}

- (void)dealloc
{
    [self ReleaseBuffer];
}

@end
