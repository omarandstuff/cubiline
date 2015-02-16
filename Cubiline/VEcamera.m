#import "VEcamera.h"

@interface VECamera()
{
    enum VE_CAMERA_TYPE m_cameraType;
}
@end

@implementation VECamera

/// Look At
@synthesize LookAt;
@synthesize LookAtTransitionEffect;
@synthesize LookAtTransitionTime;
@synthesize LookAtTransitionSpeed;
@synthesize LookAtEase;
@synthesize LookAtIsActive;
@synthesize LockLookAt; ///

/// View Up
@synthesize ViewUp;
@synthesize ViewUpTransitionEffect;
@synthesize ViewUpTransitionTime;
@synthesize ViewUpTransitionSpeed;
@synthesize ViewUpEase;
@synthesize ViewUpIsActive;

/// Zoom
@synthesize Zoom;
@synthesize ZoomTransitionEffect;
@synthesize ZoomTransitionTime;
@synthesize ZoomTransitionSpeed;
@synthesize ZoomEase;
@synthesize ZoomIsActive;

/// Near
@synthesize Near;
@synthesize NearTransitionEffect;
@synthesize NearTransitionTime;
@synthesize NearTransitionSpeed;
@synthesize NearEase;
@synthesize NearIsActive;

/// Far
@synthesize Far;
@synthesize FarTransitionEffect;
@synthesize FarTransitionTime;
@synthesize FarTransitionSpeed;
@synthesize FarEase;
@synthesize FarIsActive;

/// Focus Distance
@synthesize FocusDistance;
@synthesize FocusDistanceTransitionEffect;
@synthesize FocusDistanceTransitionTime;
@synthesize FocusDistanceTransitionSpeed;
@synthesize FocusDistanceEase;
@synthesize FocusDistanceIsActive;

/// Focus Range
@synthesize FocusRange;
@synthesize FocusRangeTransitionEffect;
@synthesize FocusRangeTransitionTime;
@synthesize FocusRangeTransitionSpeed;
@synthesize FocusRangeEase;
@synthesize FocusRangeIsActive;

@synthesize DepthOfField;
@synthesize Aspect;
@synthesize ViewWidth;
@synthesize ViewHeigt;

@synthesize ProjectionMatrix;
@synthesize ViewMatrix;
@synthesize PivotRotationStyle;

- (id)initAs:(enum VE_CAMERA_TYPE)cameratype
{
	self = [super init];
    
    if(self)
    {
        m_lookAt = [[VEEffect3 alloc] init];
        m_viewUp = [[VEEffect3 alloc] init];
        m_viewUp.Vector = GLKVector3Make(0.0f, 1.0f, 0.0f);
        m_zoom = [[VEEffect1 alloc] init];
        
        m_near = [[VEEffect1 alloc] init];
        m_near.Value = 0.1f;
        m_far = [[VEEffect1 alloc] init];
        m_far.Value = 1000.0f;
        m_focusDist = [[VEEffect1 alloc] init];
        m_focusDist.Value = 10.0f;
        m_focusRange = [[VEEffect1 alloc] init];
        m_focusRange.Value = 100.0f;
        
        m_cameraType = cameratype;
        m_recalLookAt = false;
        m_recalZoom = true;
        ViewMatrix = GLKMatrix4Identity;
		
		PivotRotationStyle = VE_PIVOT_ROTATION_ZYX;
    }
	
	return self;
}

