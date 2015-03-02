#import "VE3dobject.h"

@implementation VE3DObject

// Position
@synthesize Position;
@synthesize PositionTransitionEffect;
@synthesize PositionTransitionTime;
@synthesize PositionTransitionSpeed;
@synthesize PositionEase;
@synthesize PositionIsActive;

// Rotation
@synthesize Rotation;
@synthesize RotationTransitionEffect;
@synthesize RotationTransitionTime;
@synthesize RotationTransitionSpeed;
@synthesize RotationEase;
@synthesize RotationIsActive;

// Scale
@synthesize Scale;
@synthesize ScaleTransitionEffect;
@synthesize ScaleTransitionTime;
@synthesize ScaleTransitionSpeed;
@synthesize ScaleEase;
@synthesize ScaleIsActive;

/// Pivot
@synthesize Pivot;
@synthesize PivotTransitionEffect;
@synthesize PivotTransitionTime;
@synthesize PivotTransitionSpeed;
@synthesize PivotEase;
@synthesize PivotIsActive;

/// Pivot rotation
@synthesize PivotRotationStyle;
@synthesize PivotRotation;
@synthesize PivotRotationTransitionEffect;
@synthesize PivotRotationTransitionTime;
@synthesize PivotRotationTransitionSpeed;
@synthesize PivotRotationEase;
@synthesize PivotRotationIsActive;

- (id)init
{
	self = [super init];
	
	if(self)
	{
		m_pivot = [[VEEffect3 alloc] init];
		m_pivotRotation = [[VEEffect3 alloc] init];
		m_position = [[VEEffect3 alloc] init];
		m_rotation = [[VEEffect3 alloc] init];
		m_scale = [[VEEffect3 alloc] init];
		
		m_rotationMatrix = GLKMatrix4Identity;
		m_translationMatrix = GLKMatrix4Identity;
		m_scaleMatrix = GLKMatrix4Identity;
		
		m_recalScale = false;
		m_recalPosition = false;
		m_recalRotation = false;
		
		m_recalPivotRotation = false;
		
		PivotRotationStyle = VE_PIVOT_ROTATION_ZYX;
	}
	
	return self;
}

- (void)Frame:(float)time
{
	if(!m_recalPivotRotation && !m_recalPosition && !m_recalRotation && !m_recalScale) return;
	
    bool newPos = false;
	if(m_recalPivotRotation)
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
	
	if(m_recalScale)
	{
		[m_scale Frame:time];
		GLKVector3 scale = m_scale.Vector;
		m_scaleMatrix = GLKMatrix4MakeScale(scale.x, scale.y, scale.z);
        if(!m_scale.IsActive) m_recalScale = false;
	}
	
	m_finalMatrix = m_scaleMatrix;

	if(m_recalRotation)
	{
		[m_rotation Frame:time];
		
		GLKVector3 rotation = m_rotation.Vector;
		
		m_rotationMatrix = GLKMatrix4Identity;
		m_rotationMatrix = GLKMatrix4RotateZ(m_rotationMatrix, GLKMathDegreesToRadians(rotation.z));
		m_rotationMatrix = GLKMatrix4Rotate(m_rotationMatrix, GLKMathDegreesToRadians(rotation.y), 0.0f, 1.0f, 0.0f);
		m_rotationMatrix = GLKMatrix4Rotate(m_rotationMatrix, GLKMathDegreesToRadians(rotation.x), 1.0f, 0.0f, 0.0f);
        if(!m_rotation.IsActive) m_recalRotation = false;
	}
	
	m_finalMatrix = GLKMatrix4Multiply(m_rotationMatrix, m_finalMatrix);
	
	if(m_recalPosition || newPos)
	{
		[m_position Frame:time];
		m_realPosition = GLKVector3Add(m_position.Vector, m_pivotPositition);
		m_translationMatrix = GLKMatrix4MakeTranslation(m_realPosition.x, m_realPosition.y, m_realPosition.z);
        if(!m_position.IsActive) m_recalPosition = false;
	}
	
	m_finalMatrix = GLKMatrix4Multiply(m_translationMatrix, m_finalMatrix);
}

////////// Position /////////////////
- (void)setPosition:(GLKVector3)position
{
	m_position.Vector = position;
	m_recalPosition = true;
}

- (GLKVector3)Position
{
	return m_realPosition;
}

- (GLKVector3)PositionWOR
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

////////// Rotation /////////////////
- (void)setRotation:(GLKVector3)rotation
{
	m_rotation.Vector = rotation;
	m_recalRotation = true;
}

- (GLKVector3)Rotation
{
	return m_rotation.Vector;
}

- (void)setRotationTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
	m_rotation.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)RotationTransitionEffect
{
	return m_rotation.TransitionEffect;
}

- (void)setRotationTransitionTime:(float)transitiontime
{
	m_rotation.TransitionTime = transitiontime;
}

