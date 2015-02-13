#ifndef Cubiline_CLgame_h
#define Cubiline_CLgame_h

#import "CLmainmenu.h"
#import "CLgamesetup.h"
#import "CLcubilinegame.h"

@interface CLGame : NSObject

- (void)TouchPanBegan:(float)x Y:(float)y Fingers:(int)fingers;
- (void)TouchPanChange:(float)x Y:(float)y Fingers:(int)fingers;
- (void)TouchPanEnd:(float)x Y:(float)y Fingers:(int)fingers;

- (void)TouchTap:(float)x Y:(float)y Fingers:(int)fingers;

- (void)TouchDown:(float)x Y:(float)y Fingers:(int)fingers;
- (void)TouchUp:(float)x Y:(float)y Fingers:(int)fingers;

- (id)initWithRenderBox:(VERenderBox*)renderbox AudioBox:(VEAudioBox*)audiobox;
- (void)Frame:(float)time;
- (void)Render;
- (void)Resize;
@end

#endif
