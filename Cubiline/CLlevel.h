#ifndef Cubiline_CLLevel_h
#define Cubiline_CLLevel_h

#import "CLbody.h"

@interface CLLevel : NSObject

@property VEModel* Leader;
@property VEModel* Food;
@property NSMutableArray* Body;
@property VEModel* FrontWall;
@property VEModel* BackWall;
@property VEModel* RightWall;
@property VEModel* LeftWall;
@property VEModel* TopWall;
@property VEModel* BottomWall;
@property VELight* TopLight;
@property VELight* BottomLight;
@property VEScene* Scene;

@property enum CL_SIZE Size;
@property enum CL_SIZE Speed;
@property (readonly)enum CL_ZONE Zone;
@property (readonly)enum CL_ZONE Direction;

@property GLKVector3 BodyColor;

- (id)initWithRenderBox:(VERenderBox*)renderbox;
- (void)Frame:(float)time;
- (void)Reset;
- (void)ResetInZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;
- (void)FocusLeaderInCamera:(VECamera*)camera;
- (void)AddBodyWithSize:(float)size;

@end

#endif