- (void)Frame:(float)time
{
    // Focus
    [m_focusDist Frame:time];
    [m_focusRange Frame:time];
    
    // Projection Matrix
    if(m_recalZoom)
    {
        [m_zoom Frame:time];
        [m_near Frame:time];
        [m_far Frame:time];
        if(m_cameraType == VE_CAMERA_TYPE_PERSPECTIVE)
        {
            float macsucks = m_zoom.Value;
            ProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0f) + GLKMathDegreesToRadians(45.0f) * -macsucks, Aspect, m_near.Value, m_far.Value);
        }
        else
        {
            float sw2 = ((float)ViewWidth / 2.0f);
            float sh2 = ((float)ViewHeigt / 2.0f);
            sw2 = sw2 - sw2 * m_zoom.Value;
            sh2 = sh2 - sh2 * m_zoom.Value;
            ProjectionMatrix = GLKMatrix4MakeOrtho(-sw2, sw2, -sh2, sh2, -10.0f, 10.0);
        }
        if(!m_zoom.IsActive)m_recalZoom = false;
    }
    
    if(!m_recalPivotRotation && !m_recalPosition && !m_recalRotation && !m_recalLookAt && !m_recalViewUp) return;

    bool newPos = false;
    if(m_recalPivotRotation || m_recalPosition)
    {
        [m_pivotRotation Frame:time];
        [m_pivot Frame:time];
        
		GLKVector3 pivotRotation = m_pivotRotation.Vector;
		
		GLKMatrix4 pivotRotationMatrix = GLKMatrix4Identity;
		if(PivotRotationStyle == VE_PIVOT_ROTATION_XYZ)
		{
			pivotRotationMatrix = GLKMatrix4RotateX(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.x));
			pivotRotationMatrix = GLKMatrix4Rotate(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.y), 0.0f, 1.0f, 0.0f);
			pivotRotationMatrix = GLKMatrix4Rotate(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.z), 0.0f, 0.0f, 1.0f);
		}
		if(PivotRotationStyle == VE_PIVOT_ROTATION_XZY)
		{
			pivotRotationMatrix = GLKMatrix4RotateX(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.x));
			pivotRotationMatrix = GLKMatrix4Rotate(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.z), 0.0f, 0.0f, 1.0f);
			pivotRotationMatrix = GLKMatrix4Rotate(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.y), 0.0f, 1.0f, 0.0f);
		}
		if(PivotRotationStyle == VE_PIVOT_ROTATION_YXZ)
		{
			pivotRotationMatrix = GLKMatrix4RotateY(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.y));
			pivotRotationMatrix = GLKMatrix4Rotate(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.x), 1.0f, 0.0f, 0.0f);
			pivotRotationMatrix = GLKMatrix4Rotate(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.z), 0.0f, 0.0f, 1.0f);
		}
		if(PivotRotationStyle == VE_PIVOT_ROTATION_YZX)
		{
			pivotRotationMatrix = GLKMatrix4RotateY(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.y));
			pivotRotationMatrix = GLKMatrix4Rotate(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.z), 0.0f, 0.0f, 1.0f);
			pivotRotationMatrix = GLKMatrix4Rotate(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.x), 1.0f, 0.0f, 0.0f);
		}
		if(PivotRotationStyle == VE_PIVOT_ROTATION_ZXY)
		{
			pivotRotationMatrix = GLKMatrix4RotateZ(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.z));
			pivotRotationMatrix = GLKMatrix4Rotate(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.x), 1.0f, 0.0f, 0.0f);
			pivotRotationMatrix = GLKMatrix4Rotate(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.y), 0.0f, 1.0f, 0.0f);
		}
		if(PivotRotationStyle == VE_PIVOT_ROTATION_ZYX)
		{
			pivotRotationMatrix = GLKMatrix4RotateZ(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.z));
			pivotRotationMatrix = GLKMatrix4Rotate(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.y), 0.0f, 1.0f, 0.0f);
			pivotRotationMatrix = GLKMatrix4Rotate(pivotRotationMatrix, GLKMathDegreesToRadians(pivotRotation.x), 1.0f, 0.0f, 0.0f);
		}
		
        GLKVector3 pivot = m_pivot.Vector;
        m_pivotPositition = GLKVector3Make(0.0f, 0.0f, 0.0f);
        m_pivotPositition = GLKVector3Subtract(m_pivotPositition, pivot);
        m_pivotPositition = GLKMatrix4MultiplyVector3(pivotRotationMatrix, m_pivotPositition);
        m_pivotPositition = GLKVector3Add(m_pivotPositition, pivot);
        if(!m_pivot.IsActive && !m_pivotRotation.IsActive) m_recalPivotRotation = false;
        newPos = true;
    }
    
    if(LockLookAt)
    {
        if(m_recalPosition || m_recalLookAt || m_recalViewUp || newPos)
        {
            [m_position Frame:time];
            [m_lookAt Frame:time];
            [m_viewUp Frame:time];
            
            if(!m_pivotRotation.IsActive) m_recalPivotRotation = false;
            
            m_realPosition = GLKVector3Add(m_position.Vector, m_pivotPositition);
            
            GLKVector3 lookat = m_lookAt.Vector;
            GLKVector3 viewup = m_viewUp.Vector;
            
            ViewMatrix = GLKMatrix4MakeLookAt(m_realPosition.x, m_realPosition.y, m_realPosition.z, lookat.x, lookat.y, lookat.z, viewup.x, viewup.y, viewup.z);
            if(!m_position.IsActive) m_recalPosition = false;
            if(!m_lookAt.IsActive) m_recalLookAt = false;
            if(!m_viewUp.IsActive) m_recalViewUp = false;
        }
    }
    else
    {
        if(m_recalPosition || newPos)
        {
            [m_position Frame:time];
            m_realPosition = GLKVector3Add(m_position.Vector, m_pivotPositition);
            m_translationMatrix = GLKMatrix4MakeTranslation(-m_realPosition.x, -m_realPosition.y, -m_realPosition.z);
            if(!m_position.IsActive) m_recalPosition = false;
        }
        
        ViewMatrix = m_translationMatrix;
        
        if(m_recalRotation)
        {
            [m_rotation Frame:time];
            
            GLKVector3 rotation = m_rotation.Vector;
            
            m_rotationMatrix = GLKMatrix4Identity;
            m_rotationMatrix = GLKMatrix4RotateZ(m_rotationMatrix, GLKMathDegreesToRadians(-rotation.z));
            m_rotationMatrix = GLKMatrix4Rotate(m_rotationMatrix, GLKMathDegreesToRadians(-rotation.y), 0.0f, 1.0f, 0.0f);
            m_rotationMatrix = GLKMatrix4Rotate(m_rotationMatrix, GLKMathDegreesToRadians(-rotation.x), 1.0f, 0.0f, 0.0f);
            if(!m_rotation.IsActive) m_recalRotation = false;
        }
        
        ViewMatrix = GLKMatrix4Multiply(m_rotationMatrix, ViewMatrix);
    }
    
}

