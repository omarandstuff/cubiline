#ifndef Cubiline_mainmenu_h
#define Cubiline_mainmenu_h

#import "CLcommon.h"
#import "CLtouchable.h"

@interface CLMainMenu : CLTouchable

@property VEScene* Scene;
@property VECamera* Camera;
@property enum CL_MAIN_MENU_SELECTION Selection;

- (id)initWithRenderBox:(VERenderBox*)renderbox;

- (void)Frame:(float)time;
- (void)Resize;
- (void)Render;

- (bool)Selected;

- (void)OutToPlay;
- (bool)OutReady;

- (void)Reset;

@end

#endif
