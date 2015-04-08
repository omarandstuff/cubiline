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
	VEText* m_coinsC;
	VESprite* m_coinsIcon;
	VEEffect1* m_coinsEffect;
	
	VESprite* m_scoreFinish;
	VESprite* m_scoreFinish2;
	
	////Indicatorseses
	VESprite* m_special1;
	VESprite* m_special2;
	VESprite* m_special3;
	VESprite* m_special4;
	VESprite* m_special5;
	bool m_special1Active;
	bool m_special2Active;
	bool m_special3Active;
	bool m_special4Active;
	bool m_special5Active;
	///
	
	VESprite* m_pauseButton;
	Rect m_pauseRect;
	
	VEText* m_spendText;
	VEWatch* m_spendTextTime;
	
	VESprite* m_timeButton;
	Rect m_timeRect;
	
	VESprite* m_reductButton;
	Rect m_reductRect;
	
	VESprite* m_ghostButton;
	Rect m_ghostRect;
	
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
	
	VEText* m_newRecord;
	
	float m_buttonSize;
	float m_viewSize;
	
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
	int m_grown;
	
	//  buttons
	bool m_touchedButton;
	bool m_isDown;
	
	/// Finish check out game.
	GLKVector3 m_preRotation;
	bool m_showing;
	
	enum CL_GRAPHICS m_graphics;
	
	bool m_toNew;
	bool m_new;

	//Ads
	VEAds* m_ads;
	
	/// Get Coins
	VESprite* m_getCoinsBack;
	VEText* m_getCoinsText;
	VESprite* m_getCoinsIcon;
	Rect m_getCoinsRect;
	bool m_getCoinsEnable;
	bool m_viewed;
	
	
	/// reset effect
	bool m_resetEffect;
	VEWatch* m_resetEffectTime;
	
	VEAudioBox* m_audioBox;
	VESound* m_finishSound;
	VESound* m_newRecordSound;
	VESound* m_click;
	VESound* m_playSound;
	
	VESprite* m_audioSetUpOn;
	VESprite* m_audioSetUpOff;
	Rect m_audioSetUpRect;
	
	
	CLLAnguage* m_language;
}

- (void)Create;
- (void)PresentInterface;
- (void)PresentPauseMenu;
- (void)PresentFinishMenu;
- (void)PresentSpend:(NSString*)text;

- (bool)TestButton:(Rect)button X:(float)x Y:(float)y;
- (void)ToFinish;

@end

@implementation CLGameHolder

@synthesize Level;
@synthesize Scene;
@synthesize Exit;

@synthesize GameCenter;
@synthesize GameData;

