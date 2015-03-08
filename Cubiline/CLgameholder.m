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
	VEText* m_totalEaten;
	
	VESprite* m_scoreFinish;
	
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
	
	bool m_pressing;
	
	enum GH_STAGE
	{
		PLAYING,
		FINISHED,
		FINISHED_TO_RESTART,
		PAUSE
	};
	
	enum GH_STAGE m_stage;
	
	VEWatch* m_watch;
	
	int m_highScore;
	int m_total;
	
	//  buttons
	bool m_touchedButton;
	bool m_isDown;
	
	/// Finish check out game.
	GLKVector3 m_preRotation;
	bool m_showing;
	
	enum CL_GRAPHICS m_graphics;
}

- (bool)TestButton:(Rect)button X:(float)x Y:(float)y;
- (void)ToFinish;

- (void)SetForPlaying;
- (void)SetForPause;
- (void)SetForFinish;

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
		
		// Scene for full screen presentation.
		Scene = [m_renderBox NewSceneWithName:@"PlayGameScene"];
		
		// Cube view
		m_cubeView = [m_renderBox NewViewAs:VE_VIEW_TYPE_TEXTURE Width:10 Height:10];
		m_cubeView.ClearColor = WhiteBackgroundColor;
		m_cubeImage = [m_renderBox NewSpriteFromTexture:m_cubeView.Color];
		if(m_graphics == CL_GRAPHICS_HIGH)
			m_cubeView.RenderMode = VE_RENDER_MODE_FRAGMENT_LIGHT;
		else if(m_graphics == CL_GRAPHICS_MEDIUM)
			m_cubeView.RenderMode = VE_RENDER_MODE_VERTEX_LIGHT;
		else
			m_cubeView.RenderMode = VE_RENDER_MODE_DIFFUSE;
		
		// Points text
		m_points = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"0"];
		m_points.Color = GrayColor;
		m_points.Opasity = 0.0f;
		m_points.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_points.OpasityTransitionTime = 0.15f;
		m_points.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_points.PositionTransitionTime = 0.7f;
		m_points.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_points.ScaleTransitionTime = 0.4f;
		
		m_bestScore = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Best:0"];
		m_bestScore.Color = FrontColor;
		m_bestScore.Opasity = 0.0f;
		m_bestScore.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_bestScore.OpasityTransitionTime = 0.15f;
		m_bestScore.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_bestScore.PositionTransitionTime = 0.7f;
		m_bestScore.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_bestScore.ScaleTransitionTime = 0.4f;
		
		m_totalEaten = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"0"];
		m_totalEaten.Color = GrayColor;
		m_totalEaten.Opasity = 0.0f;
		m_totalEaten.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_totalEaten.OpasityTransitionTime = 0.15f;
		m_totalEaten.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_totalEaten.PositionTransitionTime = 0.7f;
		
		m_pointsEffect = [[VEEffect1 alloc] init];
		m_pointsEffect.TransitionEffect = VE_TRANSITION_EFFECT_HARD;
		m_pointsEffect.TransitionTime = 0.4f;
		
		m_pauseButton = [m_renderBox NewSpriteFromFileName:@"game_pause.png"];
		m_pauseButton.Opasity = 0.0f;
		m_pauseButton.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_pauseButton.OpasityTransitionTime = 0.15f;
		m_pauseButton.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_pauseButton.ScaleTransitionTime = 0.1f;
		m_pauseButton.LockAspect = true;
		
		m_pauseFade = [m_renderBox NewSolidSpriteWithColor:GrayColor];
		m_pauseFade.Opasity = 0.0f;
		m_pauseFade.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_pauseFade.OpasityTransitionTime = 0.15f;
		
		m_continueButton = [m_renderBox NewSpriteFromFileName:@"game_continue.png"];
		m_continueButton.Opasity = 0.0f;
		m_continueButton.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_continueButton.OpasityTransitionTime = 0.15f;
		m_continueButton.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_continueButton.ScaleTransitionTime = 0.1f;
		m_continueButton.LockAspect = true;
		
		m_restartButton = [m_renderBox NewSpriteFromFileName:@"game_restart.png"];
		m_restartButton.Opasity = 0.0f;
		m_restartButton.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_restartButton.OpasityTransitionTime = 0.15f;
		m_restartButton.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_restartButton.ScaleTransitionTime = 0.1f;
		m_restartButton.LockAspect = true;
		
		m_exitButton = [m_renderBox NewSpriteFromFileName:@"game_exit.png"];
		m_exitButton.Opasity = 0.0f;
		m_exitButton.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_exitButton.OpasityTransitionTime = 0.15f;
		m_exitButton.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_exitButton.ScaleTransitionTime = 0.1f;
		m_exitButton.LockAspect = true;
		
		m_gcButton = [m_renderBox NewSpriteFromFileName:@"game_gc.png"];
		m_gcButton.Opasity = 0.0f;
		m_gcButton.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_gcButton.OpasityTransitionTime = 0.15f;
		m_gcButton.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_gcButton.ScaleTransitionTime = 0.1f;
		m_gcButton.LockAspect = true;
		
		m_continueText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Continue"];
		m_continueText.Opasity = 0.0f;
		m_continueText.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_continueText.OpasityTransitionTime = 0.15f;
		m_continueText.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_continueText.ScaleTransitionTime = 0.1f;
		
		m_restartText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Restart"];
		m_restartText.Opasity = 0.0f;
		m_restartText.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_restartText.OpasityTransitionTime = 0.15f;
		m_restartText.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_restartText.ScaleTransitionTime = 0.1f;

		m_gcText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Scores"];
		m_gcText.Opasity = 0.0f;
		m_gcText.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_gcText.OpasityTransitionTime = 0.15f;
		m_gcText.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_gcText.ScaleTransitionTime = 0.1f;
		
		m_exitText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Main Menu"];
		m_exitText.Opasity = 0.0f;
		m_exitText.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_exitText.OpasityTransitionTime = 0.15f;
		m_exitText.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_exitText.ScaleTransitionTime = 0.1f;
		
		// Camera SetUp
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
		m_cubeCamera.DepthOfField = false;
		m_cubeCamera.Far = 60.0f;
		m_cubeCamera.Near = 1.0f;
		m_cubeCamera.FocusRange = 15.0f;
		
		m_scoreFinish = [m_renderBox NewSolidSpriteWithColor:PrimaryColor];
		m_scoreFinish.Opasity = 0.0f;
		m_scoreFinish.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_scoreFinish.OpasityTransitionTime = 0.15f;
		m_scoreFinish.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_scoreFinish.ScaleTransitionTime = 0.1f;
		
		
		// Scene viewable objects
		[Scene addSprite:m_cubeImage];
		[Scene addSprite:m_scoreFinish];
		[Scene addText:m_points];
		[Scene addText:m_bestScore];
		[Scene addText:m_totalEaten];
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
		
		m_watch = [[VEWatch alloc] init];
		m_watch.Style = VE_WATCH_STYLE_LIMITED;
		
		m_stage = PLAYING;
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
			m_points.Position = GLKVector3Make(m_renderBox.ScreenWidth / 2 - m_points.Width / 2 - m_points.Height / 2, m_renderBox.ScreenHeight / 2 - m_points.Height, 0.0f);
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
			m_bestScore.Position = GLKVector3Make(m_renderBox.ScreenWidth / 2 - m_bestScore.Width / 2 - m_points.Height / 2, m_renderBox.ScreenHeight / 2 - m_points.Height * 1.5f, 0.0f);
		}
		
		if(m_total != Level.Grown)
		{
			m_total = Level.Grown;
			
			if(GameData.Grown > m_total)
			{
				m_total = GameData.Grown;
				Level.Grown = m_total;
			}
			else
				GameData.Grown = m_total;
			m_totalEaten.Text = [NSString stringWithFormat:@"%d", m_total];
			m_totalEaten.Position = GLKVector3Make(m_renderBox.ScreenWidth / 2 - m_totalEaten.Width / 2 - m_points.Height / 4, -m_renderBox.ScreenHeight / 2 + m_points.Height / 4.0f, 0.0f);
		}
	}
	else if(m_stage == FINISHED)
	{
		[m_watch Frame:time];
		if(!m_watch.Active && !m_showing)
		{
			m_points.Opasity = 1.0f;
			m_scoreFinish.Opasity = 0.9f;
			m_restartButton.Opasity = 1.0f;
			m_gcButton.Opasity = 1.0f;
			m_exitButton.Opasity = 1.0f;
			m_restartText.Opasity = 1.0f;
			m_gcText.Opasity = 1.0f;
			m_exitText.Opasity = 1.0f;
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
	float spriteSize;
	
	// Best size from the screen.
	if(width > height)
	{
		spriteSize = height;
		m_buttonSize = height / 5.0f;
	}
	else
	{
		spriteSize = width;
		m_buttonSize = width / 5.0f;
	}
	
	// Resize elements.
	[m_cubeView ResizeWithWidth:spriteSize Height:spriteSize];
	m_cubeImage.Scale = GLKVector3Make(spriteSize, -spriteSize, 0.0f);
	
	if(m_stage == PLAYING)
	{
		[self SetForPlaying];
	}
	else if(m_stage == PAUSE)
	{
		[self SetForPause];
	}
	else if(m_stage == FINISHED)
	{
		[self SetForFinish];
	}
}

- (bool)TestButton:(Rect)button X:(float)x Y:(float)y
{
	return (button.top > y && button.bottom < y && button.left < x && button.right > x);
}

- (void)TouchPanBegan:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_stage == FINISHED)
	{
		m_preRotation = m_cubeCamera.PivotRotation;
	}
}

