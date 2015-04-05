#ifndef VisualEngine_VEsound_h
#define VisualEngine_VEsound_h

#import "VEeffect1.h"
#import "VEEffect3.h"
#import "VEsoundbufferdispatcher.h"

@interface VESound : NSObject
{
    VEEffect3* m_position;
    VEEffect1* m_gain;
    VEEffect1* m_pitch;
    
    bool m_recalPosition;
    bool m_recalGain;
    bool m_recalPitch;
}

/// Position
@property GLKVector3 Position;
@property enum VE_TRANSITION_EFFECT PositionTransitionEffect;
@property float PositionTransitionTime;
@property float PositionTransitionSpeed;
@property float PositionEase;
@property (readonly) bool PositionIsActive;

/// Gain
@property float Gain;
@property enum VE_TRANSITION_EFFECT GainTransitionEffect;
@property float GainTransitionTime;
@property float GainTransitionSpeed;
@property float GainEase;
@property (readonly) bool GainIsActive;

/// Pitch
@property float Pitch;
@property enum VE_TRANSITION_EFFECT PitchTransitionEffect;
@property float PitchTransitionTime;
@property float PitchTransitionSpeed;
@property float PitchEase;
@property (readonly) bool PitchIsActive;

@property bool Loop;
@property bool Mute;

@property VESoundBufferDispatcher* SoundBufferDispatcher;
@property NSMutableArray* AudioSources;

- (id)initWithFileName:(NSString*)filename;
- (void)Frame:(float)time;

- (void)Play;
- (void)Pause;
- (void)Stop;

@end

#endif
