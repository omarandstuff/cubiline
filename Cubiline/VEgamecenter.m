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

@synthesize LoadedScores;

- (id)init
{
	self = [super init];
	
	if(self)
	{
		LoadedScores = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

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
			[LoadedScores removeAllObjects];
		}
		else
			PlayerAuthenticated = true;
	};
}

- (void)presentGameCenter
{
	GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
	if (gameCenterController != nil)
	{
		gameCenterController.gameCenterDelegate = MainViewController;
		[MainViewController presentViewController: gameCenterController animated: YES completion:nil];
		Presenting = true;
	}
}

- (void)submitScore:(int64_t)score category:(NSString*)category
{
	if (!PlayerAuthenticated)
	{
		//NSLog(@"Player not authenticated");
		return;
	}
 
	GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
	scoreReporter.value = score;
	scoreReporter.context = 0;
 
	[scoreReporter reportScoreWithCompletionHandler:^(NSError *error)
	 {
		 // Do something interesting here.
	 }];
}

- (void)loadScoreOfCategory:(NSString*)category
{
	if (!PlayerAuthenticated)
	{
		//NSLog(@"Player not authenticated");
		return;
	}
	
	GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
	if (leaderboardRequest != nil)
	{
		leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
		leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardRequest.identifier = category;
		leaderboardRequest.range = NSMakeRange(1,1);
		[leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error)
		{
			if (error != nil)
			{
				// Handle the error.
			}
			if (scores != nil)
			{
				[LoadedScores setValue:[NSNumber numberWithInteger:(int)leaderboardRequest.localPlayerScore.value] forKey:category];
			}
		}];
	}
}

@end