- (void)TouchPanChange:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_stage == FINISHED && !m_touchedButton)
	{
		GLKVector3 newRotation;
		if(Level.Zone == CL_ZONE_FRONT)
		{
			if(Level.ZoneUp == CL_ZONE_TOP)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-y / 4.0f, -x / 4.0f, 0.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BOTTOM)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(y / 4.0f, x / 4.0f, 0.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_RIGHT)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-x / 4.0f, y / 4.0f, 0.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_LEFT)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(x / 4.0f, -y / 4.0f, 0.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_BACK)
		{
			if(Level.ZoneUp == CL_ZONE_TOP)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(y / 4.0f, -x / 4.0f, 0.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BOTTOM)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-y / 4.0f, x / 4.0f, 0.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_RIGHT)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-x / 4.0f, -y / 4.0f, 0.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_LEFT)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-x / 4.0f, -y / 4.0f, 0.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_RIGHT)
		{
			if(Level.ZoneUp == CL_ZONE_TOP)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_YZX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, -x / 4.0f, y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BOTTOM)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_YZX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, x / 4.0f, -y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_FRONT)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, -y / 4.0f, -x / 4.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BACK)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, y / 4.0f, x / 4.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_LEFT)
		{
			if(Level.ZoneUp == CL_ZONE_TOP)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_YZX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, -x / 4.0f, -y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BOTTOM)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_YZX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, x / 4.0f, y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_FRONT)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, y / 4.0f, -x / 4.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BACK)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZYX;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, -y / 4.0f, x / 4.0f));
				newRotation.y = MIN(MAX(newRotation.y, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_TOP)
		{
			if(Level.ZoneUp == CL_ZONE_FRONT)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(y / 4.0f, 0.0f, -x / 4.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BACK)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-y / 4.0f, 0.0f, -x / 4.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_RIGHT)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_XZY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-x / 4.0f, 0.0f, -y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_LEFT)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_XZY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(x / 4.0f, 0.0f, y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
		}
		else if(Level.Zone == CL_ZONE_BOTTOM)
		{
			if(Level.ZoneUp == CL_ZONE_FRONT)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-y / 4.0f, 0.0f, -x / 4.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_BACK)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_ZXY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(y / 4.0f, 0.0f,  x / 4.0f));
				newRotation.x = MIN(MAX(newRotation.x, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_RIGHT)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_XZY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(-x / 4.0f, 0.0f, y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
			else if(Level.ZoneUp == CL_ZONE_LEFT)
			{
				m_cubeCamera.PivotRotationStyle = VE_PIVOT_ROTATION_XZY;
				newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(x / 4.0f, 0.0f, -y / 4.0f));
				newRotation.z = MIN(MAX(newRotation.z, -60.0f), 60.0f);
			}
		}
		
		
		m_cubeCamera.PivotRotation = newRotation;
		
		if(m_showing)
		{
			m_points.Opasity = 0.0f;
			m_scoreFinish.Opasity = 0.0f;
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

- (void)TouchTap:(float)x Y:(float)y Fingers:(int)fingers
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
			m_stage = PAUSE;
			Level.Move = false;
			m_pauseButton.Opasity = 0.0;
			m_points.Opasity = 0.0f;
			m_bestScore.Opasity = 0.0f;
			m_totalEaten.Opasity = 0.0f;
			m_pauseFade.Opasity = 0.9f;
			m_continueButton.Opasity = 1.0f;
			m_restartButton.Opasity = 1.0f;
			m_gcButton.Opasity = 1.0f;
			m_exitButton.Opasity = 1.0f;
			m_continueText.Opasity = 1.0f;
			m_restartText.Opasity = 1.0f;
			m_gcText.Opasity = 1.0f;
			m_exitText.Opasity = 1.0f;
			[self SetForPause];
		}
		m_pauseButton.Width = m_buttonSize / 2.0f;
	}
	else if(m_stage == PAUSE && m_touchedButton)
	{
		if([self TestButton:m_continueRect X:rx Y:ry])
		{
			m_stage = PLAYING;
			Level.Move = true;
			m_pauseButton.Opasity = 1.0;
			m_points.Opasity = 1.0f;
			m_bestScore.Opasity = 1.0f;
			m_totalEaten.Opasity = 1.0f;
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
			m_pauseButton.Opasity = 1.0;
			m_points.Opasity = 1.0f;
			m_bestScore.Opasity = 1.0f;
			m_totalEaten.Opasity = 1.0f;
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
			[m_points ResetFontSize:m_buttonSize / 2.0f];
			[m_points Frame:0.0f];
			[m_points ResetPosition:GLKVector3Make(m_renderBox.ScreenWidth / 2 - m_points.Width / 2 - m_points.Height / 2, m_renderBox.ScreenHeight / 2 - m_points.Height, 0.0f)];
			[m_points Frame:0.0f];
			
			Level.Finished = false;
			
			m_pauseButton.Opasity = 1.0;
			m_points.Opasity = 1.0f;
			m_bestScore.Opasity = 1.0f;
			m_totalEaten.Opasity = 1.0f;
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
			
			m_cubeCamera.PivotRotationTransitionTime = 0.1;
			m_cubeCamera.PivotRotation = Level.FocusedCamera.PivotRotation;
			
			[self SetForPlaying];
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
	float width = m_renderBox.ScreenWidth;
	float height = m_renderBox.ScreenHeight;
	[m_points ResetPosition:GLKVector3Make(m_renderBox.ScreenWidth / 2 - m_points.Width / 2 - m_points.Height / 2, m_renderBox.ScreenHeight / 2 - m_points.Height, 0.0f)];
	[m_points ResetFontSize:width > height ? height / 10 : width / 10];
	[m_points Frame:0.0f];
	m_points.Opasity = 1.0f;
	m_bestScore.Opasity = 1.0f;
	m_totalEaten.Opasity = 1.0f;
	m_pauseButton.Opasity = 1.0f;
	m_stage = PLAYING;
	m_cubeView.Camera = Level.FocusedCamera;
	
	[self SetForPlaying];
	
	Exit = false;
}

- (void)OutToMainMenu
{
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
	m_points.Opasity = 0.0f;
	

	
	[m_cubeCamera ResetPivot:Level.FocusedCamera.Pivot];
	[m_cubeCamera ResetPosition:[Level.FocusedCamera PositionWOR]];
	[m_cubeCamera ResetViewUp:Level.FocusedCamera.ViewUp];
	[m_cubeCamera ResetPivotRotation:Level.FocusedCamera.PivotRotation];
	[m_cubeCamera Frame:0.0f];
	
	m_cubeCamera.PivotRotationTransitionTime = 0.2f;
	
	m_cubeView.Camera = m_cubeCamera;
	[Level Restore];
	
	m_stage = PLAYING;
	
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
		
		Level.BackWall.Color = FrontColor;
	}
	
	if(Level.Zone == CL_ZONE_RIGHT)
	{
		m_cubeCamera.Pivot = GLKVector3Make(-7.5f, 0.0f, 0.0f);
		m_cubeCamera.Position = GLKVector3Make(7.5f, 0.0f, 0.0f);
		m_cubeCamera.PivotRotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
		
		Level.RightWall.Color = FrontColor;
	}
	
	if(Level.Zone == CL_ZONE_LEFT)
	{
		m_cubeCamera.Pivot = GLKVector3Make(7.5f, 0.0f, 0.0f);
		m_cubeCamera.Position = GLKVector3Make(-7.5f, 0.0f, 0.0f);
		m_cubeCamera.PivotRotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
		
		Level.LeftWall.Color = FrontColor;
	}
	
	if(Level.Zone == CL_ZONE_TOP)
	{
		m_cubeCamera.Pivot = GLKVector3Make(0.0f, -7.5f, 0.0f);
		m_cubeCamera.Position = GLKVector3Make(0.0f, 7.5f, 0.0f);
		m_cubeCamera.PivotRotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
		
		Level.TopWall.Color = FrontColor;
	}
	
	if(Level.Zone == CL_ZONE_BOTTOM)
	{
		m_cubeCamera.Pivot = GLKVector3Make(0.0f, 7.5f, 0.0f);
		m_cubeCamera.Position = GLKVector3Make(0.0f, -7.5f, 0.0f);
		m_cubeCamera.PivotRotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
		
		Level.BottomWall.Color = FrontColor;
	}

	[m_watch Reset];
	[m_watch SetLimitInSeconds:0.5f];
}

