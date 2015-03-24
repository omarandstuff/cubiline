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
	
	AppDelegate* m_appDelegate;
	
	
	/// iAds
	ADBannerView *m_adBanner;
	bool m_bannerPresented;
	bool m_bannerLoaded;
	bool m_bannerInteracting;
	bool m_bannerAllowed;
	
	NSString* m_device;
}

- (NSString*)deviceCategory;
- (NSString*)deviceModelName;

- (void)PresentBanner;
- (void)GetBannerOnScreen;
- (void)GetBannerOffScreen;
- (void)RemoveBanner;
- (CGRect)RectForBanner;

@end

@implementation GameViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// App delegate
	m_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// Multipler screen resolution base device.
	NSString* deviceCategory = [self deviceCategory];
	m_device = [self deviceModelName];

	if([deviceCategory isEqualToString:@"very low"])
		m_multipler = 1.0f;
	else if([deviceCategory isEqualToString:@"low"])
		m_multipler = 2.0f;
	else if([deviceCategory isEqualToString:@"medium"])
		m_multipler = 2.0f;
	else
		m_multipler = 3.0f;
	
	
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
	
	UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapHandler:)];
	doubleTapRecognizer.numberOfTapsRequired = 2;
	[self.view addGestureRecognizer:doubleTapRecognizer];

	
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
	
	m_renderBox.DeviceType = m_device;
    
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

	// Delegate
	m_appDelegate.Game = m_game;
	
	[m_timer Frame:1.0f];
	[m_renderBox Frame:m_timer.LastUpdateTime];
	[m_audioBox Frame:m_timer.LastUpdateTime];
	[m_game Frame:m_timer.LastUpdateTime];
	[m_game Render];
	[m_renderBox Render];
}

