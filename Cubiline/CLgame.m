#import "CLgame.h"

@interface CLGame()
{
    VERenderBox* m_renderBox;
    VEAudioBox* m_audioBox;
	
	CLGameSetpUp* m_gameSetUp;
	CLLevel* m_cubilineLevel;
	CLMainMenu* m_mainMenu;
	CLGameHolder* m_gameHolder;
	
	VEGameCenter* m_gameCenter;
	CLData* m_gameData;
	
	VESprite* m_background;
	
	enum GAME_STATE
	{
		GAME_STATE_MAIN_MENU,
		GAME_STATE_FROM_MAIN_TO_GAME_SETUP,
		GAME_STATE_GAME_SETUP,
		GAME_STATE_FROM_GAME_SETUP_TO_PLAY,
		GAME_STATE_PLAYING,
		GAME_STATE_FROM_PLAYING_TO_MAIN_MENU
	};
	enum GAME_STATE m_gameState;
	
	AVAudioPlayer* m_player;
	
	enum CL_GRAPHICS m_graphics;
}

@end

@implementation CLGame

- (id)initWithRenderBox:(VERenderBox*)renderbox AudioBox:(VEAudioBox *)audiobox GameCenter:(VEGameCenter *)gamecenter Graphics:(enum CL_GRAPHICS)graphics
{
	self = [super init];
	
	if(self)
	{
        // Get the renderbox and audiobox
		m_renderBox = renderbox;
        m_audioBox = audiobox;
		m_gameCenter = gamecenter;
		m_graphics = graphics;
		
		m_background = [m_renderBox NewSpriteFromFileName:@"background.png"];
		m_background.ColorTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_background.ColorTransitionTime = 0.3f;
		m_background.Scale = GLKVector3Make(m_renderBox.ScreenWidth, -m_renderBox.ScreenHeight, 0.0f);
		
		// Game data.
		m_gameData = [CLData loadInstanceWithGameCenter:m_gameCenter];
		
		// Main menu.
		m_mainMenu = [[CLMainMenu alloc] initWithRenderBox:m_renderBox Background:m_background Graphics:m_graphics];
		m_mainMenu.GameCenter = m_gameCenter;
		[m_mainMenu Resize];
		
		m_cubilineLevel = [[CLLevel alloc] initWithRenderBox:m_renderBox Graphics:m_graphics];
		m_cubilineLevel.Grown = m_gameData.Grown;
		m_cubilineLevel.HighScore = m_gameData.HighScore;
		m_cubilineLevel.Coins = m_gameData.Coins;
		//m_cubilineLevel.BodyColor = GLKVector3Make(0.80, 0.90, 0.95);
		m_cubilineLevel.BodyColor = PrimaryColor;
		
		m_gameSetUp = [[CLGameSetpUp alloc] initWithRenderBox:m_renderBox Background:m_background Graphics:m_graphics];
		[m_gameSetUp Resize];
		m_gameSetUp.Level = m_cubilineLevel;
		
		m_gameHolder = [[CLGameHolder alloc] initWithRenderBox:m_renderBox Background:m_background Graphics:m_graphics];
		m_gameHolder.GameCenter = m_gameCenter;
		m_gameHolder.GameData = m_gameData;
		[m_gameHolder Resize];
		m_gameHolder.Level = m_cubilineLevel;
		
		m_renderBox.MainView.ClearColor = BackgroundColor;
		m_renderBox.MainView.Scene = m_mainMenu.Scene;
		m_gameState = GAME_STATE_MAIN_MENU;
		
		// Sound
		NSString *path = [NSString stringWithFormat:@"%@/10 Fire Meet Gasoline.mp3", [[NSBundle mainBundle] resourcePath]];
		NSURL *soundUrl = [NSURL fileURLWithPath:path];
		
		// Create audio player object and initialize with URL to sound
		m_player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
		m_player.numberOfLoops = 100000;
		
		//[m_player play];
	}
	
	return self;
}

- (void)Frame:(float)time
{
	[m_gameData Frame];
	if(m_gameState == GAME_STATE_MAIN_MENU)
	{
		[m_mainMenu Frame:time];
		if([m_mainMenu Selected])
		{
			if(m_mainMenu.Selection == CL_MAIN_MENU_SELECTION_PLAY)
			{
				[m_gameSetUp Resize];
				[m_gameSetUp InToSetUp];
				[m_gameSetUp Frame:time];
				
				[m_mainMenu OutToPlay];
				m_gameState = GAME_STATE_FROM_MAIN_TO_GAME_SETUP;
			}
			else if(m_mainMenu.Selection == CL_MAIN_MENU_SELECTION_GC)
			{
				[m_gameCenter presentGameCenter];
				[m_mainMenu Reset];
			}
			else if(m_mainMenu.Selection == CL_MAIN_MENU_SELECTION_ABOUT)
			{
				[m_mainMenu About];
				[m_mainMenu Reset];
			}
		}
	}
	else if(m_gameState == GAME_STATE_FROM_MAIN_TO_GAME_SETUP)
	{
		[m_mainMenu Frame:time];
		if([m_mainMenu OutReady])
		{
			m_renderBox.MainView.Scene = m_gameSetUp.Scene;
			[m_gameSetUp Begin];
			m_gameState = GAME_STATE_GAME_SETUP;
			[m_gameSetUp Resize];
			m_cubilineLevel.Move = true;
			m_cubilineLevel.Follow = false;
		}
	}
	else if(m_gameState == GAME_STATE_GAME_SETUP)
	{
		[m_cubilineLevel Frame:time];
		[m_gameSetUp Frame:time];
		if([m_gameSetUp Ready])
		{
			[m_gameSetUp OutToPlay];
			m_gameState = GAME_STATE_FROM_GAME_SETUP_TO_PLAY;
			[m_mainMenu Reset];
			m_cubilineLevel.Dance = false;
			m_cubilineLevel.Follow = true;
			m_cubilineLevel.Feed = true;
		}
	}
	else if(m_gameState == GAME_STATE_FROM_GAME_SETUP_TO_PLAY)
	{
		[m_cubilineLevel Frame:time];
		[m_gameSetUp Frame:time];
		if([m_gameSetUp OutReady])
		{
			m_cubilineLevel.Collide = true;
			m_renderBox.MainView.Scene = m_gameHolder.Scene;
			m_gameState = GAME_STATE_PLAYING;
			[m_gameHolder Begin];
		}
	}
	else if(m_gameState == GAME_STATE_PLAYING)
	{
		[m_gameHolder Frame:time];
		if(m_gameHolder.Exit)
		{
			[m_gameHolder OutToMainMenu];
			m_gameState = GAME_STATE_FROM_PLAYING_TO_MAIN_MENU;
		}
	}
	else if(m_gameState == GAME_STATE_FROM_PLAYING_TO_MAIN_MENU)
	{
		[m_gameHolder Frame:time];
		if([m_gameHolder OutReady])
		{
			m_gameState = GAME_STATE_MAIN_MENU;
			m_renderBox.MainView.Scene = m_mainMenu.Scene;
			[m_mainMenu Resize];
			[m_mainMenu InFromPlaying];
		}
	}
}

