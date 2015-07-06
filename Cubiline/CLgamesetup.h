#ifndef Cubiline_CLgamesetup_h
#define Cubiline_CLgamesetup_h

#import "CLlevel.h"
#import "CLtouchable.h"

@interface CLGameSetpUp : CLTouchable<SKPaymentTransactionObserver>

@property CLLevel* Level;
@property (readonly)VEScene* Scene;
@property CLData* GameData;

- (id)initWithRenderBox:(VERenderBox*)renderbox Graphics:(enum CL_GRAPHICS)graphics;
- (void)Frame:(float)time;
- (void)Render;
- (void)Resize;

- (void)InToSetUp;
- (void)Begin:(bool)forced;

- (bool)Ready;

- (void)OutToPlay;
- (bool)OutReady;

@end

#endif