- (bool)OutReady
{
	return !m_watch.Active;
}

- (void)setLevel:(CLLevel *)level
{
	Level = level;
	m_cubeView.Scene = Level.Scene;
	m_cubeView.Camera = Level.FocusedCamera;
}

- (void)SetForPlaying
{
	float width = m_renderBox.ScreenWidth;
	float height = m_renderBox.ScreenHeight;
	
	// Best size from the screen.
	if(width > height)
		m_buttonSize = height / 5.0f;
	else
		m_buttonSize = width / 5.0f;

	m_points.FontSize = width > height ? height / 10 : width / 10;
	m_points.Position = GLKVector3Make(width / 2 - m_points.Width / 2 - m_points.Height / 2, height / 2 - m_points.Height, 0.0f);
	
	m_bestScore.FontSize = width > height ? height / 23 : width / 23;
	m_bestScore.Position = GLKVector3Make(m_renderBox.ScreenWidth / 2 - m_bestScore.Width / 2 - m_points.Height / 2, m_renderBox.ScreenHeight / 2 - m_points.Height * 1.5f, 0.0f);
	
	m_totalEaten.FontSize = width > height ? height / 30 : width / 30;
	m_totalEaten.Position = GLKVector3Make(m_renderBox.ScreenWidth / 2 - m_totalEaten.Width / 2 - m_points.Height / 4, -m_renderBox.ScreenHeight / 2 + m_points.Height / 4.0f, 0.0f);
	
	m_pauseButton.Height = m_buttonSize / 2.0f;
	m_pauseButton.Position = GLKVector3Make(-width / 2 + m_buttonSize / 2.0f, height / 2 - m_buttonSize / 2.0f, 0.0f);
	
	m_pauseRect.top =  height / 2;
	m_pauseRect.bottom = m_pauseRect.top - m_buttonSize;
	m_pauseRect.left = -width / 2;
	m_pauseRect.right = m_pauseRect.left + m_buttonSize;
}

