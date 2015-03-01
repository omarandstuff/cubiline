#ifndef VisualEngine_VE3gamecenter_h
#define VisualEngine_VE3gamecenter_h

#import <GameKit/GameKit.h>

@interface VEGameCenter : NSObject

@property (readonly)bool PlayerAuthenticated;
@property (readonly)NSString* PlayerID;

@property bool Presenting;

@property (weak)UIViewController* AuthentificationViewController;
@property UIViewController<GKGameCenterControllerDelegate>* MainViewController;

- (void)AuthenticateLocalPlayer;

@end

#endif
