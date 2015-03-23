#ifndef Cubiline_CLtouchable_h
#define Cubiline_CLtouchable_h

#import <UIKit/UIKit.h>

@interface CLTouchable : NSObject
- (void)TouchPanBegan:(float)x Y:(float)y Fingers:(int)fingers;
- (void)TouchPanChange:(float)x Y:(float)y Fingers:(int)fingers;
- (void)TouchPanEnd:(float)x Y:(float)y Fingers:(int)fingers;
- (void)TouchTap:(float)x Y:(float)y Fingers:(int)fingers Taps:(int)taps;
- (void)TouchDown:(float)x Y:(float)y Fingers:(int)fingers;
- (void)TouchUp:(float)x Y:(float)y Fingers:(int)fingers;
@end

#endif