- (id)initWithRenderBox:(VERenderBox*)renderbox Graphics:(enum CL_GRAPHICS)graphics
{
	self = [super init];
	
	if(self)
	{
		m_renderBox = renderbox;
		m_graphics = graphics;
		
		m_language = [CLLAnguage sharedCLLanguage];
		
		m_ads = [VEAds sharedVEAds];
		
		m_totalCoins = -20;
		
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
	
	/// Rerset Effect
	[m_resetEffectTime Frame:time];
	if(m_resetEffect && !m_resetEffectTime.Active)
	{
		m_resetEffect = false;
		[self PresentInterface];
	}
	
	////Spend
	[m_spendTextTime Frame:time];
	
	if(!m_spendTextTime.Active && m_spendText.Opasity != 0.0f)
	{
		m_spendText.Opasity = 0.0f;
	}
	
	if(m_stage == PLAYING)
	{
		//// Indicators
		
		if(m_special1Active != Level.Special1Active)
		{
			m_special1Active = Level.Special1Active;
			if(m_special1Active)
			{
				[m_special1 ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
				[m_special1 ResetOpasity:0.0f];
				m_special1.Width = m_buttonSize * 0.2f;
				m_special1.Opasity = 1.0f;
				
				[m_click Stop];
				[m_click Play];
			}
			else
			{
				m_special1.Opasity = 0.0f;
			}
		}
		
		if(m_special2Active != Level.Special2Active)
		{
			m_special2Active = Level.Special2Active;
			if(m_special2Active)
			{
				[m_special2 ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
				[m_special2 ResetOpasity:0.0f];
				m_special2.Width = m_buttonSize * 0.2f;
				m_special2.Opasity = 1.0f;
				
				[m_click Stop];
				[m_click Play];
			}
			else
			{
				m_special2.Opasity = 0.0f;
			}
		}
		
		if(m_special3Active != Level.Special3Active)
		{
			m_special3Active = Level.Special3Active;
			if(m_special3Active)
			{
				[m_special3 ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
				[m_special3 ResetOpasity:0.0f];
				m_special3.Width = m_buttonSize * 0.2f;
				m_special3.Opasity = 1.0f;
				
				[m_click Stop];
				[m_click Play];
			}
			else
			{
				m_special3.Opasity = 0.0f;
			}
		}
		
		if(m_special4Active != Level.Special4Active)
		{
			m_special4Active = Level.Special4Active;
			if(m_special4Active)
			{
				[m_special4 ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
				[m_special4 ResetOpasity:0.0f];
				m_special4.Width = m_buttonSize * 0.2f;
				m_special4.Opasity = 1.0f;
				
				[m_click Stop];
				[m_click Play];
			}
			else
			{
				m_special4.Opasity = 0.0f;
			}
		}
		
		if(m_special5Active != Level.Special5Active)
		{
			m_special5Active = Level.Special5Active;
			if(m_special5Active)
			{
				[m_special5 ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
				[m_special5 ResetOpasity:0.0f];
				m_special5.Width = m_buttonSize * 0.2f;
				m_special5.Opasity = 1.0f;
				
				[m_click Stop];
				[m_click Play];
			}
			else
			{
				m_special5.Opasity = 0.0f;
			}
		}
		
		
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
			if(m_highScore != 0)m_toNew = true;
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

		if(Level.Coins != m_totalCoins)
		{
			int delta = Level.Coins - m_totalCoins;
			if(m_totalCoins == -1)
			{
				m_totalCoins = 0;
				delta = 0;
				active = true;
			}
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
			
			if(!m_spendTextTime.Active && !m_new && delta != 0)
				[self PresentSpend:[NSString stringWithFormat:@"+$%d", delta]];
			else if(delta != 0)
			{
				m_spendText.Text = [NSString stringWithFormat:@"+$%d", delta];
				[m_spendTextTime Reset];
			}
		}
		m_new = false;

		if(active)
		{
			m_coins.Text = [NSString stringWithFormat:@"%d    ", (int)m_coinsEffect.Value];
			m_coinsIcon.Scale = GLKVector3Make(m_coins.Width + m_buttonSize / 5.0f, m_coins.Height, 0.0f);
			
			m_coinsC.Position = GLKVector3Make(m_coins.Width * 0.5f, -m_renderBox.ScreenHeight / 2.0f + m_buttonSize / 4.0f, 0.0f);
		}
		
		if(Level.Grown != m_grown)
		{
			m_grown = Level.Grown;
			if(GameData.Grown > m_grown)
			{
				m_grown = GameData.Grown;
				Level.Grown = m_grown;
			}
			else
				GameData.Grown = m_grown;
		}
	}
	else if(m_stage == FINISHED)
	{
		[m_watch Frame:time];
		if(!m_watch.Active && !m_showing)
		{
			[self PresentFinishMenu];
			
			[m_watch Reset];
			[m_watch SetLimitInSeconds:0.0f];
			[m_watch Frame:1.0f];
			
			m_cubeCamera.PivotRotation = Level.FocusedCamera.TargetPivotRotation;
			m_showing = true;
		}
		else if(m_isDown)
		{
			[m_watch Reset];
		}
		
		bool active = m_coinsEffect.IsActive;
		[m_coinsEffect Frame:time];
		
		if(Level.Coins != m_coinsEffect.Value)
		{
			int delta = Level.Coins - m_totalCoins;
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
			
			if(!m_spendTextTime.Active && !m_new && delta != 0)
				[self PresentSpend:[NSString stringWithFormat:@"+$%d", delta]];
			else if(delta != 0)
			{
				m_spendText.Text = [NSString stringWithFormat:@"+$%d", delta];
				[m_spendTextTime Reset];
			}
		}
		if(active)
		{
			m_coins.Text = [NSString stringWithFormat:@"%d    ", (int)m_coinsEffect.Value];
			m_coinsIcon.Scale = GLKVector3Make(m_coins.Width + m_buttonSize / 5.0f, m_coins.Height, 0.0f);
			
			m_coinsC.Position = GLKVector3Make(m_coins.Width * 0.5f, -m_renderBox.ScreenHeight / 2.0f + m_buttonSize / 4.0f, 0.0f);
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
			
			m_points.Position = GLKVector3Make(0.0f, m_renderBox.ScreenHeight / 2 - m_buttonSize / 1.2f, 0.0f);
			
			[m_resetEffectTime SetLimitInSeconds:1.0f];
			[m_resetEffectTime Reset];
			m_resetEffect = true;
			
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
			
			if(m_special1Active)
				m_special1.Opasity = 1.0f;
			if(m_special2Active)
				m_special2.Opasity = 1.0f;
			if(m_special3Active)
				m_special3.Opasity = 1.0f;
			if(m_special4Active)
				m_special4.Opasity = 1.0f;
			if(m_special5Active)
				m_special5.Opasity = 1.0f;
			
			[self PresentInterface];
		}
		else
			m_cubeCamera.PivotRotation = Level.FocusedCamera.PivotRotation;
	}
	else if(m_stage == POWER)
	{
		[m_coinsEffect Frame:time];
		
		static int num = 0;
		
		if(abs((int)m_coinsEffect.Value - num) >= 25)
		{
			num = (int)m_coinsEffect.Value;
		}

		m_coins.Text = [NSString stringWithFormat:@"%d    ", (int)m_coinsEffect.Value];
		m_coinsIcon.Scale = GLKVector3Make(m_coins.Width + m_buttonSize / 5.0f, m_coins.Height, 0.0f);
		
		m_coinsC.Position = GLKVector3Make(m_coins.Width * 0.5f, -m_renderBox.ScreenHeight / 2.0f + m_buttonSize / 4.0f, 0.0f);
		
		m_spendText.Text = [NSString stringWithFormat:@"-$%d", m_totalCoins - (int)m_coinsEffect.Value];
		[m_spendTextTime Reset];
		
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
	
	float offsetMenu = m_buttonSize * 1.1f;
	
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
	m_coinsC.Position = GLKVector3Make(m_coins.Width * 0.5f, -height / 2.0f + m_buttonSize / 4.0f, 0.0f);
	
	m_spendText.Position = GLKVector3Make(0.0f, -height / 2.0f + m_buttonSize / 1.5f + m_viewSize / 92.0f, 0.0f);
	
	// Pause background
	m_pauseFade.Width = width;
	m_pauseFade.Height = height;
	
	/// Power buttons
	m_timeButton.Position = GLKVector3Make(-width / 2.0f + m_buttonSize / 2.0f, -height / 2.0f + m_buttonSize * 2.0f, 0.0f);
	m_timeRect.top = -height / 2.0f + m_buttonSize * 2.0f + m_buttonSize * 0.35f;
	m_timeRect.bottom = m_timeRect.top - m_buttonSize * 0.75f;
	m_timeRect.left = -width / 2.0f;
	m_timeRect.right = m_timeRect.left + m_buttonSize * 0.75f;
	
	m_reductButton.Position = GLKVector3Make(-width / 2.0f + m_buttonSize / 2.0f, -height / 2.0f + m_buttonSize * 1.25f, 0.0f);
	
	m_reductRect.top = -height / 2.0f + m_buttonSize * 1.25f + m_buttonSize * 0.35f;
	m_reductRect.bottom = m_reductRect.top - m_buttonSize * 0.75f;
	m_reductRect.left = m_timeRect.left;
	m_reductRect.right = m_reductRect.left + m_buttonSize * 0.75f;
	
	m_ghostButton.Position = GLKVector3Make(-width / 2.0f + m_buttonSize / 2.0f, -height / 2.0f + m_buttonSize / 2.0f, 0.0f);
	m_ghostRect.top = -height / 2.0f + m_buttonSize / 2.0f + m_buttonSize * 0.35f;
	m_ghostRect.bottom = m_ghostRect.top - m_buttonSize * 0.75f;
	m_ghostRect.left = m_timeRect.left;
	m_ghostRect.right = m_ghostRect.left + m_buttonSize * 0.75f;
	
	///
	
	//// Special indicators
	float sizeofspecial = m_buttonSize / 4.0f;
	m_special1.Position = GLKVector3Make(-sizeofspecial * 2.0f, height / 2 - m_buttonSize * 1.2f, 0.0f);
	m_special2.Position = GLKVector3Make(-sizeofspecial, height / 2 - m_buttonSize * 1.2f, 0.0f);
	m_special3.Position = GLKVector3Make(0.0f, height / 2 - m_buttonSize * 1.2f, 0.0f);
	m_special4.Position = GLKVector3Make(sizeofspecial, height / 2 - m_buttonSize * 1.2f, 0.0f);
	m_special5.Position = GLKVector3Make(sizeofspecial * 2.0f, height / 2 - m_buttonSize * 1.2f, 0.0f);
	
	////

	// Pause buttons
	m_continueButton.Position = GLKVector3Make(0.0f, m_buttonSize / 2.0f, 0.0f);
	m_continueText.Position = GLKVector3Make(0.0, m_buttonSize / 2.0f - m_buttonSize * 1.1f, 0.0f);
	m_continueRect.top =  m_buttonSize / 2.0f + m_buttonSize;
	m_continueRect.bottom = m_continueRect.top - m_buttonSize * 2.0f;
	m_continueRect.left = -m_buttonSize;
	m_continueRect.right = m_buttonSize;
	
	/// Audio
	
	m_audioSetUpOn.Position = GLKVector3Make(width / 2.0f - m_buttonSize / 3.0f, height / 2.0f - m_buttonSize / 3.0f, 0.0f);
	m_audioSetUpOff.Position = GLKVector3Make(width / 2.0f - m_buttonSize / 3.0f, height / 2.0f - m_buttonSize / 3.0f, 0.0f);
	
	m_audioSetUpRect.bottom = height / 2.0f - (m_buttonSize / 3.0f) * 1.8f;
	m_audioSetUpRect.top = height / 2.0f;
	m_audioSetUpRect.left = width / 2.0f - (m_buttonSize / 3.0f) * 1.8f;
	m_audioSetUpRect.right = width / 2.0f;
	
	if(m_stage != FINISHED)
	{
		/// Score text
		m_points.Position = GLKVector3Make(0.0f, height / 2 - m_buttonSize / 1.2f, 0.0f);
		
		// Pause buttons
		m_restartButton.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.5f, 0.0f);
		m_restartText.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.5f - m_buttonSize * 0.55f, 0.0f);
		m_restartRect.top = -m_buttonSize * 1.5f + m_buttonSize / 2.0f;
		m_restartRect.bottom = m_restartRect.top - m_buttonSize;
		m_restartRect.left = -m_buttonSize / 2.0f;
		m_restartRect.right = m_restartRect.left + m_buttonSize;
		
		m_gcButton.Position = GLKVector3Make(-width / 2.0f + m_buttonSize, -height / 2.0f + m_buttonSize, 0.0f);
		m_gcText.Position = GLKVector3Make(-width / 2.0f + m_buttonSize, -height / 2.0f + m_buttonSize - m_buttonSize * 0.55f, 0.0f);
		m_gcRect.top = -height / 2.0f + m_buttonSize * 1.5f;
		m_gcRect.bottom = m_gcRect.top - m_buttonSize;
		m_gcRect.left = -width / 2.0f + m_buttonSize / 2.0f;
		m_gcRect.right = m_gcRect.left + m_buttonSize;
		
		m_exitButton.Position = GLKVector3Make(width / 2.0f - m_buttonSize, -height / 2.0f + m_buttonSize, 0.0f);
		m_exitText.Position = GLKVector3Make(width / 2.0f - m_buttonSize, -height / 2.0f + m_buttonSize - m_buttonSize * 0.55f, 0.0f);
		m_exitRect.top = m_gcRect.top;
		m_exitRect.bottom = m_gcRect.bottom;
		m_exitRect.right = width / 2.0f - m_buttonSize / 2.0f;
		m_exitRect.left = m_exitRect.right - m_buttonSize;
	}
	else
	{
		/// Score text
		m_points.Position = GLKVector3Make(0.0f, -m_buttonSize * 0.1 + offsetMenu, 0.0f);
		
		/// Finish band
		m_scoreFinish.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.15 + offsetMenu, 0.0f);
		m_scoreFinish2.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.15 + m_buttonSize * 0.8f + m_buttonSize * 0.5f + offsetMenu, 0.0f);
		
		/// Coins band
		GLKVector3 positionget = GLKVector3Make(0.0f, -m_buttonSize * 1.15 + offsetMenu - m_buttonSize * 0.8f + ((-height / 2.0f + m_buttonSize / 2.0f) - (-m_buttonSize * 1.15 + offsetMenu - m_buttonSize * 0.8f)) / 2.0f, 0.0f);
		m_getCoinsBack.Position = positionget;
		m_getCoinsText.Position = positionget;
		positionget.x = width / 2.0f - m_buttonSize * 0.25f;
		positionget.y -= (m_buttonSize * 0.375f - m_buttonSize * 0.25f);
		m_getCoinsIcon.Position = positionget;
		
		m_getCoinsRect.top = positionget.y + m_buttonSize * 0.375f;
		m_getCoinsRect.bottom = m_getCoinsRect.top - m_buttonSize * 0.75f;
		m_getCoinsRect.left = -width / 2.0f;
		m_getCoinsRect.right = width / 2.0f;
		
		m_getCoinsBack.Width = width;
		m_getCoinsBack.Height = m_buttonSize * 0.75f;
		
		// Finish buttons
		m_restartButton.Position = GLKVector3Make(0.0f, -m_buttonSize + offsetMenu, 0.0f);
		m_restartText.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.8f + offsetMenu, 0.0f);
		m_restartRect.top = -m_buttonSize + m_buttonSize * 0.75f + offsetMenu;
		m_restartRect.bottom = m_restartRect.top - m_buttonSize * 1.5f;
		m_restartRect.left = -m_buttonSize * 0.75f;
		m_restartRect.right = m_restartRect.left + m_buttonSize * 1.5f;
		
		m_gcButton.Position = GLKVector3Make(-m_buttonSize * 1.5f, -m_buttonSize + offsetMenu, 0.0f);
		m_gcText.Position = GLKVector3Make(-m_buttonSize * 1.5f, -m_buttonSize * 1.6f + offsetMenu, 0.0f);
		m_gcRect.top = -m_buttonSize + m_buttonSize * 0.5f + offsetMenu;
		m_gcRect.bottom = m_gcRect.top - m_buttonSize;
		m_gcRect.left = -m_buttonSize * 2.0f;
		m_gcRect.right = m_gcRect.left + m_buttonSize;
		
		m_exitButton.Position = GLKVector3Make(m_buttonSize * 1.5f, -m_buttonSize + offsetMenu, 0.0f);
		m_exitText.Position = GLKVector3Make(m_buttonSize * 1.5f, -m_buttonSize * 1.6f + offsetMenu, 0.0f);
		m_exitRect.top = -m_buttonSize + m_buttonSize * 0.5f + offsetMenu;
		m_exitRect.bottom = m_exitRect.top - m_buttonSize;
		m_exitRect.right = m_buttonSize * 2.0f;
		m_exitRect.left = m_exitRect.right - m_buttonSize;
		
		// Finish score banner.
		m_scoreFinish.Scale = GLKVector3Make(m_renderBox.ScreenWidth, m_buttonSize * 1.6f, 0.0f);
		m_scoreFinish2.Scale = GLKVector3Make(m_renderBox.ScreenWidth, m_buttonSize, 0.0f);
		
		// New record text.
		m_newRecord.Position = GLKVector3Make(m_points.Width / 2.0f + m_buttonSize * 0.1f, m_buttonSize * 0.5f + offsetMenu, 0.0f);
	}
}

- (void)Create
{
	float width = m_renderBox.ScreenWidth;
	float height = m_renderBox.ScreenHeight;
	
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
	m_cubeCamera.Far = 60.0f;
	m_cubeCamera.Near = 1.0f;
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
	m_coins = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"0   "];
	CommonTextStyle(m_coins);
	m_coins.Color = GLKVector3MultiplyScalar(TopColor, 0.5f);
	m_coinsIcon = [m_renderBox NewSolidSpriteWithColor:TopColor];
	CommonButtonStyle(m_coinsIcon);
	m_coinsIcon.LockAspect = false;
	
	m_coinsC = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"c" Align:VE_TEXT_ALIGN_RIGHT];
	CommonTextStyle(m_coinsC);
	m_coinsC.Color = BottomColor;
	
	m_coinsEffect = [[VEEffect1 alloc] init];
	m_coinsEffect.TransitionEffect = VE_TRANSITION_EFFECT_HARD;
	m_coinsEffect.TransitionTime = 0.4f;
	
	// Effects for scores
	m_pointsEffect = [[VEEffect1 alloc] init];
	m_pointsEffect.TransitionEffect = VE_TRANSITION_EFFECT_HARD;
	m_pointsEffect.TransitionTime = 0.4f;
	
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
	
	m_continueText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:[m_language stringForKey:@"game_continue"]];
	CommonTextStyle(m_continueText);
	m_continueText.Color = ColorWhite;
	
	m_restartText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:[m_language stringForKey:@"game_restart"]];
	CommonTextStyle(m_restartText);
	m_restartText.Color = ColorWhite;
	
	m_gcText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:[m_language stringForKey:@"game_scores"]];
	CommonTextStyle(m_gcText);
	m_gcText.Color = ColorWhite;
	
	m_exitText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:[m_language stringForKey:@"game_menu"]];
	CommonTextStyle(m_exitText);
	m_exitText.Color = ColorWhite;
	m_newRecord.RotationTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_newRecord.RotationTransitionTime = 0.15f;
	
	//////////
	
	/// Power buttons
	
	m_timeButton = [m_renderBox NewSpriteFromFileName:@"game_time_button.png"];
	CommonButtonStyle(m_timeButton);
	
	m_reductButton = [m_renderBox NewSpriteFromFileName:@"game_reduct_button.png"];
	CommonButtonStyle(m_reductButton);
	
	m_ghostButton = [m_renderBox NewSpriteFromFileName:@"game_ghost_button.png"];
	CommonButtonStyle(m_ghostButton);
	
	
	/// spend
	m_spendText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@""];
	CommonTextStyle(m_spendText);
	m_spendText.Color = PrimaryColor;
	
	m_spendTextTime = [[VEWatch alloc] init];
	m_spendTextTime.Style = VE_WATCH_STYLE_LIMITED;

	///
	
	/// Get coins
	m_getCoinsBack = [m_renderBox NewSolidSpriteWithColor:TopColor];
	CommonButtonStyle(m_getCoinsBack);
	m_getCoinsBack.LockAspect = false;
	
	m_getCoinsText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:[m_language stringForKey:@"game_get_coins"]];
	CommonTextStyle(m_getCoinsText);
	m_getCoinsText.Color = GLKVector3MultiplyScalar(TopColor, 0.5f);

	m_getCoinsIcon = [m_renderBox NewSpriteFromFileName:@"get_coins_icon.png"];
	CommonButtonStyle(m_getCoinsIcon);
	
	[m_ads AddunityAdsVideoCompletedObjectResponder:self];
	
	//// Indicators
	m_special1 = [m_renderBox NewSolidSpriteWithColor:RightColor];
	CommonButtonStyle(m_special1);
	m_special2 = [m_renderBox NewSolidSpriteWithColor:BottomColor];
	CommonButtonStyle(m_special2);
	m_special3 = [m_renderBox NewSolidSpriteWithColor:TopColor];
	CommonButtonStyle(m_special3);
	m_special4 = [m_renderBox NewSolidSpriteWithColor:PrimaryColor];
	CommonButtonStyle(m_special4);
	m_special5 = [m_renderBox NewSolidSpriteWithColor:ColorWhite];
	CommonButtonStyle(m_special5);
	/////
	
	// New record text
	m_newRecord = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:[m_language stringForKey:@"game_record"]];
	CommonTextStyle(m_newRecord);
	m_newRecord.Color = BottomColor;
	
	/// Finish background band.
	m_scoreFinish = [m_renderBox NewSolidSpriteWithColor:PrimaryColor];
	CommonButtonStyle(m_scoreFinish);
	m_scoreFinish.LockAspect = false;
	m_scoreFinish2 = [m_renderBox NewSolidSpriteWithColor:ColorWhite];
	CommonButtonStyle(m_scoreFinish2);
	m_scoreFinish2.LockAspect = false;
	
	//// Audio SetUp
	m_audioSetUpOn = [m_renderBox NewSpriteFromFileName:@"sound_button_on.png"];
	m_audioSetUpOff = [m_renderBox NewSpriteFromFileName:@"sound_button_off.png"];
	CommonButtonStyle(m_audioSetUpOn);
	CommonButtonStyle(m_audioSetUpOff);
	
	// Scene for full screen presentation.
	Scene = [m_renderBox NewSceneWithName:@"PlayGameScene"];
	[Scene addSprite:m_cubeImage];
	[Scene addSprite:m_scoreFinish];
	[Scene addSprite:m_scoreFinish2];
	[Scene addText:m_points];
	[Scene addText:m_bestScore];
	[Scene addSprite:m_coinsIcon];
	[Scene addText:m_coins];
	[Scene addText:m_coinsC];
	[Scene addSprite:m_timeButton];
	[Scene addSprite:m_reductButton];
	[Scene addSprite:m_ghostButton];
	[Scene addSprite:m_special1];
	[Scene addSprite:m_special2];
	[Scene addSprite:m_special3];
	[Scene addSprite:m_special4];
	[Scene addSprite:m_special5];
	[Scene addSprite:m_pauseButton];
	[Scene addSprite:m_audioSetUpOn];
	[Scene addSprite:m_audioSetUpOff];
	
	[Scene addSprite:m_getCoinsBack];
	[Scene addText:m_getCoinsText];
	[Scene addSprite:m_getCoinsIcon];
	
	[Scene addText:m_spendText];
	
	[Scene addSprite:m_pauseFade];
	[Scene addSprite:m_continueButton];
	[Scene addSprite:m_exitButton];
	[Scene addSprite:m_gcButton];
	[Scene addSprite:m_restartButton];
	[Scene addText:m_continueText];
	[Scene addText:m_restartText];
	[Scene addText:m_gcText];
	[Scene addText:m_exitText];
	[Scene addText:m_newRecord];
	
	
	
	
	// watch for timings.
	m_watch = [[VEWatch alloc] init];
	m_watch.Style = VE_WATCH_STYLE_LIMITED;
	
	m_resetEffectTime = [[VEWatch alloc] init];
	m_resetEffectTime.Style = VE_WATCH_STYLE_LIMITED;
	
	
	/// Sounds
	m_audioBox = [VEAudioBox sharedVEAudioBox];
	m_finishSound = [m_audioBox NewSoundWithFileName:@"finish.wav"];
	m_newRecordSound = [m_audioBox NewSoundWithFileName:@"newrecord.wav"];
	m_click = [m_audioBox NewSoundWithFileName:@"plus_minus.wav"];
	m_playSound = [m_audioBox NewSoundWithFileName:@"play.wav"];
}

