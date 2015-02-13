#import "CLgame.h"

@interface CLGame()
{
    VERenderBox* m_renderBox;
    VEAudioBox* m_audioBox;
	
	CLGameSetpUp* m_gameSetUp;
	CLLevel* m_cubilineLevel;
	CLMainMenu* m_mainMenu;
	
	enum GAME_STATE
	{
		GAME_STATE_MAIN_MENU,
		GAME_STATE_FROM_MAIN_TO_PLAY,
		GAME_STATE_GAME_SETUP,
		GAME_STATE_PLAYING
	};
	
	enum GAME_STATE m_gameState;
	
	AVAudioPlayer* m_player;
}

@end

@implementation CLGame

- (id)initWithRenderBox:(VERenderBox*)renderbox AudioBox:(VEAudioBox *)audiobox
{
	self = [super init];
	
	if(self)
	{
        // Get the renderbox and audiobox
		m_renderBox = renderbox;
        m_audioBox = audiobox;
		
		// Main menu.
		m_mainMenu = [[CLMainMenu alloc] initWithRenderBox:m_renderBox];
		[m_mainMenu Resize];
		
		m_cubilineLevel = [[CLLevel alloc] initWithRenderBox:m_renderBox];
		
		m_gameSetUp = [[CLGameSetpUp alloc] initWithRenderBox:m_renderBox];
		[m_gameSetUp Resize];
		m_gameSetUp.Level = m_cubilineLevel;
		
		m_renderBox.MainView.ClearColor = WhiteBackgroundColor;
		m_renderBox.MainView.Scene = m_mainMenu.Scene;
		m_gameState = GAME_STATE_MAIN_MENU;
		
		// Sound
		NSString *path = [NSString stringWithFormat:@"%@/test_song.mp3", [[NSBundle mainBundle] resourcePath]];
		NSURL *soundUrl = [NSURL fileURLWithPath:path];
		
		// Create audio player object and initialize with URL to sound
		m_player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
		m_player.numberOfLoops = 100000;
		
		[m_player play];
	}
	
	return self;
}

- (void)Frame:(float)time
{
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
				m_gameState = GAME_STATE_FROM_MAIN_TO_PLAY;
			}
		}
	}
	else if(m_gameState == GAME_STATE_FROM_MAIN_TO_PLAY)
	{
		[m_mainMenu Frame:time];
		if([m_mainMenu OutReady])
		{
			m_renderBox.MainView.Scene = m_gameSetUp.Scene;
			[m_gameSetUp Begin];
			m_gameState = GAME_STATE_GAME_SETUP;
		}
	}
	else if(m_gameState == GAME_STATE_GAME_SETUP)
	{
		[m_cubilineLevel Frame:time];
		[m_gameSetUp Frame:time];
		if([m_gameSetUp Ready])
		{

		}
	}
	else if(m_gameState == GAME_STATE_PLAYING)
	{

	}
}

- (void)Render
{
	if(m_gameState == GAME_STATE_MAIN_MENU || m_gameState == GAME_STATE_FROM_MAIN_TO_PLAY)
		[m_mainMenu Render];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp Render];
	else if(m_gameState == GAME_STATE_PLAYING)
	{}
}

- (void)Resize
{
	if(m_gameState == GAME_STATE_MAIN_MENU || m_gameState == GAME_STATE_FROM_MAIN_TO_PLAY)
		[m_mainMenu Resize];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp Resize];
	else if(m_gameState == GAME_STATE_PLAYING)
	{}
}

- (void)TouchPanBegan:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_gameState == GAME_STATE_MAIN_MENU)
		[m_mainMenu TouchPanBegan:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp TouchPanBegan:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_PLAYING)
	{}
}

- (void)TouchPanChange:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_gameState == GAME_STATE_MAIN_MENU)
		[m_mainMenu TouchPanChange:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp TouchPanChange:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_PLAYING)
	{}
}

- (void)TouchPanEnd:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_gameState == GAME_STATE_MAIN_MENU)
		[m_mainMenu TouchPanEnd:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp TouchPanEnd:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_PLAYING)
	{}
}

- (void)TouchTap:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_gameState == GAME_STATE_MAIN_MENU)
		[m_mainMenu TouchTap:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp TouchTap:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_PLAYING)
	{}
}

- (void)TouchDown:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_gameState == GAME_STATE_MAIN_MENU)
		[m_mainMenu TouchDown:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp TouchDown:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_PLAYING)
	{}
}

- (void)TouchUp:(float)x Y:(float)y Fingers:(int)fingers;
{
	if(m_gameState == GAME_STATE_MAIN_MENU)
		[m_mainMenu TouchUp:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_GAME_SETUP)
		[m_gameSetUp TouchUp:x Y:y Fingers:fingers];
	else if(m_gameState == GAME_STATE_PLAYING)
	{}
}


@end