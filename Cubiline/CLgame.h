#ifndef Cubiline_CLgame_h
#define Cubiline_CLgame_h

#import "CLmainmenu.h"
#import "CLgamesetup.h"
#import "CLgameholder.h"

@interface CLGame : CLTouchable

@property (readonly)bool Adiable;

- (id)initWithRenderBox:(VERenderBox*)renderbox GameCenter:(VEGameCenter *)gamecenter Graphics:(enum CL_GRAPHICS)graphics;
- (void)Frame:(float)time;
- (void)Render;
- (void)Resize;

- (void)Pause;

@end

#endif