- (void)Render
{
	if(m_gameState == GAME_STATE_MAIN_MENU || m_gameState == GAME_STATE_FROM_MAIN_TO_GAME_SETUP)
		[m_mainMenu Render];
	else if(m_gameState == GAME_STATE_GAME_SETUP || m_gameState == GAME_STATE_FROM_GAME_SETUP_TO_PLAY)
		[m_gameSetUp Render];
	else if(m_gameState == GAME_STATE_PLAYING || m_gameState == GAME_STATE_FROM_PLAYING_TO_MAIN_MENU)
		[m_gameHolder Render];
}

- (void)Resize
{
	m_background.Scale = GLKVector3Make(m_renderBox.ScreenWidth, -m_renderBox.ScreenHeight, 0.0f);
	if(m_gameState == GAME_STATE_MAIN_MENU || m_gameState == GAME_STATE_FROM_MAIN_TO_GAME_SETUP)
		[m_mainMenu Resize];
	else if(m_gameState == GAME_STATE_GAME_SETUP || m_gameState == GAME_STATE_FROM_GAME_SETUP_TO_PLAY || m_gameState == GAME_STATE_FROM_MAIN_TO_GAME_SETUP)
		[m_gameSetUp Resize];
	else if(m_gameState == GAME_STATE_PLAYING || m_gameState == GAME_STATE_FROM_PLAYING_TO_MAIN_MENU || m_gameState == GAME_STATE_FROM_GAME_SETUP_TO_PLAY)
		[m_gameHolder Resize];
}

- (void)Pause
{
	if(m_gameState == GAME_STATE_PLAYING)
		[m_gameHolder Pause];
}

- (void)TouchPanBegan:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_gameState == GAME_STATE_MAIN_MENU)
		[m_mainMenu TouchPanBegan:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp TouchPanBegan:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_PLAYING || m_gameState == GAME_STATE_FROM_GAME_SETUP_TO_PLAY)
		[m_gameHolder TouchPanBegan:x Y:y Fingers:fingers];
}

- (void)TouchPanChange:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_gameState == GAME_STATE_MAIN_MENU)
		[m_mainMenu TouchPanChange:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp TouchPanChange:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_PLAYING || m_gameState == GAME_STATE_FROM_GAME_SETUP_TO_PLAY)
		[m_gameHolder TouchPanChange:x Y:y Fingers:fingers];
}

- (void)TouchPanEnd:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_gameState == GAME_STATE_MAIN_MENU)
		[m_mainMenu TouchPanEnd:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp TouchPanEnd:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_PLAYING || m_gameState == GAME_STATE_FROM_GAME_SETUP_TO_PLAY)
		[m_gameHolder TouchPanEnd:x Y:y Fingers:fingers];
}

- (void)TouchTap:(float)x Y:(float)y Fingers:(int)fingers Taps:(int)taps
{
	if(m_gameState == GAME_STATE_MAIN_MENU)
		[m_mainMenu TouchTap:x Y:y Fingers:fingers Taps:taps];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp TouchTap:x Y:y Fingers:fingers Taps:taps];
	else if(m_gameState == GAME_STATE_PLAYING || m_gameState == GAME_STATE_FROM_GAME_SETUP_TO_PLAY)
		[m_gameHolder TouchTap:x Y:y Fingers:fingers Taps:taps];
}

- (void)TouchDown:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_gameState == GAME_STATE_MAIN_MENU)
		[m_mainMenu TouchDown:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp TouchDown:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_PLAYING || m_gameState == GAME_STATE_FROM_GAME_SETUP_TO_PLAY)
		[m_gameHolder TouchDown:x Y:y Fingers:fingers];
}

- (void)TouchUp:(float)x Y:(float)y Fingers:(int)fingers;
{
	if(m_gameState == GAME_STATE_MAIN_MENU)
		[m_mainMenu TouchUp:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp TouchUp:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_PLAYING || m_gameState == GAME_STATE_FROM_GAME_SETUP_TO_PLAY)
		[m_gameHolder TouchUp:x Y:y Fingers:fingers];
}

- (bool)Adiable
{
	if(m_gameState == GAME_STATE_MAIN_MENU || m_gameState == GAME_STATE_FROM_MAIN_TO_GAME_SETUP || m_gameState == GAME_STATE_GAME_SETUP)
		return true;
	
	return m_gameHolder.Adiable;
}

@end