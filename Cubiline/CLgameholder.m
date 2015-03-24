#import "CLgameholder.h"

@interface CLGameHolder()
{
	VERenderBox* m_renderBox;
	VEView* m_cubeView;
	VESprite* m_cubeImage;
	VECamera* m_cubeCamera;
	VEText* m_points;
	VEEffect1* m_pointsEffect;
	VEText* m_bestScore;
	VEText* m_coins;
	VESprite* m_coinsIcon;
	VEEffect1* m_coinsEffect;
	
	VESprite* m_background;
	
	VESprite* m_scoreFinish;
	VESprite* m_scoreFinish2;
	
	VESprite* m_pauseButton;
	Rect m_pauseRect;
	
	VESprite* m_pauseFade;
	
	VESprite* m_continueButton;
	VEText* m_continueText;
	Rect m_continueRect;
	
	VESprite* m_restartButton;
	VEText* m_restartText;
	Rect m_restartRect;
	
	VESprite* m_exitButton;
	VEText* m_exitText;
	Rect m_exitRect;
	
	VESprite* m_gcButton;
	VEText* m_gcText;
	Rect m_gcRect;
	
	float m_buttonSize;
	float m_viewSize;
	float m_bottomMargin;
	
	bool m_pressing;
	
	enum GH_STAGE
	{
		PLAYING,
		FINISHED,
		POWER,
		POWER_TO_PLAY,
		FINISHED_TO_RESTART,
		PAUSE
	};
	
	bool m_toMainMenu;
	
	enum GH_STAGE m_stage;
	
	VEWatch* m_watch;
	
	int m_highScore;
	int m_totalCoins;
	
	//  buttons
	bool m_touchedButton;
	bool m_isDown;
	
	/// Finish check out game.
	GLKVector3 m_preRotation;
	bool m_showing;
	
	enum CL_GRAPHICS m_graphics;
}

- (void)Create;
- (void)PresentInterface;
- (void)PresentPauseMenu;
- (void)PresentFinishMenu;

- (bool)TestButton:(Rect)button X:(float)x Y:(float)y;
- (void)ToFinish;

@end

@implementation CLGameHolder

@synthesize Level;
@synthesize Scene;
@synthesize Exit;

@synthesize GameCenter;
@synthesize GameData;

- (id)initWithRenderBox:(VERenderBox*)renderbox Background:(VESprite *)background Graphics:(enum CL_GRAPHICS)graphics
{
	self = [super init];
	
	if(self)
	{
		m_renderBox = renderbox;
		m_graphics = graphics;
		m_background = background;
		
		[self Create];
	}
	
	return self;
}

- (void)Frame:(float)time
{
	if(Exit)
	{
		[m_watch Frame:time];
		return;
	}
	[Level Frame:time];
	
	if(m_stage == PLAYING)
	{
		bool active = m_pointsEffect.IsActive;
		[m_pointsEffect Frame:time];
		
		if(Level.Score != m_pointsEffect.Value)
		{
			if(Level.Score == m_pointsEffect.Value + 1)
			{
				[m_pointsEffect Reset:Level.Score];
				active = true;
			}
			else
				m_pointsEffect.Value = Level.Score;
		}
		
		if(active)
		{
			m_points.Text = [NSString stringWithFormat:@"%d", (int)m_pointsEffect.Value];
		}
		
		if(m_highScore != Level.HighScore)
		{
			m_highScore = Level.HighScore;
			if(GameData.HighScore > m_highScore)
			{
				m_highScore = GameData.HighScore;
				Level.HighScore = m_highScore;
			}
			else
				GameData.HighScore = m_highScore;
			
			m_bestScore.Text = [NSString stringWithFormat:@"%d", m_highScore];
		}
		
		active = m_coinsEffect.IsActive;
		[m_coinsEffect Frame:time];

		if(Level.Coins != m_coinsEffect.Value)
		{
			m_totalCoins = Level.Coins;
			
			if(GameData.Coins > m_totalCoins)
			{
				m_totalCoins = GameData.Coins;
				Level.Coins = m_totalCoins;
			}
			else
				GameData.Coins = m_totalCoins;
			
			if(Level.Coins == m_coinsEffect.Value + 1)
			{
				[m_coinsEffect Reset:Level.Coins];
				active = true;
			}
			else
				m_coinsEffect.Value = Level.Coins;
			
		}

		if(active)
		{
			m_coins.Text = [NSString stringWithFormat:@"%d", (int)m_coinsEffect.Value];
			m_coinsIcon.Scale = GLKVector3Make(m_coins.Width + m_buttonSize / 5.0f, m_coins.Height, 0.0f);
		}
	}
	else if(m_stage == FINISHED)
	{
		[m_watch Frame:time];
		if(!m_watch.Active && !m_showing)
		{
			[self PresentFinishMenu];
			m_cubeCamera.PivotRotation = Level.FocusedCamera.TargetPivotRotation;
			m_showing = true;
		}
		else if(m_isDown)
		{
			[m_watch Reset];
		}
	}
	else if(m_stage == FINISHED_TO_RESTART)
	{
		if(GLKVector3Length(GLKVector3Subtract(Level.FocusedCamera.PivotRotation, m_cubeCamera.PivotRotation)) <= 0.4f)
		{
			m_stage = PLAYING;
			[Level ResetInZone:Level.Zone Up:Level.ZoneUp];
			Level.Move = true;
			m_cubeView.Camera = Level.FocusedCamera;
		}
		else
			m_cubeCamera.PivotRotation = Level.FocusedCamera.PivotRotation;
	}
	else if(m_stage == POWER_TO_PLAY)
	{
		if(GLKVector3Length(GLKVector3Subtract(Level.FocusedCamera.PivotRotation, m_cubeCamera.PivotRotation)) <= 0.0f)
		{
			m_stage = PLAYING;
			Level.Move = true;
			m_cubeView.Camera = Level.FocusedCamera;
			
			m_coinsEffect.TransitionTime = 0.4f;
			m_totalCoins = m_coinsEffect.Value;
			Level.Coins = m_totalCoins;
			GameData.Coins = m_totalCoins;
			m_coinsEffect.Value = m_totalCoins;
		}
		else
			m_cubeCamera.PivotRotation = Level.FocusedCamera.PivotRotation;
	}
	else if(m_stage == POWER)
	{
		[m_coinsEffect Frame:time];

		m_coins.Text = [NSString stringWithFormat:@"%d", (int)m_coinsEffect.Value];
		m_coinsIcon.Scale = GLKVector3Make(m_coins.Width + m_buttonSize / 5.0f, m_coins.Height, 0.0f);
		
		if(m_coinsEffect.Value == 0.0f)
			m_stage = POWER_TO_PLAY;
	}
	
	if(Level.Finished && m_stage != FINISHED)
	{
		m_stage = FINISHED;
		Level.Move = false;
		[self ToFinish];
	}
}

