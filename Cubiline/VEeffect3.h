#ifndef VisualEngine_VEeffect3_h
#define VisualEngine_VEeffect3_h

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "VEcommon.h"

@interface VEEffect3 : NSObject

@property enum VE_TRANSITION_EFFECT TransitionEffect;
@property GLKVector3 Vector;
@property float TransitionTime;
@property float TransitionSpeed;
@property float Ease;
@property (readonly) bool IsActive;

- (void)Frame:(float)time;

- (void)Reset;
- (void)Reset:(GLKVector3)state;

@end

#endif
