#ifndef Cubiline_mainmenu_h
#define Cubiline_mainmenu_h

#import "CLcommon.h"
#import "CLtouchable.h"

@interface CLMainMenu : CLTouchable

@property VEScene* Scene;
@property VECamera* Camera;
@property enum CL_MAIN_MENU_SELECTION Selection;

@property VEGameCenter* GameCenter;

- (id)initWithRenderBox:(VERenderBox*)renderbox Background:(VESprite*)background Graphics:(enum CL_GRAPHICS)graphics;

- (void)Frame:(float)time;
- (void)Resize;
- (void)Render;

- (bool)Selected;

- (void)InFromPlaying;

- (void)OutToPlay;
- (bool)OutReady;

- (void)Reset;

- (void)About;

@end

#endif