- (void)Render
{
	[m_cubeView Render];
	// Get the new texture generate in the view.
	m_cubeImage.Texture = m_cubeView.Color;
}

- (void)Resize
{
	float width = m_renderBox.ScreenWidth;
	float height = m_renderBox.ScreenHeight;
	float offset;
	
	if(width > height)
	{
		
		if([m_renderBox.DeviceType isEqual:@"iPhone"])
			offset = 32;
		else
			offset = 66;
	}
	else
	{
		if([m_renderBox.DeviceType isEqual:@"iPhone"])
			offset = 50;
		else
			offset = 66;
	}
	
	if(m_bottomMargin < offset)
		offset -= m_bottomMargin;
	
	/// Puse button
	m_pauseButton.Position = GLKVector3Make(-width / 2 + m_buttonSize / 2.0f, height / 2 - m_buttonSize / 2.0f, 0.0f);
	m_pauseRect.top =  height / 2;
	m_pauseRect.bottom = m_pauseRect.top - m_buttonSize;
	m_pauseRect.left = -width / 2;
	m_pauseRect.right = m_pauseRect.left + m_buttonSize;
	
	// best score text
	m_bestScore.Position = GLKVector3Make(0.0f, height / 2 - m_buttonSize / 3.0f, 0.0f);
	
	// Coins text
	m_coins.Position = GLKVector3Make(0.0f, -height / 2.0f + m_buttonSize / 4.0f, 0.0f);
	m_coinsIcon.Position = GLKVector3Make(0.0f, -height / 2.0f + m_buttonSize / 4.0f + m_viewSize / 92.0f, 0.0f);
	
	// Pause background
	m_pauseFade.Width = width;
	m_pauseFade.Height = height;
	
	// Pause buttons
	m_continueButton.Position = GLKVector3Make(0.0f, m_buttonSize / 2.0f + offset, 0.0f);
	m_continueText.Position = GLKVector3Make(0.0, m_buttonSize / 2.0f - m_buttonSize * 1.1f + offset, 0.0f);
	m_continueRect.top =  m_buttonSize / 2.0f + m_buttonSize + offset;
	m_continueRect.bottom = m_continueRect.top - m_buttonSize * 2.0f;
	m_continueRect.left = -m_buttonSize;
	m_continueRect.right = m_buttonSize;
	
	if(m_stage != FINISHED)
	{
		/// Score text
		m_points.Position = GLKVector3Make(0.0f, height / 2 - m_buttonSize / 1.2f, 0.0f);
		
		// Pause buttons
		m_restartButton.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.5f + offset, 0.0f);
		m_restartText.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.5f - m_buttonSize * 0.55f + offset, 0.0f);
		m_restartRect.top = -m_buttonSize * 1.5f + m_buttonSize / 2.0f + offset;
		m_restartRect.bottom = m_restartRect.top - m_buttonSize;
		m_restartRect.left = -m_buttonSize / 2.0f;
		m_restartRect.right = m_restartRect.left + m_buttonSize;
		
		m_gcButton.Position = GLKVector3Make(-width / 2.0f + m_buttonSize, -height / 2.0f + m_buttonSize + offset, 0.0f);
		m_gcText.Position = GLKVector3Make(-width / 2.0f + m_buttonSize, -height / 2.0f + m_buttonSize - m_buttonSize * 0.55f + offset, 0.0f);
		m_gcRect.top = -height / 2.0f + m_buttonSize * 1.5f + offset;
		m_gcRect.bottom = m_gcRect.top - m_buttonSize;
		m_gcRect.left = -width / 2.0f + m_buttonSize / 2.0f;
		m_gcRect.right = m_gcRect.left + m_buttonSize;
		
		m_exitButton.Position = GLKVector3Make(width / 2.0f - m_buttonSize, -height / 2.0f + m_buttonSize + offset, 0.0f);
		m_exitText.Position = GLKVector3Make(width / 2.0f - m_buttonSize, -height / 2.0f + m_buttonSize - m_buttonSize * 0.55f + offset, 0.0f);
		m_exitRect.top = m_gcRect.top;
		m_exitRect.bottom = m_gcRect.bottom;
		m_exitRect.right = width / 2.0f - m_buttonSize / 2.0f;
		m_exitRect.left = m_exitRect.right - m_buttonSize;
	}
	else
	{
		/// Score text
		m_points.Position = GLKVector3Make(0.0f, -m_buttonSize * 0.1, 0.0f);
		
		/// Finish band
		m_scoreFinish.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.15, 0.0f);
		m_scoreFinish2.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.15 + m_buttonSize * 0.8f + m_buttonSize * 0.5f, 0.0f);
		
		// Finish buttons
		m_restartButton.Position = GLKVector3Make(0.0f, -m_buttonSize, 0.0f);
		m_restartText.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.8f, 0.0f);
		m_restartRect.top = -m_buttonSize + m_buttonSize * 0.75f;
		m_restartRect.bottom = m_restartRect.top - m_buttonSize * 1.5f;
		m_restartRect.left = -m_buttonSize * 0.75f;
		m_restartRect.right = m_restartRect.left + m_buttonSize * 1.5f;
		
		m_gcButton.Position = GLKVector3Make(-m_buttonSize * 1.5f, -m_buttonSize, 0.0f);
		m_gcText.Position = GLKVector3Make(-m_buttonSize * 1.5f, -m_buttonSize * 1.6f, 0.0f);
		m_gcRect.top = -m_buttonSize + m_buttonSize * 0.5f;
		m_gcRect.bottom = m_gcRect.top - m_buttonSize;
		m_gcRect.left = -m_buttonSize * 2.0f;
		m_gcRect.right = m_gcRect.left + m_buttonSize;
		
		m_exitButton.Position = GLKVector3Make(m_buttonSize * 1.5f, -m_buttonSize, 0.0f);
		m_exitText.Position = GLKVector3Make(m_buttonSize * 1.5f, -m_buttonSize * 1.6f, 0.0f);
		m_exitRect.top = -m_buttonSize + m_buttonSize * 0.5f;
		m_exitRect.bottom = m_exitRect.top - m_buttonSize;
		m_exitRect.right = m_buttonSize * 2.0f;
		m_exitRect.left = m_exitRect.right - m_buttonSize;
		
		// Finish score banner.
		m_scoreFinish.Scale = GLKVector3Make(m_renderBox.ScreenWidth, m_buttonSize * 1.6f, 0.0f);
		m_scoreFinish2.Scale = GLKVector3Make(m_renderBox.ScreenWidth, m_buttonSize, 0.0f);
	}
}

