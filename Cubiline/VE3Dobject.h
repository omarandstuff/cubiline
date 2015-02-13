#ifndef VisualEngine_VE3dobject_h
#define VisualEngine_VE3dobject_h

#import "VEeffect3.h"
#import "VEeffect1.h"

@interface VE3DObject : NSObject
{
    bool m_recalPivotRotation;
    VEEffect3* m_pivot;
    VEEffect3* m_pivotRotation;
    GLKVector3 m_pivotPositition;
    
    GLKVector3 m_realPosition;
    
    GLKMatrix4 m_translationMatrix;
    GLKMatrix4 m_rotationMatrix;
    GLKMatrix4 m_scaleMatrix;
    
	GLKMatrix4 m_finalMatrix;
	
	VEEffect3* m_position;
	VEEffect3* m_rotation;
	VEEffect3* m_scale;
    
    bool m_recalPosition;
    bool m_recalRotation;
    bool m_recalScale;
}

/// Position
@property GLKVector3 Position;
@property enum VE_TRANSITION_EFFECT PositionTransitionEffect;
@property float PositionTransitionTime;
@property float PositionTransitionSpeed;
@property float PositionEase;
@property (readonly) bool PositionIsActive;

- (void)ResetPosition;
- (void)ResetPosition:(GLKVector3)state;

/// Rotation
@property GLKVector3 Rotation;
@property enum VE_TRANSITION_EFFECT RotationTransitionEffect;
@property float RotationTransitionTime;
@property float RotationTransitionSpeed;
@property float RotationEase;
@property (readonly) bool RotationIsActive;

- (void)ResetRotation;
- (void)ResetRotation:(GLKVector3)state;

/// Scale
@property GLKVector3 Scale;
@property enum VE_TRANSITION_EFFECT ScaleTransitionEffect;
@property float ScaleTransitionTime;
@property float ScaleTransitionSpeed;
@property float ScaleEase;
@property (readonly) bool ScaleIsActive;

- (void)ResetScale;
- (void)ResetScale:(GLKVector3)state;


/// Pivot
@property GLKVector3 Pivot;
@property enum VE_TRANSITION_EFFECT PivotTransitionEffect;
@property float PivotTransitionTime;
@property float PivotTransitionSpeed;
@property float PivotEase;
@property (readonly) bool PivotIsActive;

- (void)ResetPivot;
- (void)ResetPivot:(GLKVector3)state;

/// Pivot rotation
@property enum VE_PIVOT_ROTATION PivotRotationStyle;
@property GLKVector3 PivotRotation;
@property enum VE_TRANSITION_EFFECT PivotRotationTransitionEffect;
@property float PivotRotationTransitionTime;
@property float PivotRotationTransitionSpeed;
@property float PivotRotationEase;
@property (readonly) bool PivotRotationIsActive;

- (void)ResetPivotRotation;
- (void)ResetPivotRotation:(GLKVector3)state;

- (void)Frame:(float)time;

@end

#endif
