#import "VEgamecenter.h"

@interface VEGameCenter()
{
	
}

@end

@implementation VEGameCenter

@synthesize PlayerAuthenticated;
@synthesize PlayerID;

@synthesize Presenting;
@synthesize AuthentificationViewController;
@synthesize MainViewController;


- (void) AuthenticateLocalPlayer
{
	GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];

	localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
	{
		if(viewController != nil)
		{
			AuthentificationViewController = viewController;
			[MainViewController presentViewController:viewController animated:YES completion:nil];
		}
		else if([GKLocalPlayer localPlayer].isAuthenticated)
		{
			PlayerAuthenticated = true;
			PlayerID = [GKLocalPlayer localPlayer].playerID;
		}
		else
			PlayerAuthenticated = true;
	};
}

@end