- (void)Create
{
	float width = m_renderBox.ScreenWidth;
	float height = m_renderBox.ScreenHeight;
	m_bottomMargin = m_buttonSize - m_buttonSize * 0.55f - m_buttonSize * 0.1f;
	
	// Best size from the screen.
	if(width > height)
		m_viewSize = height;
	else
		m_viewSize = width;
	
	m_buttonSize = m_viewSize / 5.0f;
	
	// Cube view
	m_cubeView = [m_renderBox NewViewAs:VE_VIEW_TYPE_TEXTURE Width:m_viewSize Height:m_viewSize];
	m_cubeView.ClearColor = BackgroundColor;
	m_cubeImage = [m_renderBox NewSpriteFromTexture:m_cubeView.Color];
	m_cubeImage.Height = -m_cubeImage.Height;
	m_cubeView.RenderMode = VE_RENDER_MODE_DIFFUSE;
	
	// Camera for cuve view
	m_cubeCamera = [m_renderBox NewCamera:VE_CAMERA_TYPE_PERSPECTIVE];
	m_cubeCamera.PivotTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_cubeCamera.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_cubeCamera.PivotRotationTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_cubeCamera.ViewUpTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_cubeCamera.ViewUpTransitionTime = 0.4f;
	m_cubeCamera.PivotTransitionTime = 0.4f;
	m_cubeCamera.PositionTransitionTime = 0.4f;
	m_cubeCamera.PivotRotationTransitionTime = 0.2f;
	m_cubeCamera.LockLookAt = true;
	
	/// Pause button.
	m_pauseButton = [m_renderBox NewSpriteFromFileName:@"game_pause.png"];
	CommonButtonStyle(m_pauseButton);
	
	// Points text
	m_points = [m_renderBox NewTextWithFontName:m_renderBox.MaxTextureSize > 2048 ? @"Gau Font Cube Big" : @"Gau Font Cube Medium" Text:@"0"];
	CommonTextStyle(m_points);
	
	// BestScore text
	m_bestScore = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"0"];
	CommonTextStyle(m_bestScore);
	m_bestScore.Color = FrontColor;
	
	// Coins text.
	m_coins = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"0"];
	CommonTextStyle(m_coins);
	m_coins.Color = GLKVector3MultiplyScalar(TopColor, 0.5f);
	m_coinsIcon = [m_renderBox NewSolidSpriteWithColor:TopColor];
	CommonButtonStyle(m_coinsIcon);
	m_coinsIcon.LockAspect = false;
	
	// Effects for scores
	m_pointsEffect = [[VEEffect1 alloc] init];
	m_pointsEffect.TransitionEffect = VE_TRANSITION_EFFECT_HARD;
	m_pointsEffect.TransitionTime = 0.4f;
	m_coinsEffect = [[VEEffect1 alloc] init];
	m_coinsEffect.TransitionEffect = VE_TRANSITION_EFFECT_HARD;
	m_coinsEffect.TransitionTime = 0.4f;
	
	/// Puse background.
	m_pauseFade = [m_renderBox NewSolidSpriteWithColor:GrayColor];
	m_pauseFade.Opasity = 0.0f;
	m_pauseFade.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_pauseFade.OpasityTransitionTime = 0.15f;
	
	// puase buttons
	m_continueButton = [m_renderBox NewSpriteFromFileName:@"game_continue.png"];
	CommonButtonStyle(m_continueButton);
	
	m_restartButton = [m_renderBox NewSpriteFromFileName:@"game_restart.png"];
	CommonButtonStyle(m_restartButton);
	
	m_exitButton = [m_renderBox NewSpriteFromFileName:@"game_exit.png"];
	CommonButtonStyle(m_exitButton);
	
	m_gcButton = [m_renderBox NewSpriteFromFileName:@"game_gc.png"];
	CommonButtonStyle(m_gcButton);
	
	m_continueText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Continue"];
	CommonTextStyle(m_continueText);
	m_continueText.Color = ColorWhite;
	
	m_restartText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Restart"];
	CommonTextStyle(m_restartText);
	m_restartText.Color = ColorWhite;
	
	m_gcText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Scores"];
	CommonTextStyle(m_gcText);
	m_gcText.Color = ColorWhite;
	
	m_exitText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Main Menu"];
	CommonTextStyle(m_exitText);
	m_exitText.Color = ColorWhite;
	
	//////////
	
	/// Finish background band.
	m_scoreFinish = [m_renderBox NewSolidSpriteWithColor:PrimaryColor];
	CommonButtonStyle(m_scoreFinish);
	m_scoreFinish.LockAspect = false;
	m_scoreFinish2 = [m_renderBox NewSolidSpriteWithColor:FrontColor];
	CommonButtonStyle(m_scoreFinish2);
	m_scoreFinish2.LockAspect = false;
	
	// Scene for full screen presentation.
	Scene = [m_renderBox NewSceneWithName:@"PlayGameScene"];
	//[Scene addSprite:m_background];
	[Scene addSprite:m_cubeImage];
	[Scene addSprite:m_scoreFinish];
	[Scene addSprite:m_scoreFinish2];
	[Scene addText:m_points];
	[Scene addText:m_bestScore];
	[Scene addSprite:m_coinsIcon];
	[Scene addText:m_coins];
	[Scene addSprite:m_pauseButton];
	[Scene addSprite:m_pauseFade];
	[Scene addSprite:m_continueButton];
	[Scene addSprite:m_exitButton];
	[Scene addSprite:m_gcButton];
	[Scene addSprite:m_restartButton];
	[Scene addText:m_continueText];
	[Scene addText:m_restartText];
	[Scene addText:m_gcText];
	[Scene addText:m_exitText];
	
	// watch for timings.
	m_watch = [[VEWatch alloc] init];
	m_watch.Style = VE_WATCH_STYLE_LIMITED;
}

