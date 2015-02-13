#ifndef VisualEngine_VEtimer_h
#define VisualEngine_VEtimer_h

#import <UIKit/UIKit.h>

@interface VETimer : NSObject

@property float PlaybackSpeed;
@property (readonly) float LastUpdateTime;

- (void)Frame:(float)time;

@end

#endif
