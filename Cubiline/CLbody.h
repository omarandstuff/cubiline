#ifndef Cubiline_CLbody_h
#define Cubiline_CLbody_h

#import "CLcommon.h"

@interface CLBody : NSObject

@property VEModel* Model;
@property (readonly) enum CL_ZONE Zone;
@property (readonly) enum CL_ZONE Direction;

- (id)initWithRenderBox:(VERenderBox*)renderbox Scene:(VEScene*)scene Zone:(enum CL_ZONE)zone Direction:(enum CL_ZONE)direction BornPosition:(GLKVector3)bornposition Size:(float)size Color:(GLKVector3)color;

- (float)Grow:(float)delta;
- (void)Snap;

@end

#endif