- (void)PresentInterface
{
	float fontsize = m_viewSize / 23.0f;
	
	[m_pauseButton ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
	[m_pauseButton ResetOpasity:0.0f];
	m_pauseButton.Width = m_buttonSize * 0.75f;
	m_pauseButton.Opasity = 1.0f;
	
	[m_points ResetFontSize: m_viewSize / 3.5f];
	[m_points ResetOpasity:0.0f];
	m_points.FontSize = m_viewSize / 7.0f;
	m_points.Opasity = 1.0f;
	m_points.Color = PrimaryColor;
	
	[m_bestScore ResetFontSize:fontsize * 2.2f];
	[m_bestScore ResetOpasity:0.0f];
	m_bestScore.FontSize = fontsize * 1.2f;
	m_bestScore.Opasity = 1.0f;
	
	[m_coins ResetFontSize:fontsize * 2.0f];
	[m_coins ResetOpasity:0.0f];
	m_coins.FontSize = fontsize * 1.5f;;
	m_coins.Opasity = 1.0f;
	
	[m_coinsIcon ResetScale:GLKVector3Make(fontsize * 2.0f, fontsize * 2.0f, 0.0f)];
	[m_coinsIcon ResetOpasity:0.0f];
	m_coinsIcon.Scale = GLKVector3Make(m_coins.Width + m_buttonSize / 5.0f, m_coins.Height, 0.0f);
	m_coinsIcon.Opasity = 1.0f;
	
	[m_coinsC ResetFontSize:fontsize * 2.0f];
	[m_coinsC ResetOpasity:0.0f];
	m_coinsC.FontSize = fontsize * 1.5f;;
	m_coinsC.Opasity = 1.0f;

	[m_timeButton ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
	[m_timeButton ResetOpasity:0.0f];
	m_timeButton.Width = m_buttonSize * 0.75f;
	m_timeButton.Opasity = 1.0f;
	
	[m_reductButton ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
	[m_reductButton ResetOpasity:0.0f];
	m_reductButton.Width = m_buttonSize * 0.75f;
	m_reductButton.Opasity = 1.0f;
	
	[m_ghostButton ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
	[m_ghostButton ResetOpasity:0.0f];
	m_ghostButton.Width = m_buttonSize * 0.75f;
	m_ghostButton.Opasity = 1.0f;
	
	if(m_audioBox.Mute)
	{
		[m_audioSetUpOff ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
		[m_audioSetUpOff ResetOpasity];
		m_audioSetUpOff.Width = m_buttonSize / 3.0f;
		m_audioSetUpOff.Opasity = 1.0f;
	}
	else
	{
		[m_audioSetUpOn ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
		[m_audioSetUpOn ResetOpasity];
		m_audioSetUpOn.Width = m_buttonSize / 3.0f;
		m_audioSetUpOn.Opasity = 1.0f;
	}
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
	float fontsize = m_viewSize / 23.0f;
	
	[m_points ResetFontSize: m_buttonSize / 2.0f];
	[m_points ResetOpasity:0.0f];
	m_points.FontSize = m_buttonSize;
	m_points.Opasity = 1.0f;
	m_points.Color = FrontColor;
	
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
	
	if(m_toNew)
	{
		[m_newRecord ResetFontSize: m_buttonSize * 1.3f];
		[m_newRecord ResetOpasity:0.0f];
		[m_newRecord ResetRotation];
		m_newRecord.Rotation = GLKVector3Make(0.0f, 0.0f, -35.0f);
		m_newRecord.FontSize = m_buttonSize * 0.3f;
		m_newRecord.Opasity = 1.0f;
	}
	
	if(m_getCoinsEnable)
	{
		[m_getCoinsBack ResetScale:GLKVector3Make(m_renderBox.ScreenWidth * 1.5f, m_renderBox.ScreenHeight * 0.7f, 0.0f)];
		[m_getCoinsBack ResetOpasity:0.0f];
		m_getCoinsBack.Scale = GLKVector3Make(m_renderBox.ScreenWidth, m_buttonSize * 0.75f, 0.0f);
		m_getCoinsBack.Opasity = 0.9f;
		
		[m_getCoinsText ResetFontSize: m_buttonSize * 1.5f];
		[m_getCoinsText ResetOpasity:0.0f];
		m_getCoinsText.FontSize = m_buttonSize * 0.5f;
		m_getCoinsText.Opasity = 1.0f;
		
		[m_getCoinsIcon ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
		[m_getCoinsIcon ResetOpasity:0.0f];
		m_getCoinsIcon.Width = m_buttonSize * 0.5f;
		m_getCoinsIcon.Opasity = 1.0f;
	}
	
	[m_coins ResetFontSize:fontsize * 2.0f];
	[m_coins ResetOpasity:0.0f];
	m_coins.FontSize = fontsize * 1.5f;;
	m_coins.Opasity = 1.0f;
	
	[m_coinsIcon ResetScale:GLKVector3Make(fontsize * 2.0f, fontsize * 2.0f, 0.0f)];
	[m_coinsIcon ResetOpasity:0.0f];
	m_coinsIcon.Scale = GLKVector3Make(m_coins.Width + m_buttonSize / 5.0f, m_coins.Height, 0.0f);
	m_coinsIcon.Opasity = 1.0f;
	
	[m_coinsC ResetFontSize:fontsize * 2.0f];
	[m_coinsC ResetOpasity:0.0f];
	m_coinsC.FontSize = fontsize * 1.5f;;
	m_coinsC.Opasity = 1.0f;

}

- (void)PresentSpend:(NSString *)text
{
	float fontsize = m_viewSize / 23.0f;
	
	[m_spendText ResetFontSize:fontsize * 2.0f];
	[m_spendText ResetOpasity:0.0f];
	m_spendText.FontSize = fontsize * 1.5f;;
	m_spendText.Opasity = 1.0f;
	
	m_spendText.Text = text;
	
	[m_spendTextTime SetLimitInSeconds:2.0f];
	[m_spendTextTime Reset];
}

- (void)Pause
{
	if(m_stage != PLAYING)return;
	m_stage = PAUSE;
	Level.Move = false;
	[self Resize];
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
	if(m_touchedButton)return;
	if((m_stage == FINISHED && !m_touchedButton) || m_stage == POWER)
	{
		GLKVector3 newRotation;
		
		float movex = x * 270.0f / m_viewSize;
		float movey = y * 270.0f / m_viewSize;
		
		if(Level.Zone == CL_ZONE_FRONT)
		{
			if(Level.ZoneUp == CL_ZONE_TOP)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-movey, -movex, 0.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BOTTOM)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(movey, movex, 0.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_RIGHT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-movex, movey, 0.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_LEFT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(movex, -movey, 0.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_BACK)
		{
			if(Level.ZoneUp == CL_ZONE_TOP)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(movey, -movex, 0.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BOTTOM)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-movey, movex, 0.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_RIGHT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-movex, -movey, 0.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_LEFT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(movex, movey, 0.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_RIGHT)
		{
			if(Level.ZoneUp == CL_ZONE_TOP)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_YZX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, -movex, movey));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BOTTOM)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_YZX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, movex, -movey));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_FRONT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, -movey, -movex));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BACK)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, movey, movex));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_LEFT)
		{
			if(Level.ZoneUp == CL_ZONE_TOP)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_YZX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, -movex, -movey));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BOTTOM)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_YZX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, movex, movey));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_FRONT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, movey, -movex));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BACK)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, -movey, movex));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_TOP)
		{
			if(Level.ZoneUp == CL_ZONE_FRONT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(movey, 0.0f, -movex));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BACK)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-movey, 0.0f, movex));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_RIGHT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_XZY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-movex, 0.0f, -movey));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_LEFT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_XZY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(movex, 0.0f, movey));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_BOTTOM)
		{
			if(Level.ZoneUp == CL_ZONE_FRONT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-movey, 0.0f, -movex));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BACK)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(movey, 0.0f,  movex));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_RIGHT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_XZY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-movex, 0.0f, movey));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_LEFT)
			{
				m_cubeCamera.PivotRotationStyle = VE_ROTATION_STYLE_XZY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(movex, 0.0f, -movey));
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
				m_newRecord.Opasity = 0.0f;
				m_getCoinsBack.Opasity = 0.0f;
				m_getCoinsText.Opasity = 0.0f;
				m_getCoinsIcon.Opasity = 0.0f;
				
				m_coins.Opasity = 0.0f;
				m_coinsIcon.Opasity = 0.0f;
				m_coinsC.Opasity = 0.0f;
			}
			m_showing = false;
			
			if(!m_touchedButton)
			{
				[m_watch Reset];
				[m_watch SetLimitInSeconds:1.0f];
			}
		}
	}
}

