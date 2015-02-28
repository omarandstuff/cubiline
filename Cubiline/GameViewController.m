#import "GameViewController.h"

@interface GameViewController()
{
	EAGLContext* m_context;
	CLGame* m_game;
	VERenderBox* m_renderBox;
    VEAudioBox* m_audioBox;
	VETimer* m_timer;
	
	float m_multipler;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Multipler
	m_multipler = 2.0f;
	
	// Create the context object
	m_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	
	// Gestures
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(PanHandler:)];
	[self.view addGestureRecognizer:panRecognizer];
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapHandler:)];
	[self.view addGestureRecognizer:tapRecognizer];
	
	UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressHandler:)];
	longPressRecognizer.minimumPressDuration = 0.0f;
	longPressRecognizer.allowableMovement = 20.0f;
	[self.view addGestureRecognizer:longPressRecognizer];

	
	panRecognizer.delegate = self;
	longPressRecognizer.delegate = self;
	
	// Set the view
	GLKView *view = (GLKView *)self.view;
	view.context = m_context;
	view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
	view.contentScaleFactor = m_multipler;
	
	//Create the timer object.
	m_timer = [[VETimer alloc] init];
	
	// Create the renderbox object.
	m_renderBox = [[VERenderBox alloc] initWithContext:m_context GLKView:view Timer:m_timer Width:self.view.bounds.size.width * m_multipler Height:self.view.bounds.size.height * m_multipler];
    
    // Create the audiobox object.
	m_audioBox = [[VEAudioBox alloc] init];
	
	// Audio Session
	BOOL success = [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
 
	if (!success)
		NSLog(@"Audio session failed.");

	
	//Create the game place.
	m_game = [[CLGame alloc] initWithRenderBox:m_renderBox AudioBox:m_audioBox];
	
	[m_renderBox Frame:0.0f];
	[m_game Frame:0.0f];
	[m_renderBox Render];
	
	[m_renderBox Play];
	[m_game Play];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticationViewController) name:PresentAuthenticationViewController object:nil];
 
	[[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
	
	[GameKitHelper sharedGameKitHelper].MainGameCenterView = self;
}

- (void)showAuthenticationViewController
{
	GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
 
	[self presentViewController: gameKitHelper.authenticationViewController animated:YES completion:nil];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
	[self dismissViewControllerAnimated:YES completion:nil];
	[m_renderBox Play];
	[m_game Play];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	
	if ([self isViewLoaded] && ([[self view] window] == nil))
		self.view = nil;
}

- (void)viewDidLayoutSubviews
{
    // Resize the grphics.
	m_renderBox.ScreenWidth = self.view.bounds.size.width * m_multipler;
	m_renderBox.ScreenHeight = self.view.bounds.size.height * m_multipler;
    [m_renderBox Resize];
    
    // Resize the game.
	[m_game Resize];
}

- (void)update
{
	// Update the timer to adjust the time we wnat to use.
	[m_timer Frame:self.timeSinceLastUpdate];
	
    //Update graphics
    [m_renderBox Frame:m_timer.LastUpdateTime];
    
    //Update audio
    [m_audioBox Frame:m_timer.LastUpdateTime];
    
	// Update the game.
	[m_game Frame:m_timer.LastUpdateTime];
}

- (void)glkView:(GLKView*)view drawInRect:(CGRect)rect
{
	// Render in game.
	[m_game Render];
    
    // Render to the Screen.
    [m_renderBox Render];
}

- (void)PanHandler:(UIPanGestureRecognizer*)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    float x = translation.x * m_multipler;
    float y = translation.y * m_multipler;

    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
        [m_game TouchPanBegan:x Y:y Fingers:(int)gestureRecognizer.numberOfTouches];
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
        [m_game TouchPanChange:x Y:y Fingers:(int)gestureRecognizer.numberOfTouches];
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
        [m_game TouchPanEnd:x Y:y Fingers:(int)gestureRecognizer.numberOfTouches];
}

- (void)TapHandler:(UITapGestureRecognizer*)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    float x = point.x * m_multipler;
    float y = point.y * m_multipler;
	
	[m_game TouchTap:x Y:y Fingers:(int)gestureRecognizer.numberOfTouches];
}

- (void)LongPressHandler:(UILongPressGestureRecognizer*)gestureRecognizer
{
	CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
	float x = point.x * m_multipler;
	float y = point.y * m_multipler;
	
	if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
		[m_game TouchDown:x Y:y Fingers:(int)gestureRecognizer.numberOfTouches];
	else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
		[m_game TouchUp:x Y:y Fingers:(int)gestureRecognizer.numberOfTouches];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}


@end
