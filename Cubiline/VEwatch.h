#ifndef VisualEngine_VEwatch_h
#define VisualEngine_VEwatch_h

#import <UIKit/UIKit.h>
#import "VEcommon.h"

@interface VEWatch : NSObject

@property enum VE_WATCH_STYLE Style;
@property bool Active;


- (bool)Frame:(float)time;

- (void)Reset;
- (void)ResetInCentseconds:(float)centeseconds;
- (void)ResetInSeconds:(float)seconds;
- (void)ResetInMinutes:(float)minutes;
- (void)ResetInHours:(float)hours;

- (void)SetLimitInCentseconds:(float)centseconds;
- (void)SetLimitInSeconds:(float)seconds;
- (void)SetLimitInMinutes:(float)minutes;
- (void)SetLimitInHours:(float)hours;

- (NSString*)GetTimeString:(enum VE_WATCH_STRING_FORMAT)format;

- (float)GetTotalTimeinCentseconds;
- (float)GetTotalTimeinSeconds;
- (float)GetTotalTimeinMinutes;
- (float)GetTotalTimeinHours;

@end

#endif