- (void)PresentInterface
{
	float fontsize = m_viewSize / 23.0f;
	
	[m_pauseButton ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
	[m_pauseButton ResetOpasity:0.0f];
	m_pauseButton.Width = m_buttonSize / 2.0f;
	m_pauseButton.Opasity = 1.0f;
	
	[m_points ResetFontSize: m_viewSize / 3.5f];
	[m_points ResetOpasity:0.0f];
	m_points.FontSize = m_viewSize / 7.0f;
	m_points.Opasity = 1.0f;
	m_points.Color = PrimaryColor;
	
	[m_bestScore ResetFontSize:fontsize * 2.2f];
	[m_bestScore ResetOpasity:0.0f];
	m_bestScore.FontSize = fontsize * 1.2;
	m_bestScore.Opasity = 1.0f;
	
	[m_coins ResetFontSize:fontsize * 2.0f];
	[m_coins ResetOpasity:0.0f];
	m_coins.FontSize = fontsize * 1.5f;;
	m_coins.Opasity = 1.0f;
	
	[m_coinsIcon ResetScale:GLKVector3Make(fontsize * 2.0f, fontsize * 2.0f, 0.0f)];
	[m_coinsIcon ResetOpasity:0.0f];
	m_coinsIcon.Scale = GLKVector3Make(m_coins.Width + m_buttonSize / 5.0f, m_coins.Height, 0.0f);
	m_coinsIcon.Opasity = 1.0f;
}

- (void)PresentPauseMenu
{
	m_pauseFade.Opasity = 0.9f;
	
	[m_continueButton ResetScale:GLKVector3Make(m_buttonSize * 3.5f, m_buttonSize * 3.5f, 0.0f)];
	[m_continueButton ResetOpasity:0.0f];
	m_continueButton.Width = m_buttonSize * 2.0f;
	m_continueButton.Opasity = 1.0f;
	
	[m_continueText ResetFontSize: m_buttonSize];
	[m_continueText ResetOpasity:0.0f];
	m_continueText.FontSize = m_buttonSize * 0.4f;
	m_continueText.Opasity = 1.0f;
	
	[m_restartButton ResetScale:GLKVector3Make(m_buttonSize * 2.0f, m_buttonSize * 2.0f, 0.0f)];
	[m_restartButton ResetOpasity:0.0f];
	m_restartButton.Width = m_buttonSize;
	m_restartButton.Opasity = 1.0f;
	
	[m_restartText ResetFontSize: m_buttonSize];
	[m_restartText ResetOpasity:0.0f];
	m_restartText.FontSize = m_buttonSize * 0.2f;
	m_restartText.Opasity = 1.0f;
	
	[m_gcButton ResetScale:GLKVector3Make(m_buttonSize * 2.0f, m_buttonSize * 2.0f, 0.0f)];
	[m_gcButton ResetOpasity:0.0f];
	m_gcButton.Width = m_buttonSize;
	m_gcButton.Opasity = 1.0f;
	
	[m_gcText ResetFontSize: m_buttonSize];
	[m_gcText ResetOpasity:0.0f];
	m_gcText.FontSize = m_buttonSize * 0.2f;
	m_gcText.Opasity = 1.0f;
	
	[m_exitButton ResetScale:GLKVector3Make(m_buttonSize * 2.0f, m_buttonSize * 2.0f, 0.0f)];
	[m_exitButton ResetOpasity:0.0f];
	m_exitButton.Width = m_buttonSize;
	m_exitButton.Opasity = 1.0f;
	
	[m_exitText ResetFontSize: m_buttonSize];
	[m_exitText ResetOpasity:0.0f];
	m_exitText.FontSize = m_buttonSize * 0.2f;
	m_exitText.Opasity = 1.0f;
}

- (void)PresentFinishMenu
{
	[m_points ResetFontSize: m_buttonSize / 2.0f];
	[m_points ResetOpasity:0.0f];
	m_points.FontSize = m_buttonSize;
	m_points.Opasity = 1.0f;
	m_points.Color = ColorWhite;
	
	[m_scoreFinish ResetScale:GLKVector3Make(m_renderBox.ScreenWidth * 1.5f, m_renderBox.ScreenHeight * 0.7f, 0.0f)];
	[m_scoreFinish ResetOpasity:0.0f];
	m_scoreFinish.Scale = GLKVector3Make(m_renderBox.ScreenWidth, m_buttonSize * 1.6f, 0.0f);
	m_scoreFinish.Opasity = 0.9f;
	
	[m_scoreFinish2 ResetScale:GLKVector3Make(m_renderBox.ScreenWidth * 1.5f, m_renderBox.ScreenHeight * 0.5f, 0.0f)];
	[m_scoreFinish2 ResetOpasity:0.0f];
	m_scoreFinish2.Scale = GLKVector3Make(m_renderBox.ScreenWidth, m_buttonSize, 0.0f);
	m_scoreFinish2.Opasity = 0.9f;
	
	[m_restartButton ResetScale:GLKVector3Make(m_buttonSize * 2.5f, m_buttonSize * 2.5f, 0.0f)];
	[m_restartButton ResetOpasity:0.0f];
	m_restartButton.Width = m_buttonSize * 1.5;
	m_restartButton.Opasity = 1.0f;
	
	[m_restartText ResetFontSize: m_buttonSize];
	[m_restartText ResetOpasity:0.0f];
	m_restartText.FontSize = m_buttonSize * 0.25f;
	m_restartText.Opasity = 1.0f;
	
	[m_gcButton ResetScale:GLKVector3Make(m_buttonSize * 2.0f, m_buttonSize * 2.0f, 0.0f)];
	[m_gcButton ResetOpasity:0.0f];
	m_gcButton.Width = m_buttonSize;
	m_gcButton.Opasity = 1.0f;
	
	[m_gcText ResetFontSize: m_buttonSize];
	[m_gcText ResetOpasity:0.0f];
	m_gcText.FontSize = m_buttonSize * 0.25f;
	m_gcText.Opasity = 1.0f;
	
	[m_exitButton ResetScale:GLKVector3Make(m_buttonSize * 2.0f, m_buttonSize * 2.0f, 0.0f)];
	[m_exitButton ResetOpasity:0.0f];
	m_exitButton.Width = m_buttonSize;
	m_exitButton.Opasity = 1.0f;
	
	[m_exitText ResetFontSize: m_buttonSize];
	[m_exitText ResetOpasity:0.0f];
	m_exitText.FontSize = m_buttonSize * 0.25f;
	m_exitText.Opasity = 1.0f;
}

- (void)Pause
{
	if(m_stage != PLAYING)return;
	m_stage = PAUSE;
	Level.Move = false;
	
	[self PresentPauseMenu];
}

- (bool)TestButton:(Rect)button X:(float)x Y:(float)y
{
	return (button.top > y && button.bottom < y && button.left < x && button.right > x);
}

- (void)TouchPanBegan:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_stage == FINISHED || m_stage == POWER)
	{
		m_preRotation = m_cubeCamera.PivotRotation;
	}
}

