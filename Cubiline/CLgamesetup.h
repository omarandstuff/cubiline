#ifndef Cubiline_CLgamesetup_h
#define Cubiline_CLgamesetup_h

#import "CLlevel.h"
#import "CLtouchable.h"

@interface CLGameSetpUp : CLTouchable

@property CLLevel* Level;
@property (readonly)VEScene* Scene;

- (id)initWithRenderBox:(VERenderBox*)renderbox Background:(VESprite*)background Graphics:(enum CL_GRAPHICS)graphics;
- (void)Frame:(float)time;
- (void)Render;
- (void)Resize;

- (void)InToSetUp;
- (void)Begin;

- (bool)Ready;

- (void)OutToPlay;
- (bool)OutReady;

@end

#endif
