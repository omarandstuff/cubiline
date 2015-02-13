#import "GCHelper.h"

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";
NSString *const LocalPlayerIsAuthenticated = @"local_player_authenticated";

@implementation GameKitHelper
{
	BOOL _enableGameCenter;
	BOOL _matchStarted;
}

+ (instancetype)sharedGameKitHelper
{
	static GameKitHelper *sharedGameKitHelper;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedGameKitHelper = [[GameKitHelper alloc] init];
	});
	return sharedGameKitHelper;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		_enableGameCenter = YES;
	}
	return self;
}

- (void)authenticateLocalPlayer
{
	GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
	
	if (localPlayer.isAuthenticated)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:LocalPlayerIsAuthenticated object:nil];
		return;
	}
	localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
	{
		[self setLastError:error];
		
		if(viewController != nil)
		{
			[self setAuthenticationViewController:viewController];
		}
		else if([GKLocalPlayer localPlayer].isAuthenticated)
		{
			_enableGameCenter = YES;
			[[NSNotificationCenter defaultCenter] postNotificationName:LocalPlayerIsAuthenticated object:nil];
		}
		else
		{
			_enableGameCenter = NO;
		}
	};
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController
{
	if (authenticationViewController != nil)
	{
		_authenticationViewController = authenticationViewController;
		[[NSNotificationCenter defaultCenter] postNotificationName:PresentAuthenticationViewController object:self];
	}
}

- (void)setLastError:(NSError *)error
{
	_lastError = [error copy];
	if (_lastError)
	{
		NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo] description]);
	}
	
}

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GameKitHelperDelegate>)delegate
{
	if (!_enableGameCenter) return;
	
	_matchStarted = NO;
	self.match = nil;
	_delegate = delegate;
	[viewController dismissViewControllerAnimated:NO completion:nil];
	
	GKMatchRequest *request = [[GKMatchRequest alloc] init];
	request.minPlayers = minPlayers;
	request.maxPlayers = maxPlayers;
	
	GKMatchmakerViewController *mmvc =
	[[GKMatchmakerViewController alloc] initWithMatchRequest:request];
	mmvc.matchmakerDelegate = self;
	
	[viewController presentViewController:mmvc animated:YES completion:nil];
}

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
	[viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
	[viewController dismissViewControllerAnimated:YES completion:nil];
	NSLog(@"Error finding match: %@", error.localizedDescription);
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
	[viewController dismissViewControllerAnimated:YES completion:nil];
	self.match = match;
	match.delegate = self;
	if (!_matchStarted && match.expectedPlayerCount == 0)
	{
		NSLog(@"Ready to start match!");
	}
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
	if (_match != match) return;
	[_delegate match:match didReceiveData:data fromPlayer:playerID];
}

- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
	if (_match != match) return;
	switch (state) {
		case GKPlayerStateUnknown:
		{
			
		}
		case GKPlayerStateConnected:
			NSLog(@"Player connected!");
			
			if (!_matchStarted && match.expectedPlayerCount == 0)
			{
				NSLog(@"Ready to start match!");
			}
			
			break;
		case GKPlayerStateDisconnected:
			NSLog(@"Player disconnected!");
			_matchStarted = NO;
			[_delegate matchEnded];
			break;
	}
}

- (void)match:(GKMatch *)match connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error
{
	
	if (_match != match) return;
	NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
	_matchStarted = NO;
	[_delegate matchEnded];
}

- (void)match:(GKMatch *)match didFailWithError:(NSError *)error
{
	
	if (_match != match) return;
	NSLog(@"Match failed with error: %@", error.localizedDescription);
	_matchStarted = NO;
	[_delegate matchEnded];
}

@end