- (void)TouchPanChange:(float)x Y:(float)y Fingers:(int)fingers
{
	if((m_stage == FINISHED && !m_touchedButton) || m_stage == POWER)
	{
		GLKVector3 newRotation;
		if(Level.Zone == CL_ZONE_FRONT)
		{
			if(Level.ZoneUp == CL_ZONE_TOP)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-y / 4.0f, -x / 4.0f, 0.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BOTTOM)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(y / 4.0f, x / 4.0f, 0.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_RIGHT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-x / 4.0f, y / 4.0f, 0.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_LEFT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(x / 4.0f, -y / 4.0f, 0.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_BACK)
		{
			if(Level.ZoneUp == CL_ZONE_TOP)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(y / 4.0f, -x / 4.0f, 0.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BOTTOM)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-y / 4.0f, x / 4.0f, 0.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_RIGHT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-x / 4.0f, -y / 4.0f, 0.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_LEFT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(x / 4.0f, y / 4.0f, 0.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_RIGHT)
		{
			if(Level.ZoneUp == CL_ZONE_TOP)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_YZX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, -x / 4.0f, y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BOTTOM)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_YZX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, x / 4.0f, -y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_FRONT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, -y / 4.0f, -x / 4.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BACK)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, y / 4.0f, x / 4.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_LEFT)
		{
			if(Level.ZoneUp == CL_ZONE_TOP)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_YZX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, -x / 4.0f, -y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BOTTOM)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_YZX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, x / 4.0f, y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_FRONT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, y / 4.0f, -x / 4.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BACK)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, -y / 4.0f, x / 4.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_TOP)
		{
			if(Level.ZoneUp == CL_ZONE_FRONT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(y / 4.0f, 0.0f, -x / 4.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BACK)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-y / 4.0f, 0.0f, x / 4.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_RIGHT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_XZY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-x / 4.0f, 0.0f, -y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_LEFT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_XZY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(x / 4.0f, 0.0f, y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_BOTTOM)
		{
			if(Level.ZoneUp == CL_ZONE_FRONT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-y / 4.0f, 0.0f, -x / 4.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BACK)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(y / 4.0f, 0.0f,  x / 4.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_RIGHT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_XZY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-x / 4.0f, 0.0f, y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_LEFT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_XZY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(x / 4.0f, 0.0f, -y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
		}
		
		m_cubeCamera.PivotRotation = newRotation;
		
		if(m_stage == FINISHED)
		{
			if(m_showing)
			{
				m_points.Opasity = 0.0f;
				m_scoreFinish.Opasity = 0.0f;
				m_scoreFinish2.Opasity = 0.0f;
				m_restartButton.Opasity = 0.0f;
				m_gcButton.Opasity = 0.0f;
				m_exitButton.Opasity = 0.0f;
				m_restartText.Opasity = 0.0f;
				m_gcText.Opasity = 0.0f;
				m_exitText.Opasity = 0.0f;
			}
			m_showing = false;
			
			[m_watch Reset];
			[m_watch SetLimitInSeconds:1.0f];
		}
	}
}

- (void)TouchPanEnd:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_stage == PLAYING || m_stage == FINISHED_TO_RESTART)
	{
		if(fabsf(x) > fabsf(y))
		{
			if(x > 0)
			{
				if(y > 0)
					[Level doTurn:CL_TURN_RIGHT_DOWN];
				else
					[Level doTurn:CL_TURN_RIGHT_UP];
			}
			else
			{
				if(y > 0)
					[Level doTurn:CL_TURN_LEFT_DOWN];
				else
					[Level doTurn:CL_TURN_LEFT_UP];
			}
		}
		else
		{
			if(y > 0)
			{
				if(x > 0)
					[Level doTurn:CL_TURN_DOWN_RIGHT];
				else
					[Level doTurn:CL_TURN_DOWN_LEFT];
			}
			else
			{
				if(x > 0)
					[Level doTurn:CL_TURN_UP_RIGHT];
				else
					[Level doTurn:CL_TURN_UP_LEFT];
			}
		}
	}
}

