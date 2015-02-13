#ifndef VisualEngine_VEcamera_h
#define VisualEngine_VEcamera_h

#import "VE3dobject.h"
#import "VEcommon.h"

@interface VECamera : VE3DObject
{
    VEEffect3* m_lookAt;
    VEEffect3* m_viewUp;
    VEEffect1* m_zoom;
    
    VEEffect1* m_near;
    VEEffect1* m_far;
    VEEffect1* m_focusDist;
    VEEffect1* m_focusRange;
    
    bool m_recalLookAt;
    bool m_recalZoom;
    bool m_recalViewUp;
}

/// Look At
@property GLKVector3 LookAt;
@property enum VE_TRANSITION_EFFECT LookAtTransitionEffect;
@property float LookAtTransitionTime;
@property float LookAtTransitionSpeed;
@property float LookAtEase;
@property (readonly) bool LookAtIsActive;
@property bool LockLookAt; ///

/// View Up
@property GLKVector3 ViewUp;
@property enum VE_TRANSITION_EFFECT ViewUpTransitionEffect;
@property float ViewUpTransitionTime;
@property float ViewUpTransitionSpeed;
@property float ViewUpEase;
@property (readonly) bool ViewUpIsActive;

/// Zoom
@property float Zoom;
@property enum VE_TRANSITION_EFFECT ZoomTransitionEffect;
@property float ZoomTransitionTime;
@property float ZoomTransitionSpeed;
@property float ZoomEase;
@property (readonly) bool ZoomIsActive;

/// Near
@property float Near;
@property enum VE_TRANSITION_EFFECT NearTransitionEffect;
@property float NearTransitionTime;
@property float NearTransitionSpeed;
@property float NearEase;
@property (readonly) bool NearIsActive;

/// Far
@property float Far;
@property enum VE_TRANSITION_EFFECT FarTransitionEffect;
@property float FarTransitionTime;
@property float FarTransitionSpeed;
@property float FarEase;
@property (readonly) bool FarIsActive;

/// Focus Distance
@property float FocusDistance;
@property enum VE_TRANSITION_EFFECT FocusDistanceTransitionEffect;
@property float FocusDistanceTransitionTime;
@property float FocusDistanceTransitionSpeed;
@property float FocusDistanceEase;
@property (readonly) bool FocusDistanceIsActive;

/// Focus Range
@property float FocusRange;
@property enum VE_TRANSITION_EFFECT FocusRangeTransitionEffect;
@property float FocusRangeTransitionTime;
@property float FocusRangeTransitionSpeed;
@property float FocusRangeEase;
@property (readonly) bool FocusRangeIsActive;

@property float Aspect;
@property int ViewWidth;
@property int ViewHeigt;

@property bool DepthOfField;

@property (readonly) GLKMatrix4 ProjectionMatrix;
@property (readonly) GLKMatrix4 ViewMatrix;

- (id)initAs:(enum VE_CAMERA_TYPE)cameratype;

@end

#endif
