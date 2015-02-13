#import "VElight.h"

@interface VELight()
{
    
}

@end


@implementation VELight

/// Color
@synthesize Color;
@synthesize ColorTransitionEffect;
@synthesize ColorTransitionTime;
@synthesize ColorTransitionSpeed;
@synthesize ColorEase;
@synthesize ColorIsActive;

/// Intensity
@synthesize Intensity;
@synthesize IntensityTransitionEffect;
@synthesize IntensityTransitionTime;
@synthesize IntensityTransitionSpeed;
@synthesize IntensityEase;
@synthesize IntensityIsActive;

/// Atenuation
@synthesize AttenuationDistance;
@synthesize AttenuationDistanceTransitionEffect;
@synthesize AttenuationDistanceTransitionTime;
@synthesize AttenuationDistanceTransitionSpeed;
@synthesize AttenuationDistanceEase;
@synthesize AttenuationDistanceIsActive;

/// Ambient
@synthesize AmbientCoefficient;
@synthesize AmbientCoefficientTransitionEffect;
@synthesize AmbientCoefficientTransitionTime;
@synthesize AmbientCoefficientTransitionSpeed;
@synthesize AmbientCoefficientEase;
@synthesize AmbientCoefficientDistanceIsActive;

- (id)init
{
    self = [super init];
    
    if(self)
    {
        m_color = [[VEEffect3 alloc] init];
        m_color.Vector = GLKVector3Make(1.0f, 1.0f, 1.0f);
        m_intensity = [[VEEffect1 alloc] init];
        m_attenuationDistance = [[VEEffect1 alloc] init];
        m_ambientCoefficient = [[VEEffect1 alloc] init];
    }
    
    return self;
}

- (void)Frame:(float)time
{
    [m_color Frame:time];
    [m_intensity Frame:time];
    [m_attenuationDistance Frame:time];
    [m_ambientCoefficient Frame:time];
    
    [super Frame:time];
}

////////// Color /////////////////
- (void)setColor:(GLKVector3)color
{
    m_color.Vector = color;
}

- (GLKVector3)Color
{
    return m_color.Vector;
}

- (void)setColorTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_color.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)ColorTransitionEffect
{
    return m_color.TransitionEffect;
}

- (void)setColorTransitionTime:(float)transitiontime
{
    m_color.TransitionTime = transitiontime;
}

- (float)ColorTransitionTime
{
    return m_color.TransitionTime;
}

- (void)setColorTransitionSpeed:(float)transitionspeed
{
    m_color.TransitionSpeed = transitionspeed;
}

- (float)ColorTransitionSpeed
{
    return m_color.TransitionSpeed;
}

- (void)setColorEase:(float)ease
{
    m_color.Ease = ease;
}

- (float)ColorEase
{
    return m_color.Ease;
}

- (bool)ColorIsActive
{
    return m_color.IsActive;
}

////////// Intensity /////////////////
- (void)setIntensity:(float)intensity
{
    m_intensity.Value = intensity;
}

- (float)Intensity
{
    return m_intensity.Value;
}

- (void)setIntensityTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_intensity.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)IntensityTransitionEffect
{
    return m_intensity.TransitionEffect;
}

- (void)setIntensityTransitionTime:(float)transitiontime
{
    m_intensity.TransitionTime = transitiontime;
}

- (float)IntensityTransitionTime
{
    return m_intensity.TransitionTime;
}

- (void)setIntensityTransitionSpeed:(float)transitionspeed
{
    m_intensity.TransitionSpeed = transitionspeed;
}

- (float)IntensityTransitionSpeed
{
    return m_intensity.TransitionSpeed;
}

- (void)setIntensityEase:(float)ease
{
    m_intensity.Ease = ease;
}

- (float)IntensityEase
{
    return m_intensity.Ease;
}

- (bool)IntensityIsActive
{
    return m_intensity.IsActive;
}

////////// Attenuation distance /////////////////
- (void)setAttenuationDistance:(float)attenuation
{
    m_attenuationDistance.Value = attenuation;
}

- (float)AttenuationDistance
{
    return m_attenuationDistance.Value;
}

- (void)setAttenuationDistanceTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_attenuationDistance.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)AttenuationDistanceTransitionEffect
{
    return m_attenuationDistance.TransitionEffect;
}

- (void)setAttenuationDistanceTransitionTime:(float)transitiontime
{
    m_attenuationDistance.TransitionTime = transitiontime;
}

- (float)AttenuationDistanceTransitionTime
{
    return m_attenuationDistance.TransitionTime;
}

- (void)setAttenuationDistanceTransitionSpeed:(float)transitionspeed
{
    m_attenuationDistance.TransitionSpeed = transitionspeed;
}

- (float)AttenuationDistanceTransitionSpeed
{
    return m_attenuationDistance.TransitionSpeed;
}

- (void)setAttenuationDistanceEase:(float)ease
{
    m_attenuationDistance.Ease = ease;
}

- (float)AttenuationDistanceEase
{
    return m_attenuationDistance.Ease;
}

- (bool)AttenuationDistanceIsActive
{
    return m_attenuationDistance.IsActive;
}

////////// Ambient Coefficient /////////////////
- (void)setAmbientCoefficient:(float)coefficient
{
    m_ambientCoefficient.Value = coefficient;
}

- (float)AmbientCoefficient
{
    return m_ambientCoefficient.Value;
}

- (void)setAmbientCoefficientTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_ambientCoefficient.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)AmbientCoefficientTransitionEffect
{
    return m_ambientCoefficient.TransitionEffect;
}

- (void)setAmbientCoefficientTransitionTime:(float)transitiontime
{
    m_ambientCoefficient.TransitionTime = transitiontime;
}

- (float)AmbientCoefficientTransitionTime
{
    return m_ambientCoefficient.TransitionTime;
}

- (void)setAmbientCoefficientTransitionSpeed:(float)transitionspeed
{
    m_ambientCoefficient.TransitionSpeed = transitionspeed;
}

- (float)AmbientCoefficientTransitionSpeed
{
    return m_ambientCoefficient.TransitionSpeed;
}

- (void)setAmbientCoefficientEase:(float)ease
{
    m_ambientCoefficient.Ease = ease;
}

- (float)AmbientCoefficientEase
{
    return m_ambientCoefficient.Ease;
}

- (bool)AmbientCoefficientIsActive
{
    return m_ambientCoefficient.IsActive;
}

@end