- (void)TouchTap:(float)x Y:(float)y Fingers:(int)fingers Taps:(int)taps
{
	if(m_stage == PLAYING && taps == 2 && m_coinsEffect.Value > 0.0f)
	{
		m_stage = POWER;
		Level.Move = false;
		
		[m_cubeCamera ResetPosition:Level.FocusedCamera.PositionWOR];
		[m_cubeCamera ResetPivot:Level.FocusedCamera.Pivot];
		[m_cubeCamera ResetPivotRotation:Level.FocusedCamera.PivotRotation];
		[m_cubeCamera ResetViewUp:Level.FocusedCamera.ViewUp];
		[m_cubeCamera Frame:0.0f];
		m_cubeView.Camera = m_cubeCamera;
		[m_renderBox Frame:0.0f];
		[Level Frame:20.0];
		m_cubeCamera.ViewUp = Level.FocusedCamera.TargetViewUp;
		m_cubeCamera.PivotRotation = Level.FocusedCamera.TargetPivotRotation;
		
		m_coinsEffect.TransitionSpeed = 50;
		m_coinsEffect.Value = 0;
	}
	else if(m_stage == POWER && taps == 1)
	{
		m_stage = POWER_TO_PLAY;
	}
}

- (void)TouchDown:(float)x Y:(float)y Fingers:(int)fingers
{
	float rx = x - m_renderBox.ScreenWidth / 2;
	float ry = -y + m_renderBox.ScreenHeight / 2;
	
	m_touchedButton = true;
	m_isDown = true;
	if(m_stage == PLAYING)
	{
		if([self TestButton:m_pauseRect X:rx Y:ry])
		{
			m_pauseButton.Width = m_buttonSize * 0.45f;
		}
		else
			m_touchedButton = false;
	}
	else if(m_stage == PAUSE)
	{
		if([self TestButton:m_continueRect X:rx Y:ry])
			m_continueButton.Width = m_buttonSize * 1.7f;
		else if([self TestButton:m_restartRect X:rx Y:ry])
			m_restartButton.Width = m_buttonSize * 0.7f;
		else if([self TestButton:m_gcRect X:rx Y:ry])
			m_gcButton.Width = m_buttonSize * 0.7f;
		else if([self TestButton:m_exitRect X:rx Y:ry])
			m_exitButton.Width = m_buttonSize * 0.7f;
		else
			m_touchedButton = false;
	}
	else if(m_stage == FINISHED && !m_watch.Active)
	{
		
		if([self TestButton:m_restartRect X:rx Y:ry])
			m_restartButton.Width = m_buttonSize * 1.0f;
		else if([self TestButton:m_gcRect X:rx Y:ry])
			m_gcButton.Width = m_buttonSize * 0.7f;
		else if([self TestButton:m_exitRect X:rx Y:ry])
			m_exitButton.Width = m_buttonSize * 0.7f;
		else
			m_touchedButton = false;
	}
	else
		m_touchedButton = false;
}