- (float)RotationTransitionTime
{
	return m_rotation.TransitionTime;
}

- (void)setRotationTransitionSpeed:(float)transitionspeed
{
	m_rotation.TransitionSpeed = transitionspeed;
}

- (float)RotationTransitionSpeed
{
	return m_rotation.TransitionSpeed;
}

- (void)setRotationEase:(float)ease
{
	m_rotation.Ease = ease;
}

- (float)RotationEase
{
	return m_rotation.Ease;
}

- (bool)RotationIsActive
{
	return m_rotation.IsActive;
}

- (void)ResetRotation
{
    [m_rotation Reset];
    m_recalRotation = true;
}

- (void)ResetRotation:(GLKVector3)state
{
    [m_rotation Reset:state];
    m_recalRotation = true;
}

////////// Scale /////////////////
- (void)setScale:(GLKVector3)scale
{
	m_scale.Vector = scale;
	m_recalScale = true;
}

- (GLKVector3)Scale
{
	return m_scale.Vector;
}

- (void)setScaleTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
	m_scale.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)ScaleTransitionEffect
{
	return m_scale.TransitionEffect;
}

- (void)setScaleTransitionTime:(float)transitiontime
{
	m_scale.TransitionTime = transitiontime;
}

- (float)ScaleTransitionTime
{
	return m_scale.TransitionTime;
}

- (void)setScaleTransitionSpeed:(float)transitionspeed
{
	m_scale.TransitionSpeed = transitionspeed;
}

- (float)ScaleTransitionSpeed
{
	return m_scale.TransitionSpeed;
}

- (void)setScaleEase:(float)ease
{
	m_scale.Ease = ease;
}

- (float)ScaleEase
{
	return m_scale.Ease;
}

- (bool)ScaleIsActive
{
	return m_scale.IsActive;
}

- (void)ResetScale
{
    [m_scale Reset];
    m_recalScale = true;
}

- (void)ResetScale:(GLKVector3)state
{
    [m_scale Reset:state];
    m_recalScale = true;
}

/////////// Pivot //////////////////
- (void)setPivot:(GLKVector3)pivot
{
	m_pivot.Vector = pivot;
    m_recalPivotRotation = true;
}

- (GLKVector3)Pivot
{
	return m_pivot.Vector;
}

- (void)setPivotTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
	m_pivot.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)PivotTransitionEffect
{
	return m_pivot.TransitionEffect;
}

- (void)setPivotTransitionTime:(float)transitiontime
{
	m_pivot.TransitionTime = transitiontime;
}

- (float)PivotTransitionTime
{
	return m_pivot.TransitionTime;
}

- (void)setPivotTransitionSpeed:(float)transitionspeed
{
	m_pivot.TransitionSpeed = transitionspeed;
}

- (float)PivotTransitionSpeed
{
	return m_pivot.TransitionSpeed;
}

- (void)setPivotEase:(float)ease
{
	m_pivot.Ease = ease;
}

- (float)PivotEase
{
	return m_pivot.Ease;
}

- (bool)PivotIsActive
{
	return m_pivot.IsActive;
}

- (void)ResetPivot
{
	[m_pivot Reset];
}

- (void)ResetPivot:(GLKVector3)state
{
	[m_pivot Reset:state];
}

/////// Pivot rotation ///////////////
- (void)setPivotRotation:(GLKVector3)pivotrotation
{
	m_pivotRotation.Vector = pivotrotation;
	m_recalPivotRotation = true;
}

- (GLKVector3)PivotRotation
{
	return m_pivotRotation.Vector;
}

- (GLKVector3)TargetPivotRotation
{
	return m_pivotRotation.TargetVector;
}

- (void)setPivotRotationTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
	m_pivotRotation.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)PivotRotationTransitionEffect
{
	return m_pivotRotation.TransitionEffect;
}

- (void)setPivotRotationTransitionTime:(float)transitiontime
{
	m_pivotRotation.TransitionTime = transitiontime;
}

- (float)PivotRotationTransitionTime
{
	return m_pivotRotation.TransitionTime;
}

- (void)setPivotRotationTransitionSpeed:(float)transitionspeed
{
	m_pivotRotation.TransitionSpeed = transitionspeed;
}

- (float)PivotRotationTransitionSpeed
{
	return m_pivotRotation.TransitionSpeed;
}

- (void)setPivotRotationEase:(float)ease
{
	m_pivotRotation.Ease = ease;
}

- (float)PivotRotationEase
{
	return m_pivotRotation.Ease;
}

- (bool)PivotRotationIsActive
{
	return m_pivotRotation.IsActive;
}

- (void)ResetPivotRotation
{
    [m_pivotRotation Reset];
}

- (void)ResetPivotRotation:(GLKVector3)state
{
    [m_pivotRotation Reset:state];
}

@end
