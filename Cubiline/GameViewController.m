#import "GameViewController.h"

@interface GameViewController()
{
	EAGLContext* m_context;
	CLGame* m_game;
	VERenderBox* m_renderBox;
    VEAudioBox* m_audioBox;
	VEGameCenter* m_gameCenter;
	VETimer* m_timer;
	
	float m_multipler;
}

- (NSString*)deviceCategory;

@end

@implementation GameViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Multipler screen resolution base device.
	NSString* deviceCategory = [self deviceCategory];
	if([deviceCategory isEqualToString:@"very low"])
		m_multipler = 1.8f;
	else
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
	
	// Create the Game Center manager object.
	m_gameCenter = [[VEGameCenter alloc] init];
	m_gameCenter.MainViewController = self;
	
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
	if([deviceCategory isEqualToString:@"very low"])
		m_game = [[CLGame alloc] initWithRenderBox:m_renderBox AudioBox:m_audioBox GameCenter:m_gameCenter Graphics:CL_GRAPHICS_VERYLOW];
	else if([deviceCategory isEqualToString:@"low"])
		m_game = [[CLGame alloc] initWithRenderBox:m_renderBox AudioBox:m_audioBox GameCenter:m_gameCenter Graphics:CL_GRAPHICS_LOW];
	else if([deviceCategory isEqualToString:@"medium"])
		m_game = [[CLGame alloc] initWithRenderBox:m_renderBox AudioBox:m_audioBox GameCenter:m_gameCenter Graphics:CL_GRAPHICS_MEDIUM];
	else
		m_game = [[CLGame alloc] initWithRenderBox:m_renderBox AudioBox:m_audioBox GameCenter:m_gameCenter Graphics:CL_GRAPHICS_HIGH];

	
	[m_renderBox Frame:0.0f];
	[m_game Frame:0.0f];
	[m_renderBox Render];
}

- (NSString*)deviceCategory;
{
	struct utsname systemInfo;
	uname(&systemInfo);
	
	NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

	NSDictionary *commonNamesDictionary =
	@{
	  @"i386":     @"low",
	  @"x86_64":   @"low",
	  
	  @"iPhone1,1":    @"very low",
	  @"iPhone1,2":    @"very low",
	  @"iPhone2,1":    @"very low",
	  @"iPhone3,1":    @"very low",
	  @"iPhone3,2":    @"very low",
	  @"iPhone3,3":    @"very low",
	  @"iPhone4,1":    @"low",
	  @"iPhone5,1":    @"medium",
	  @"iPhone5,2":    @"medium",
	  @"iPhone5,3":    @"medium",
	  @"iPhone5,4":    @"medium",
	  @"iPhone6,1":    @"high",
	  @"iPhone6,2":    @"high",
	  
	  @"iPhone7,1":    @"high",
	  @"iPhone7,2":    @"high",
	  
	  @"iPad1,1":  @"very low",
	  @"iPad2,1":  @"low",
	  @"iPad2,2":  @"low",
	  @"iPad2,3":  @"low",
	  @"iPad2,4":  @"low",
	  @"iPad2,5":  @"low",
	  @"iPad2,6":  @"low",
	  @"iPad2,7":  @"low",
	  @"iPad3,1":  @"medium",
	  @"iPad3,2":  @"medium",
	  @"iPad3,3":  @"medium",
	  @"iPad3,4":  @"high",
	  @"iPad3,5":  @"high",
	  @"iPad3,6":  @"high",
	  
	  @"iPad4,1":  @"high",
	  @"iPad4,2":  @"high",
	  @"iPad4,3":  @"high",
	  
	  @"iPad4,4":  @"high",
	  @"iPad4,5":  @"high",
	  @"iPad4,6":  @"high",
	  
	  @"iPod1,1":  @"very low",
	  @"iPod2,1":  @"very low",
	  @"iPod3,1":  @"very low",
	  @"iPod4,1":  @"low",
	  @"iPod5,1":  @"medium",
	  
   };
	
	NSString *deviceName = commonNamesDictionary[machineName];
	
	if (deviceName == nil) {
		deviceName = machineName;
	}
	
	return deviceName;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[m_gameCenter AuthenticateLocalPlayer];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
	[self dismissViewControllerAnimated:YES completion:nil];
	m_gameCenter.Presenting = false;
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
	// The authentification View Controller is presented.
	if(m_gameCenter.AuthentificationViewController != nil || m_gameCenter.Presenting) return;
	
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