- (void)TouchUp:(float)x Y:(float)y Fingers:(int)fingers;
{
	float rx = x - m_renderBox.ScreenWidth / 2;
	float ry = -y + m_renderBox.ScreenHeight / 2;
	
	m_isDown = false;
	if(m_stage == PLAYING && m_touchedButton)
	{
		if([self TestButton:m_pauseRect X:rx Y:ry])
		{
			[self Pause];
		}
		m_pauseButton.Width = m_buttonSize / 2.0f;
	}
	else if(m_stage == PAUSE && m_touchedButton)
	{
		if([self TestButton:m_continueRect X:rx Y:ry])
		{
			m_stage = PLAYING;
			Level.Move = true;
			m_pauseFade.Opasity = 0.0f;
			m_continueButton.Opasity = 0.0f;
			m_restartButton.Opasity = 0.0f;
			m_gcButton.Opasity = 0.0f;
			m_exitButton.Opasity = 0.0f;
			m_continueText.Opasity = 0.0f;
			m_restartText.Opasity = 0.0f;
			m_gcText.Opasity = 0.0f;
			m_exitText.Opasity = 0.0f;
		}
		else if([self TestButton:m_restartRect X:rx Y:ry])
		{
			m_stage = PLAYING;
			[Level ResetInZone:Level.Zone Up:Level.ZoneUp];
			Level.Move = true;
			m_pauseFade.Opasity = 0.0f;
			m_continueButton.Opasity = 0.0f;
			m_restartButton.Opasity = 0.0f;
			m_gcButton.Opasity = 0.0f;
			m_exitButton.Opasity = 0.0f;
			m_continueText.Opasity = 0.0f;
			m_restartText.Opasity = 0.0f;
			m_gcText.Opasity = 0.0f;
			m_exitText.Opasity = 0.0f;
		}
		else if([self TestButton:m_gcRect X:rx Y:ry])
		{
			[GameCenter presentGameCenter];
		}
		else if([self TestButton:m_exitRect X:rx Y:ry])
		{
			Exit = true;
		}
		m_continueButton.Width = m_buttonSize * 2.0f;
		m_restartButton.Width = m_buttonSize;
		m_gcButton.Width = m_buttonSize;
		m_exitButton.Width = m_buttonSize;
	}
	else if(m_stage == FINISHED && m_touchedButton)
	{
		if([self TestButton:m_restartRect X:rx Y:ry])
		{
			m_stage = FINISHED_TO_RESTART;

			[m_points Frame:0.0f];
			Level.Finished = false;
			
			m_pauseFade.Opasity = 0.0f;
			m_continueButton.Opasity = 0.0f;
			m_restartButton.Opasity = 0.0f;
			m_gcButton.Opasity = 0.0f;
			m_exitButton.Opasity = 0.0f;
			m_continueText.Opasity = 0.0f;
			m_restartText.Opasity = 0.0f;
			m_gcText.Opasity = 0.0f;
			m_exitText.Opasity = 0.0f;
			m_scoreFinish.Opasity = 0.0f;
			m_scoreFinish2.Opasity = 0.0f;
			
			[self Resize];
			[self PresentInterface];
			
			m_cubeCamera.PivotRotationTransitionTime = 0.1;
			m_cubeCamera.PivotRotation = Level.FocusedCamera.PivotRotation;
		}
		else if([self TestButton:m_gcRect X:rx Y:ry])
		{
			[GameCenter presentGameCenter];
		}
		else if([self TestButton:m_exitRect X:rx Y:ry])
		{
			Exit = true;
		}
		m_restartButton.Width = m_buttonSize * 1.5f;
		m_gcButton.Width = m_buttonSize;
		m_exitButton.Width = m_buttonSize;
	}
}

