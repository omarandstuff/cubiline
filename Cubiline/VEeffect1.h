#ifndef VisualEngine_VEeffect1_h
#define VisualEngine_VEeffect1_h

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "VEcommon.h"

@interface VEEffect1 : NSObject

@property enum VE_TRANSITION_EFFECT TransitionEffect;
@property float Value;
@property float TransitionTime;
@property float TransitionSpeed;
@property float Ease;
@property (readonly) bool IsActive;

- (void)Frame:(float)time;

- (void)Reset;
- (void)Reset:(float)state;

@end

#endif