- (void)TouchPanEnd:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_touchedButton)return;
	
	if(m_stage == PLAYING || m_stage == FINISHED_TO_RESTART)
	{
		if(fabsf(x) > fabsf(y))
		{
			if(x > 0)
			{
				if(fabsf(y) > m_buttonSize / 3.0f)
				{
					if(y > 0)
						[Level doTurn:CL_TURN_RIGHT_DOWN];
					else
						[Level doTurn:CL_TURN_RIGHT_UP];
				}
				else
					[Level doTurn:CL_TURN_RIGHT];
			}
			else
			{
				if(fabsf(y) > m_buttonSize / 3.0f)
				{
					if(y > 0)
						[Level doTurn:CL_TURN_LEFT_DOWN];
					else
						[Level doTurn:CL_TURN_LEFT_UP];
				}
				else
					[Level doTurn:CL_TURN_LEFT];
			}
		}
		else
		{
			if(y > 0)
			{
				if(fabsf(x) > m_buttonSize / 3.0f)
				{
					if(x > 0)
						[Level doTurn:CL_TURN_DOWN_RIGHT];
					else
						[Level doTurn:CL_TURN_DOWN_LEFT];
				}
				else
					[Level doTurn:CL_TURN_DOWN];
			}
			else
			{
				if(fabsf(x) > m_buttonSize / 3.0f)
				{
					if(x > 0)
						[Level doTurn:CL_TURN_UP_RIGHT];
					else
						[Level doTurn:CL_TURN_UP_LEFT];
				}
				else
					[Level doTurn:CL_TURN_UP];
			}
		}
	}
}

