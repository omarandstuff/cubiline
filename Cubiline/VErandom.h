#ifndef VisualEngine_VErandom_h
#define VisualEngine_VErandom_h

#import <UIKit/UIKit.h>

@interface VERandom : NSObject;

- (float)NextNormalized;
- (float)NextFloatWithMin:(float)min Max:(float)max;
- (int)NextIntegerWithMin:(int)min Max:(int)max;

@end

#endif