- (void)SetForPause
{
	float width = m_renderBox.ScreenWidth;
	float height = m_renderBox.ScreenHeight;
	
	// Best size from the screen.
	if(width > height)
		m_buttonSize = height / 5.0f;
	else
		m_buttonSize = width / 5.0f;
	
	// Continue button
	[m_continueButton ResetScale:GLKVector3Make(m_buttonSize * 3.5f, m_buttonSize * 3.5f, 0.0f)];
	m_continueButton.Width = m_buttonSize * 2.0f;
	m_continueButton.Position = GLKVector3Make(0.0f, m_buttonSize / 2.0f, 0.0f);
	
	[m_continueText ResetFontSize:m_buttonSize];
	m_continueText.Position = GLKVector3Make(0.0, m_buttonSize / 2.0f - m_buttonSize * 1.1f, 0.0f);
	m_continueText.FontSize = m_buttonSize * 0.4f;
	
	m_continueRect.top =  m_buttonSize / 2.0f + m_buttonSize;
	m_continueRect.bottom = m_continueRect.top - m_buttonSize * 2.0f;
	m_continueRect.left = -m_buttonSize;
	m_continueRect.right = m_buttonSize;
	
	// Restart button
	[m_restartButton ResetScale:GLKVector3Make(m_buttonSize * 2.0f, m_buttonSize * 2.0f, 0.0f)];
	m_restartButton.Width = m_buttonSize;
	m_restartButton.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.5f, 0.0f);
	
	[m_restartText ResetFontSize:m_buttonSize];
	m_restartText.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.5f - m_buttonSize * 0.55f, 0.0f);
	m_restartText.FontSize = m_buttonSize * 0.2f;
	
	m_restartRect.top = -m_buttonSize * 1.5f + m_buttonSize / 2.0f;
	m_restartRect.bottom = m_restartRect.top - m_buttonSize;
	m_restartRect.left = -m_buttonSize / 2.0f;
	m_restartRect.right = m_restartRect.left + m_buttonSize;
	
	// Game Center button
	[m_gcButton ResetScale:GLKVector3Make(m_buttonSize * 2.0f, m_buttonSize * 2.0f, 0.0f)];
	m_gcButton.Width = m_buttonSize;
	m_gcButton.Position = GLKVector3Make(-width / 2.0f + m_buttonSize, -height / 2.0f + m_buttonSize, 0.0f);
	
	[m_gcText ResetFontSize:m_buttonSize];
	m_gcText.Position = GLKVector3Make(-width / 2.0f + m_buttonSize, -height / 2.0f + m_buttonSize - m_buttonSize * 0.55f, 0.0f);
	m_gcText.FontSize = m_buttonSize * 0.2f;
	
	m_gcRect.top = -height / 2.0f + m_buttonSize * 1.5f;
	m_gcRect.bottom = m_gcRect.top - m_buttonSize;
	m_gcRect.left = -width / 2.0f + m_buttonSize / 2.0f;
	m_gcRect.right = m_gcRect.left + m_buttonSize;
	
	// Exit button
	[m_exitButton ResetScale:GLKVector3Make(m_buttonSize * 2.0f, m_buttonSize * 2.0f, 0.0f)];
	m_exitButton.Width = m_buttonSize;
	m_exitButton.Position = GLKVector3Make(width / 2.0f - m_buttonSize, -height / 2.0f + m_buttonSize, 0.0f);
	
	[m_exitText ResetFontSize:m_buttonSize];
	m_exitText.Position = GLKVector3Make(width / 2.0f - m_buttonSize, -height / 2.0f + m_buttonSize - m_buttonSize * 0.55f, 0.0f);
	m_exitText.FontSize = m_buttonSize * 0.2f;
	
	m_exitRect.top = m_gcRect.top;
	m_exitRect.bottom = m_gcRect.bottom;
	m_exitRect.right = width / 2.0f - m_buttonSize / 2.0f;
	m_exitRect.left = m_exitRect.right - m_buttonSize;
	
	m_pauseFade.Width = m_renderBox.ScreenWidth;
	m_pauseFade.Height = m_renderBox.ScreenHeight;
}