- (void)TouchTap:(float)x Y:(float)y Fingers:(int)fingers Taps:(int)taps
{

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
			m_pauseButton.Width = m_buttonSize * 0.35f;
		}
		else if([self TestButton:m_timeRect X:rx Y:ry])
		{
			m_timeButton.Width = m_buttonSize * 0.35f;
		}
		else if([self TestButton:m_reductRect X:rx Y:ry])
		{
			m_reductButton.Width = m_buttonSize * 0.35f;
		}
		else if([self TestButton:m_ghostRect X:rx Y:ry])
		{
			m_ghostButton.Width = m_buttonSize * 0.35f;
		}
		else if([self TestButton:m_audioSetUpRect X:rx Y:ry])
		{
			m_audioSetUpOn.Width = m_buttonSize * 0.2f;
			m_audioSetUpOff.Height = m_buttonSize * 0.2f;
		}
		else
			m_touchedButton = false;
	}
	else if(m_stage == POWER)
	{
		if([self TestButton:m_timeRect X:rx Y:ry])
		{
			m_timeButton.Width = m_buttonSize * 0.35f;
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
		else if ([self TestButton:m_getCoinsRect X:rx Y:ry] && m_getCoinsEnable)
			m_getCoinsText.FontSize = m_buttonSize * 0.25f;
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
		else if([self TestButton:m_timeRect X:rx Y:ry])
		{
			if(m_stage == PLAYING && m_coinsEffect.Value > 0.0f)
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
				
				
				m_pauseButton.Opasity = 0.0f;
				m_bestScore.Opasity = 0.0f;
				m_points.Opasity = 0.0f;
				m_reductButton.Opasity = 0.0f;
				m_ghostButton.Opasity = 0.0f;
				m_audioSetUpOn.Opasity = 0.0f;
				m_audioSetUpOff.Opasity = 0.0f;
				m_special1.Opasity = 0.0f;
				m_special2.Opasity = 0.0f;
				m_special3.Opasity = 0.0f;
				m_special4.Opasity = 0.0f;
				m_special5.Opasity = 0.0f;
				
				[self PresentSpend:@"-$0"];
			}
		}
		else if([self TestButton:m_reductRect X:rx Y:ry])
		{
			if(m_totalCoins >= 1000)
			{
				if([Level Reduction])
				{
					m_totalCoins -= 1000;
					Level.Coins = m_totalCoins;
					GameData.Coins = m_totalCoins;
					m_coinsEffect.Value = m_totalCoins;
					[self PresentSpend:@"-$1000"];
				}
			}
		}
		else if([self TestButton:m_ghostRect X:rx Y:ry])
		{
			if(m_totalCoins >= 500)
			{
				m_totalCoins -= 500;
				Level.Coins = m_totalCoins;
				GameData.Coins = m_totalCoins;
				m_coinsEffect.Value = m_totalCoins;
				
				[Level MakeGhost];
				
				[self PresentSpend:@"-$500"];
			}
		}
		else if([self TestButton:m_audioSetUpRect X:rx Y:ry])
		{
			m_audioBox.Mute = !m_audioBox.Mute;
			if(m_audioBox.Mute)
			{
				m_audioSetUpOn.Opasity = 0.0f;
				m_audioSetUpOff.Opasity = 1.0f;
			}
			else
			{
				m_audioSetUpOn.Opasity = 1.0f;
				m_audioSetUpOff.Opasity = 0.0f;
			}
		}
		
		m_audioSetUpOn.Width = m_buttonSize / 3.0f;
		m_audioSetUpOff.Height = m_buttonSize / 3.0f;
		m_pauseButton.Width = m_buttonSize * 0.75f;
		m_timeButton.Width = m_buttonSize * 0.75f;
		m_reductButton.Width = m_buttonSize * 0.75f;
		m_ghostButton.Width = m_buttonSize * 0.75f;
	}
	else if(m_stage == POWER && m_touchedButton)
	{
		if([self TestButton:m_timeRect X:rx Y:ry])
		{
			m_stage = POWER_TO_PLAY;
			m_timeButton.Opasity = 0.0f;
			m_coins.Opasity = 0.0f;
			m_coinsIcon.Opasity = 0.0f;
			m_coinsC.Opasity = 0.0f;
		}
		m_timeButton.Width = m_buttonSize * 0.75f;
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
			
			m_special1Active = false;
			m_special2Active = false;
			m_special3Active = false;
			m_special4Active = false;
			m_special5Active = false;
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
			
			m_toNew = false;
			
			m_points.Opasity = 0.0f;
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
			m_newRecord.Opasity = 0.0f;;
			m_getCoinsBack.Opasity = 0.0f;
			m_getCoinsText.Opasity = 0.0f;
			m_getCoinsIcon.Opasity = 0.0f;
			
			m_coins.Opasity = 0.0f;
			m_coinsIcon.Opasity = 0.0f;
			m_coinsC.Opasity = 0.0f;
			
			m_cubeCamera.PivotRotationTransitionTime = 0.1;
			m_cubeCamera.PivotRotation = Level.FocusedCamera.PivotRotation;
			
			[m_playSound Play];
			
			Level.Finished = false;
		}
		else if([self TestButton:m_gcRect X:rx Y:ry])
		{
			[GameCenter presentGameCenter];
		}
		else if([self TestButton:m_exitRect X:rx Y:ry])
		{
			Exit = true;
		}
		else if ([self TestButton:m_getCoinsRect X:rx Y:ry] && m_getCoinsEnable)
		{
			m_getCoinsEnable = false;
			m_getCoinsBack.Opasity = 0.0f;
			m_getCoinsText.Opasity = 0.0f;
			m_getCoinsIcon.Opasity = 0.0f;
			[m_ads setUnityRewardedZone];
			[m_ads presentUnityAd];
		}
		m_getCoinsText.FontSize = m_buttonSize * 0.5f;
		m_restartButton.Width = m_buttonSize * 1.5f;
		m_gcButton.Width = m_buttonSize;
		m_exitButton.Width = m_buttonSize;
	}
	m_touchedButton = false;
}