- (void)Begin
{
	m_stage = PLAYING;
	m_cubeView.Camera = Level.FocusedCamera;
	
	[m_pointsEffect Reset];
	m_points.Text = @"0";
	
	[m_coinsEffect Reset];
	m_totalCoins = 0;
	m_coins.Text = @"0";
	
	[self Resize];
	[self PresentInterface];
	
	m_toMainMenu = false;
	Exit = false;
}

- (void)OutToMainMenu
{
	m_bestScore.Opasity = 0.0f;
	m_points.Opasity = 0.0f;
	m_pauseButton.Opasity = 0.0f;
	m_pauseFade.Opasity = 0.0f;
	m_continueButton.Opasity = 0.0f;
	m_restartButton.Opasity = 0.0f;
	m_gcButton.Opasity = 0.0f;
	m_exitButton.Opasity = 0.0f;
	m_continueText.Opasity = 0.0f;
	m_restartText.Opasity = 0.0f;
	m_gcText.Opasity = 0.0f;
	m_exitText.Opasity = 0.0f;
	m_scoreFinish.Opasity = 0.0f;
	m_scoreFinish2.Opasity = 0.0f;
	m_points.Opasity = 0.0f;
	m_coins.Opasity = 0.0f;
	m_coinsIcon.Opasity = 0.0f;
	
	[m_cubeCamera ResetPivot:Level.FocusedCamera.Pivot];
	[m_cubeCamera ResetPosition:[Level.FocusedCamera PositionWOR]];
	[m_cubeCamera ResetViewUp:Level.FocusedCamera.ViewUp];
	[m_cubeCamera ResetPivotRotation:Level.FocusedCamera.PivotRotation];
	[m_cubeCamera Frame:0.0f];
	
	m_cubeCamera.PivotRotationTransitionTime = 0.2f;
	
	m_cubeView.Camera = m_cubeCamera;
	[Level Restore];
	
	m_stage = PLAYING;
	
	m_toMainMenu = true;
	
	if(Level.Zone == CL_ZONE_FRONT)
	{
		m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -7.5f);
		m_cubeCamera.Position = GLKVector3Make(0.0f, 0.0f, 7.5f);
		m_cubeCamera.PivotRotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
	}
	
	if(Level.Zone == CL_ZONE_BACK)
	{
		m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, 7.5f);
		m_cubeCamera.Position = GLKVector3Make(0.0f, 0.0f, -7.5f);
		m_cubeCamera.PivotRotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
	}
	
	if(Level.Zone == CL_ZONE_RIGHT)
	{
		m_cubeCamera.Pivot = GLKVector3Make(-7.5f, 0.0f, 0.0f);
		m_cubeCamera.Position = GLKVector3Make(7.5f, 0.0f, 0.0f);
		m_cubeCamera.PivotRotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
	}
	
	if(Level.Zone == CL_ZONE_LEFT)
	{
		m_cubeCamera.Pivot = GLKVector3Make(7.5f, 0.0f, 0.0f);
		m_cubeCamera.Position = GLKVector3Make(-7.5f, 0.0f, 0.0f);
		m_cubeCamera.PivotRotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
	}
	
	if(Level.Zone == CL_ZONE_TOP)
	{
		m_cubeCamera.Pivot = GLKVector3Make(0.0f, -7.5f, 0.0f);
		m_cubeCamera.Position = GLKVector3Make(0.0f, 7.5f, 0.0f);
		m_cubeCamera.PivotRotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
	}
	
	if(Level.Zone == CL_ZONE_BOTTOM)
	{
		m_cubeCamera.Pivot = GLKVector3Make(0.0f, 7.5f, 0.0f);
		m_cubeCamera.Position = GLKVector3Make(0.0f, -7.5f, 0.0f);
		m_cubeCamera.PivotRotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
	}

	[m_watch Reset];
	[m_watch SetLimitInSeconds:0.5f];
}

- (bool)OutReady
{
	return !m_watch.Active;
}

- (void)ToFinish
{
	[m_cubeCamera ResetPosition:Level.FocusedCamera.PositionWOR];
	[m_cubeCamera ResetPivot:Level.FocusedCamera.Pivot];
	[m_cubeCamera ResetPivotRotation:Level.FocusedCamera.PivotRotation];
	[m_cubeCamera ResetViewUp:Level.FocusedCamera.ViewUp];
	[m_cubeCamera Frame:0.0f];
	m_cubeView.Camera = m_cubeCamera;
	[m_renderBox Frame:0.0f];
	m_cubeCamera.ViewUp = Level.FocusedCamera.TargetViewUp;
	m_cubeCamera.PivotRotation = Level.FocusedCamera.TargetPivotRotation;
	
	m_coins.Opasity = 0.0f;
	m_coinsIcon.Opasity = 0.0f;
	m_bestScore.Opasity = 0.0f;
	m_points.Opasity = 0.0f;
	m_pauseButton.Opasity = 0.0f;
	
	[self Resize];
	[self PresentFinishMenu];
	
	m_showing = true;
}

- (void)setLevel:(CLLevel *)level
{
	Level = level;
	m_cubeView.Scene = Level.Scene;
	m_cubeView.Camera = Level.FocusedCamera;
}

- (CLLevel*)Level
{
	return Level;
}

- (bool)Adiable
{
	if(m_stage == PAUSE || m_stage == FINISHED || m_stage == FINISHED_TO_RESTART || m_toMainMenu)
		return true;
	return false;
}

@end