- (void)SetForFinish
{
	[m_points ResetFontSize:m_buttonSize * 2.0f];
	[m_points ResetPosition:GLKVector3Make(0.0f, -m_buttonSize * 0.1, 0.0f)];
	[m_points Frame:0.0f];
	m_points.FontSize = m_buttonSize;
	
	[m_scoreFinish ResetScale:GLKVector3Make(m_renderBox.ScreenWidth * 1.5f, m_renderBox.ScreenHeight * 1.5f, 0.0f)];
	m_scoreFinish.Width = m_renderBox.ScreenWidth;
	m_scoreFinish.Height = m_buttonSize * 1.6f;
	m_scoreFinish.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.15, 0.0f);
	
	[m_restartButton ResetScale:GLKVector3Make(m_buttonSize * 3.0f, m_buttonSize * 3.0f, 0.0f)];
	[m_restartButton Frame:0.0f];
	m_restartButton.Width = m_buttonSize * 1.5;
	m_restartButton.Position = GLKVector3Make(0.0f, -m_buttonSize, 0.0f);
	
	[m_restartText ResetFontSize:m_buttonSize];
	m_restartText.Position = GLKVector3Make(0.0f, -m_buttonSize * 1.8f, 0.0f);
	m_restartText.FontSize = m_buttonSize / 4.0f;
	
	m_restartRect.top = -m_buttonSize + m_buttonSize * 0.75f;
	m_restartRect.bottom = m_restartRect.top - m_buttonSize * 1.5f;
	m_restartRect.left = -m_buttonSize * 0.75f;
	m_restartRect.right = m_restartRect.left + m_buttonSize * 1.5f;
	
	// Game Center button
	[m_gcButton ResetScale:GLKVector3Make(m_buttonSize * 3.0f, m_buttonSize * 3.0f, 0.0f)];
	m_gcButton.Width = m_buttonSize;
	m_gcButton.Position = GLKVector3Make(-m_buttonSize * 1.5f, -m_buttonSize, 0.0f);
	
	[m_gcText ResetFontSize:m_buttonSize];
	m_gcText.Position = GLKVector3Make(-m_buttonSize * 1.5f, -m_buttonSize * 1.6f, 0.0f);
	m_gcText.FontSize = m_buttonSize / 4.0f;
	
	m_gcRect.top = -m_buttonSize + m_buttonSize * 0.5f;
	m_gcRect.bottom = m_gcRect.top - m_buttonSize;
	m_gcRect.left = -m_buttonSize * 2.0f;
	m_gcRect.right = m_gcRect.left + m_buttonSize;
	
	// Exit button
	[m_exitButton ResetScale:GLKVector3Make(m_buttonSize * 3.0f, m_buttonSize * 3.0f, 0.0f)];
	m_exitButton.Width = m_buttonSize;
	m_exitButton.Position = GLKVector3Make(m_buttonSize * 1.5f, -m_buttonSize, 0.0f);
	
	[m_exitText ResetFontSize:m_buttonSize];
	m_exitText.Position = GLKVector3Make(m_buttonSize * 1.5f, -m_buttonSize * 1.6f, 0.0f);
	m_exitText.FontSize = m_buttonSize / 4.0f;
	
	m_exitRect.top = -m_buttonSize + m_buttonSize * 0.5f;
	m_exitRect.bottom = m_exitRect.top - m_buttonSize;
	m_exitRect.right = m_buttonSize * 2.0f;
	m_exitRect.left = m_exitRect.right - m_buttonSize;
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
	m_totalEaten.Opasity = 0.0f;
	m_pauseButton.Opasity = 0.0f;
	
	m_restartButton.Opasity = 1.0f;
	m_restartText.Opasity = 1.0f;
	
	m_gcButton.Opasity = 1.0f;
	m_gcText.Opasity = 1.0f;
	
	m_exitButton.Opasity = 1.0f;
	m_exitText.Opasity = 1.0f;
	
	m_scoreFinish.Opasity = 0.9f;
	
	m_showing = true;
	
	[self SetForFinish];
}

- (CLLevel*)Level
{
	return Level;
}

@end