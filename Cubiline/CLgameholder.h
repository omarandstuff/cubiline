#ifndef Cubiline_CLgameholder_h
#define Cubiline_CLgameholder_h

#import "CLlevel.h"
#import "CLtouchable.h"

@interface CLGameHolder : CLTouchable

@property CLLevel* Level;
@property (readonly)VEScene* Scene;
@property bool Exit;

@property VEGameCenter* GameCenter;
@property CLData* GameData;

- (id)initWithRenderBox:(VERenderBox*)renderbox Graphics:(enum CL_GRAPHICS)graphics;
- (void)Frame:(float)time;
- (void)Render;
- (void)Resize;

- (void)Begin;
- (void)OutToMainMenu;
- (bool)OutReady;

@end

#endif