////////// LookAt /////////////////
- (void)setLookAt:(GLKVector3)lookat
{
    m_lookAt.Vector = lookat;
    m_recalLookAt = true;
}

- (GLKVector3)LookAt
{
    return m_lookAt.Vector;
}

- (void)setLookAtTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_lookAt.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)LookAtTransitionEffect
{
    return m_lookAt.TransitionEffect;
}

- (void)setLookAtTransitionTime:(float)transitiontime
{
    m_lookAt.TransitionTime = transitiontime;
}

- (float)LookAtTransitionTime
{
    return m_lookAt.TransitionTime;
}

- (void)setLookAtTransitionSpeed:(float)transitionspeed
{
    m_lookAt.TransitionSpeed = transitionspeed;
}

- (float)LookAtTransitionSpeed
{
    return m_lookAt.TransitionSpeed;
}

- (void)setLookAtEase:(float)ease
{
    m_lookAt.Ease = ease;
}

- (float)LookAtEase
{
    return m_lookAt.Ease;
}

- (bool)LookAtIsActive
{
    return m_lookAt.IsActive;
}

////////// ViewUp /////////////////
- (void)setViewUp:(GLKVector3)viewup
{
    m_viewUp.Vector = viewup;
    m_recalViewUp = true;
}

- (GLKVector3)ViewUp
{
    return m_viewUp.Vector;
}

- (void)setViewUpTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_viewUp.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)ViewUpTransitionEffect
{
    return m_viewUp.TransitionEffect;
}

- (void)setViewUpTransitionTime:(float)transitiontime
{
    m_viewUp.TransitionTime = transitiontime;
}

- (float)ViewUpTransitionTime
{
    return m_viewUp.TransitionTime;
}

- (void)setViewUpTransitionSpeed:(float)transitionspeed
{
    m_viewUp.TransitionSpeed = transitionspeed;
}

- (float)ViewUpTransitionSpeed
{
    return m_viewUp.TransitionSpeed;
}

- (void)setViewUpEase:(float)ease
{
    m_viewUp.Ease = ease;
}

- (float)ViewUpEase
{
    return m_viewUp.Ease;
}

- (bool)ViewUpIsActive
{
    return m_viewUp.IsActive;
}

- (void)ResetViewUp
{
	[m_viewUp Reset];
}

- (void)ResetViewUp:(GLKVector3)state
{
	[m_viewUp Reset:state];
}

////////// Zoom /////////////////
- (void)setZoom:(float)zoom
{
    m_zoom.Value = zoom;
    m_recalZoom = true;
}

- (float)Zoom
{
    return m_zoom.Value;
}

- (void)setZoomTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_zoom.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)ZoomTransitionEffect
{
    return m_zoom.TransitionEffect;
}

- (void)setZoomTransitionTime:(float)transitiontime
{
    m_zoom.TransitionTime = transitiontime;
}

- (float)ZoomTransitionTime
{
    return m_zoom.TransitionTime;
}

- (void)setZoomTransitionSpeed:(float)transitionspeed
{
    m_zoom.TransitionSpeed = transitionspeed;
}

- (float)ZoomTransitionSpeed
{
    return m_zoom.TransitionSpeed;
}

- (void)setZoomEase:(float)ease
{
    m_zoom.Ease = ease;
}

- (float)ZoomEase
{
    return m_zoom.Ease;
}

- (bool)ZoomIsActive
{
    return m_zoom.IsActive;
}

