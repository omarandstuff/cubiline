#ifndef VisualEngine_VElight_h
#define VisualEngine_VElight_h

#import "VE3Dobject.h"

@interface VELight : VE3DObject
{
    VEEffect3* m_color;
    
    VEEffect1* m_intensity;
    VEEffect1* m_attenuationDistance;
    VEEffect1* m_ambientCoefficient;
}

/// Color
@property GLKVector3 Color;
@property enum VE_TRANSITION_EFFECT ColorTransitionEffect;
@property float ColorTransitionTime;
@property float ColorTransitionSpeed;
@property float ColorEase;
@property (readonly) bool ColorIsActive;

/// Intensity
@property float Intensity;
@property enum VE_TRANSITION_EFFECT IntensityTransitionEffect;
@property float IntensityTransitionTime;
@property float IntensityTransitionSpeed;
@property float IntensityEase;
@property (readonly) bool IntensityIsActive;

/// Atenuation
@property float AttenuationDistance;
@property enum VE_TRANSITION_EFFECT AttenuationDistanceTransitionEffect;
@property float AttenuationDistanceTransitionTime;
@property float AttenuationDistanceTransitionSpeed;
@property float AttenuationDistanceEase;
@property (readonly) bool AttenuationDistanceIsActive;

/// Ambient
@property float AmbientCoefficient;
@property enum VE_TRANSITION_EFFECT AmbientCoefficientTransitionEffect;
@property float AmbientCoefficientTransitionTime;
@property float AmbientCoefficientTransitionSpeed;
@property float AmbientCoefficientEase;
@property (readonly) bool AmbientCoefficientDistanceIsActive;

@end

#endif
