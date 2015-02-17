#ifndef Cubiline_GCHelper_h
#define Cubiline_GCHelper_h

@import GameKit;

extern NSString *const PresentAuthenticationViewController;
extern NSString *const LocalPlayerIsAuthenticated;

@protocol GameKitHelperDelegate
- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
- (void)onScoresSubmitted:(bool)success;
@end

@interface GameKitHelper : NSObject<GKMatchmakerViewControllerDelegate, GKMatchDelegate>

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

@property (nonatomic, strong) GKMatch *match;
@property (nonatomic, assign) id <GameKitHelperDelegate> delegate;

@property (readonly) bool LoggedIn;

@property (readonly)int HighScore;
@property (readonly)int TotalEaten;
@property (readonly)bool TotalEatenLoaded;

@property UIViewController<GKGameCenterControllerDelegate>* MainGameCenterView;

+ (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GameKitHelperDelegate>)delegate;

- (void)submitScore:(int64_t)score category:(NSString*)category;
- (void)GetHighScore;
- (void)GetTotalEaten;

- (void)presentGameCenter;

@end

#endif