- (void)unityAdsVideoCompleted:(NSString *)rewardItemKey skipped:(BOOL)skipped
{
	if(!skipped)
		Level.Coins += 1000;
}

- (void)Begin
{
	m_stage = PLAYING;
	m_cubeView.Camera = Level.FocusedCamera;
	
	[m_pointsEffect Reset];
	m_points.Text = @"0";
	
	[m_coinsEffect Reset];
	m_totalCoins = -1;
	m_coins.Text = @"0   ";
	
	[self Resize];
	[self PresentInterface];
	
	m_toNew = false;
	m_new = true;
	
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
	m_coinsC.Opasity = 0.0f;
	m_newRecord.Opasity = 0.0f;
	m_audioSetUpOn.Opasity = 0.0f;
	m_audioSetUpOff.Opasity = 0.0f;
	
	m_getCoinsBack.Opasity = 0.0f;
	m_getCoinsText.Opasity = 0.0f;
	m_getCoinsIcon.Opasity = 0.0f;
	
	m_timeButton.Opasity = 0.0f;
	m_reductButton.Opasity = 0.0f;
	m_ghostButton.Opasity = 0.0f;
	m_special1.Opasity = 0.0f;
	m_special2.Opasity = 0.0f;
	m_special3.Opasity = 0.0f;
	m_special4.Opasity = 0.0f;
	m_special5.Opasity = 0.0f;
	
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
	
	m_bestScore.Opasity = 0.0f;
	m_points.Opasity = 0.0f;
	m_pauseButton.Opasity = 0.0f;
	m_timeButton.Opasity = 0.0f;
	m_reductButton.Opasity = 0.0f;
	m_ghostButton.Opasity = 0.0f;
	m_audioSetUpOn.Opasity = 0.0f;
	m_audioSetUpOff.Opasity = 0.0f;
	m_special1.Opasity = 0.0f;
	m_special2.Opasity = 0.0f;
	m_special3.Opasity = 0.0f;
	m_special4.Opasity = 0.0f;
	m_special5.Opasity = 0.0f;
	
	m_special1Active = false;
	m_special2Active = false;
	m_special3Active = false;
	m_special4Active = false;
	m_special5Active = false;
	
	m_getCoinsEnable = [m_ads unityAdsCanShow];
	
	[self Resize];
	[self PresentFinishMenu];
	
	if(m_toNew)
		[m_newRecordSound Play];
	else
		[m_finishSound Play];
	
	Level.Coins += Level.Score * 4;
	
	[m_watch Reset];
	[m_watch SetLimitInSeconds:0.0f];
	[m_watch Frame:1.0f];
	
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