- (NSString*)deviceCategory;
{
	struct utsname systemInfo;
	uname(&systemInfo);
	
	NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

	NSDictionary *commonNamesDictionary =
	@{
	  @"i386":     @"very low",
	  @"x86_64":   @"very low",
	  
	  @"iPhone1,1":    @"very low",
	  @"iPhone1,2":    @"very low",
	  @"iPhone2,1":    @"very low",
	  @"iPhone3,1":    @"low",
	  @"iPhone3,2":    @"low",
	  @"iPhone3,3":    @"low",
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
	
	if (deviceName == nil)
	{
		deviceName = machineName;
	}
	
	return deviceName;
}

- (NSString*)deviceModelName
{
	struct utsname systemInfo;
	uname(&systemInfo);
	NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	NSDictionary *commonNamesDictionary =
  @{
	@"i386":     @"iPhone",
	@"x86_64":   @"iPad",
	
	@"iPhone1,1":    @"iPhone",
	@"iPhone1,2":    @"iPhone",
	@"iPhone2,1":    @"iPhone",
	@"iPhone3,1":    @"iPhone",
	@"iPhone4,1":    @"iPhone",
	@"iPhone5,1":    @"iPhone",
	@"iPhone5,2":    @"iPhone",
	
	@"iPad1,1":  @"iPad",
	@"iPad2,1":  @"iPad",
	@"iPad2,2":  @"iPad",
	@"iPad2,3":  @"iPad",
	@"iPad2,4":  @"iPad",
	@"iPad2,5":  @"iPad",
	@"iPad2,6":  @"iPad",
	@"iPad2,7":  @"iPad",
	@"iPad3,1":  @"iPad",
	@"iPad3,2":  @"iPad",
	@"iPad3,3":  @"iPad",
	@"iPad3,4":  @"iPad",
	@"iPad3,5":  @"iPad",
	@"iPad3,6":  @"iPad",
	
	@"iPod1,1":  @"iPhone",
	@"iPod2,1":  @"iPhone",
	@"iPod3,1":  @"iPhone",
	@"iPod4,1":  @"iPhone",
	@"iPod5,1":  @"iPhone",
	
	};
	
	NSString *deviceName = commonNamesDictionary[machineName];
	
	if (deviceName == nil)
	{
		deviceName = machineName;
	}
	
	return deviceName;
}

///// iAds

- (void)PresentBanner
{
	if(!m_bannerPresented)
	{
		if(m_adBanner && m_bannerLoaded)
		{
			NSLog(@"The Ad is already loaded, presenting.");
			[self GetBannerOnScreen];
		}
		else if (!m_adBanner)
		{
			NSLog(@"Ad requested.");
			
			CGRect rect = [self RectForBanner];
			rect.origin.y += rect.size.height;
			
			m_adBanner = [[ADBannerView alloc] initWithFrame:rect];
			m_adBanner.delegate = self;
			
			[self.view addSubview:m_adBanner];
		}
	}
}

- (void)RemoveBanner
{
	if(m_bannerPresented)
	{
		NSLog(@"Ad removed from view.");
		[self GetBannerOffScreen];
	}
}

- (void)GetBannerOnScreen
{
	if (m_adBanner.superview == nil)
	{
		[self.view addSubview:m_adBanner];
	}
	
	CGRect rect = [self RectForBanner];
	
	[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
	
	m_adBanner.frame = rect;
	
	[UIView commitAnimations];
	
	m_bannerPresented = true;
}

- (void)GetBannerOffScreen
{
	CGRect rect = [self RectForBanner];
	rect.origin.y += rect.size.height;
	
	[UIView animateWithDuration:1.0f animations:^{
		m_adBanner.frame = rect;
	}
	completion:^(BOOL finished){
		[m_adBanner removeFromSuperview];
	}];
	
	m_bannerPresented = false;
}

- (CGRect)RectForBanner;
{
	int width = self.view.bounds.size.width;
	int height = self.view.bounds.size.height;
	if([m_device isEqual:@"iPhone"])
	{
		if(width > height)
		{
			return CGRectMake(0, height - 32, width, 32);
		}
		else
		{
			return CGRectMake(0, height - 50, width, 50);
		}
	}
	else
	{
		return CGRectMake(0, height - 66, width, 66);
	}
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	m_bannerLoaded = true;
	
	if(m_bannerAllowed)
	{
		NSLog(@"Ad retrieve successful. Presenting");
		[self GetBannerOnScreen];
	}
	else
	{
		NSLog(@"Ad retrieve successful but not allowed.");
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	NSLog(@"Failed to retrieve ad");
	
	if (m_bannerPresented)
	{
		[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		
		// Assumes the banner view is placed at the bottom of the screen.
		banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
		
		[UIView commitAnimations];
		
		m_bannerPresented = NO;
	}
}

///////////////////////////////
///////////////////////////////
///////////////////////////////

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[m_gameCenter AuthenticateLocalPlayer];
	
	[self PresentBanner];
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
	
	if(m_bannerPresented)
		[self GetBannerOnScreen];
	else
		[self GetBannerOffScreen];
}

- (void)update
{
	// The authentification View Controller is presented.
	if(m_gameCenter.AuthentificationViewController != nil || m_gameCenter.Presenting || m_bannerInteracting) return;
	
	// Update the timer to adjust the time we wnat to use.
	[m_timer Frame:self.timeSinceLastUpdate];
	
    //Update graphics
    [m_renderBox Frame:m_timer.LastUpdateTime];
    
    //Update audio
    [m_audioBox Frame:m_timer.LastUpdateTime];
    
	// Update the game.
	[m_game Frame:m_timer.LastUpdateTime];
	
	// Ads
	if(m_game.Adiable)
	{
		m_bannerAllowed = true;
		[self PresentBanner];
	}
	else
	{
		m_bannerAllowed = false;
		[self RemoveBanner];
	}
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
	
	[m_game TouchTap:x Y:y Fingers:(int)gestureRecognizer.numberOfTouches Taps:(int)gestureRecognizer.numberOfTapsRequired];
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