////////// Near /////////////////
- (void)setNear:(float)near
{
    m_near.Value = near;
    m_recalZoom = true;
}

- (float)Near
{
    return m_near.Value;
}

- (void)setNearTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_near.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)NearTransitionEffect
{
    return m_near.TransitionEffect;
}

- (void)setNearTransitionTime:(float)transitiontime
{
    m_near.TransitionTime = transitiontime;
}

- (float)NearTransitionTime
{
    return m_near.TransitionTime;
}

- (void)setNearTransitionSpeed:(float)transitionspeed
{
    m_near.TransitionSpeed = transitionspeed;
}

- (float)NearTransitionSpeed
{
    return m_near.TransitionSpeed;
}

- (void)setNearEase:(float)ease
{
    m_near.Ease = ease;
}

- (float)NearEase
{
    return m_near.Ease;
}

- (bool)NearIsActive
{
    return m_near.IsActive;
}

////////// Far /////////////////
- (void)setFar:(float)far
{
    m_far.Value = far;
    m_recalZoom = true;
}

- (float)Far
{
    return m_far.Value;
}

- (void)setFarTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_far.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)FarTransitionEffect
{
    return m_far.TransitionEffect;
}

- (void)setFarTransitionTime:(float)transitiontime
{
    m_far.TransitionTime = transitiontime;
}

- (float)FarTransitionTime
{
    return m_far.TransitionTime;
}

- (void)setFarTransitionSpeed:(float)transitionspeed
{
    m_far.TransitionSpeed = transitionspeed;
}

- (float)FarTransitionSpeed
{
    return m_far.TransitionSpeed;
}

- (void)setFarEase:(float)ease
{
    m_far.Ease = ease;
}

- (float)FarEase
{
    return m_far.Ease;
}

- (bool)FarIsActive
{
    return m_far.IsActive;
}

////////// Focus distance /////////////////
- (void)setFocusDistance:(float)dist
{
    m_focusDist.Value = dist;
}

- (float)FocusDistance
{
    return m_focusDist.Value;
}

- (void)setFocusDistanceTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_focusDist.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)FocusDistanceTransitionEffect
{
    return m_focusDist.TransitionEffect;
}

- (void)setFocusDistanceTransitionTime:(float)transitiontime
{
    m_focusDist.TransitionTime = transitiontime;
}

- (float)FocusDistanceTransitionTime
{
    return m_focusDist.TransitionTime;
}

- (void)setFocusDistanceTransitionSpeed:(float)transitionspeed
{
    m_focusDist.TransitionSpeed = transitionspeed;
}

- (float)FocusDistanceTransitionSpeed
{
    return m_focusDist.TransitionSpeed;
}

- (void)setFocusDistanceEase:(float)ease
{
    m_focusDist.Ease = ease;
}

- (float)FocusDistanceEase
{
    return m_focusDist.Ease;
}

- (bool)FocusDistanceIsActive
{
    return m_focusDist.IsActive;
}

////////// Focus range /////////////////
- (void)setm_focusRange:(float)range
{
    m_focusRange.Value = range;
}

- (float)m_focusRange
{
    return m_focusRange.Value;
}

- (void)setm_focusRangeTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
    m_focusRange.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)m_focusRangeTransitionEffect
{
    return m_focusRange.TransitionEffect;
}

- (void)setm_focusRangeTransitionTime:(float)transitiontime
{
    m_focusRange.TransitionTime = transitiontime;
}

- (float)m_focusRangeTransitionTime
{
    return m_focusRange.TransitionTime;
}

- (void)setm_focusRangeTransitionSpeed:(float)transitionspeed
{
    m_focusRange.TransitionSpeed = transitionspeed;
}

- (float)m_focusRangeTransitionSpeed
{
    return m_focusRange.TransitionSpeed;
}

- (void)setm_focusRangeEase:(float)ease
{
    m_focusRange.Ease = ease;
}

- (float)m_focusRangeEase
{
    return m_focusRange.Ease;
}

- (bool)m_focusRangeIsActive
{
    return m_focusRange.IsActive;
}

- (void)setViewWidth:(int)width
{
	if(width == ViewWidth)return;
    ViewWidth = width;
    m_recalZoom = true;
}

- (int)ViewWidth
{
    return ViewWidth;
}

- (void)setViewHeigt:(int)height
{
	if(height == ViewHeigt)return;
    ViewHeigt = height;
    m_recalZoom = true;
}

- (int)ViewHeigt
{
    return ViewHeigt;
}

- (void)setAspect:(float)aspect
{
	if(aspect == Aspect)return;
    Aspect = aspect;
    m_recalZoom = true;
}

- (float)Aspect
{
    return Aspect;
}

@end
