#ifndef Cubiline_CLcubilinegame_h
#define Cubiline_CLcubilinegame_h

#import "CLlevel.h"
#import "CLtouchable.h"

@interface Slot : NSObject
@property enum CL_ZONE Zone;
@property int CoordX;
@property int CoordY;
@property bool inZone;
@end

@interface CLCubilineGame : CLTouchable

@property CLLevel* Level;
@property VEScene* Scene;

- (id)initWithRenderBox:(VERenderBox*)renderbox;

- (void)Frame:(float)time;
- (void)Render;
- (void)Resize;

- (void)Begin;

@end

#endif
