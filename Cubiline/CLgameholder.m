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
	
	VESprite* m_pauseButton;
	Rect m_pauseRect;
	
	VESprite* m_pauseFade;
	
	VESprite* m_continueButton;
	VEText* m_continueText;
	Rect m_continueRect;
	
	VESprite* m_restartButton;
	VEText* m_restartText;
	Rect m_restartRect;
	
	VESprite* m_changeButton;
	VEText* m_changeText;
	Rect m_changeRect;
	
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
		PAUSE
	};
	
	enum GH_STAGE m_stage;
	
	VEWatch* m_watch;
	
	int m_highScore;
}

- (bool)TestButton:(Rect)button X:(float)x Y:(float)y;

@end

@implementation CLGameHolder

@synthesize Level;
@synthesize Scene;
@synthesize Exit;

- (id)initWithRenderBox:(VERenderBox*)renderbox
{
	self = [super init];
	
	if(self)
	{
		m_renderBox = renderbox;
		
		// Scene for full screen presentation.
		Scene = [m_renderBox NewSceneWithName:@"PlayGameScene"];
		
		// Cube view
		m_cubeView = [m_renderBox NewViewAs:VE_VIEW_TYPE_TEXTURE Width:10 Height:10];
		m_cubeView.ClearColor = WhiteBackgroundColor;
		m_cubeImage = [m_renderBox NewSpriteFromTexture:m_cubeView.Color];
		m_cubeView.EnableLight = false;
		
		
		// Points text
		m_points = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"0"];
		m_points.Color = GrayColor;
		m_points.Opasity = 0.0f;
		m_points.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_points.OpasityTransitionTime = 0.15f;
		m_points.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_points.PositionTransitionTime = 0.7f;
		
		m_bestScore = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"0"];
		m_bestScore.Color = GrayColor;
		m_bestScore.Opasity = 0.0f;
		m_bestScore.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_bestScore.OpasityTransitionTime = 0.15f;
		m_bestScore.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_bestScore.PositionTransitionTime = 0.7f;
		
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
		
		m_changeButton = [m_renderBox NewSpriteFromFileName:@"game_change.png"];
		m_changeButton.Opasity = 0.0f;
		m_changeButton.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_changeButton.OpasityTransitionTime = 0.15f;
		m_changeButton.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_changeButton.ScaleTransitionTime = 0.1f;
		m_changeButton.LockAspect = true;
		
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
		
		m_restartText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Restart"];
		m_restartText.Opasity = 0.0f;
		m_restartText.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_restartText.OpasityTransitionTime = 0.15f;
		
		m_changeText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Change Game"];
		m_changeText.Opasity = 0.0f;
		m_changeText.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_changeText.OpasityTransitionTime = 0.15f;
		
		m_gcText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Scores"];
		m_gcText.Opasity = 0.0f;
		m_gcText.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_gcText.OpasityTransitionTime = 0.15f;
		
		m_exitText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Main Menu"];
		m_exitText.Opasity = 0.0f;
		m_exitText.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_exitText.OpasityTransitionTime = 0.15f;
		
		// Camera SetUp
		m_cubeCamera = [m_renderBox NewCamera:VE_CAMERA_TYPE_PERSPECTIVE];
		m_cubeCamera.PivotTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_cubeCamera.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_cubeCamera.PivotRotationTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_cubeCamera.PivotTransitionTime = 0.4f;
		m_cubeCamera.PositionTransitionTime = 0.4f;
		m_cubeCamera.PivotRotationTransitionTime = 0.2f;
		m_cubeCamera.LockLookAt = true;
		m_cubeCamera.DepthOfField = false;
		m_cubeCamera.Far = 60.0f;
		m_cubeCamera.Near = 1.0f;
		m_cubeCamera.FocusRange = 15.0f;
		
		// Scene viewable objects
		[Scene addSprite:m_cubeImage];
		[Scene addText:m_points];
		[Scene addText:m_bestScore];
		[Scene addSprite:m_pauseButton];
		[Scene addSprite:m_pauseFade];
		[Scene addSprite:m_continueButton];
		[Scene addSprite:m_exitButton];
		[Scene addSprite:m_changeButton];
		[Scene addSprite:m_gcButton];
		[Scene addSprite:m_restartButton];
		[Scene addText:m_continueText];
		[Scene addText:m_restartText];
		[Scene addText:m_changeText];
		[Scene addText:m_gcText];
		[Scene addText:m_exitText];
		
		m_watch = [[VEWatch alloc] init];
		m_watch.Style = VE_WATCH_STYLE_LIMITED;
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
	
	bool active = m_pointsEffect.IsActive;
	[m_pointsEffect Frame:time];
	
	if(Level.Points != m_pointsEffect.Value)
	{
		if(Level.Points == m_pointsEffect.Value + 1)
		{
			[m_pointsEffect Reset:Level.Points];
			active = true;
		}
		else
			m_pointsEffect.Value = Level.Points;
	}
	
	int high = [GameKitHelper sharedGameKitHelper].HighScore;
	
	if(high != m_highScore)
	{
		m_highScore = high;
		m_bestScore.Text = [NSString stringWithFormat:@"%d", m_highScore];
		m_bestScore.Position = GLKVector3Make(m_renderBox.ScreenWidth / 2 - m_points.Width / 2 - m_points.Height / 2, m_renderBox.ScreenHeight / 2 - m_points.Height * 2.0f, 0.0f);
	}
	
	if(active)
	{
		m_points.Text = [NSString stringWithFormat:@"%d", (int)m_pointsEffect.Value];
		m_points.Position = GLKVector3Make(m_renderBox.ScreenWidth / 2 - m_points.Width / 2 - m_points.Height / 2, m_renderBox.ScreenHeight / 2 - m_points.Height, 0.0f);
	}
}

- (void)Render
{
	[m_cubeView Render];
	// Get the new texture generate in the view.
	m_cubeImage.Texture = m_cubeView.Color;
}

- (void)Begin
{
	m_points.Opasity = 1.0f;
	m_bestScore.Opasity = 1.0f;
	m_pauseButton.Opasity = 1.0f;
	m_stage = PLAYING;
	m_cubeView.Camera = Level.FocusedCamera;
	
	Exit = false;
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
	
	m_points.FontSize = width > height ? height / 10 : width / 10;
	m_points.Position = GLKVector3Make(width / 2 - m_points.Width / 2 - m_points.Height / 2, height / 2 - m_points.Height, 0.0f);
	
	m_bestScore.FontSize = width > height ? height / 11 : width / 11;
	m_bestScore.Position = GLKVector3Make(width / 2 - m_points.Width / 2 - m_points.Height / 2, height / 2 - m_points.Height * 2.0f, 0.0f);
	
	m_pauseButton.Height = m_buttonSize / 2.0f;
	m_pauseButton.Position = GLKVector3Make(-width / 2 + m_buttonSize / 2.0f, height / 2 - m_buttonSize / 2.0f, 0.0f);

	m_pauseRect.top =  height / 2 - m_buttonSize / 4.0f;
	m_pauseRect.bottom = m_pauseRect.top - m_buttonSize;
	m_pauseRect.left = -width / 2 + m_buttonSize / 4.0f;
	m_pauseRect.right = m_pauseRect.left + m_buttonSize;
	
	m_pauseFade.Width = width;
	m_pauseFade.Height = height;
	
	m_continueButton.Width = m_buttonSize * 2.0f;
	m_restartButton.Width = m_buttonSize;
	m_changeButton.Width = m_buttonSize;
	m_gcButton.Width = m_buttonSize;
	m_exitButton.Width = m_buttonSize;
	
	m_restartButton.Position = GLKVector3Make(-m_buttonSize * 1.5f, 0.0f, 0.0f);
	m_changeButton.Position = GLKVector3Make(m_buttonSize * 1.5f, 0.0f, 0.0);
	
	m_gcButton.Position = GLKVector3Make(-width / 2.0f + m_buttonSize, -height / 2.0f + m_buttonSize, 0.0f);
	m_exitButton.Position = GLKVector3Make(width / 2.0f - m_buttonSize, -height / 2.0f + m_buttonSize, 0.0f);
	
	m_continueText.FontSize = m_buttonSize * 0.4f;
	m_continueText.Position = GLKVector3Make(0.0, -m_buttonSize * 1.1f, 0.0f);
	
	m_restartText.FontSize = m_buttonSize * 0.2f;
	m_restartText.Position = GLKVector3Make(-m_buttonSize * 1.5f, -m_buttonSize * 0.55f, 0.0f);
	
	m_changeText.FontSize = m_buttonSize * 0.2f;
	m_changeText.Position = GLKVector3Make(m_buttonSize * 1.5f, -m_buttonSize * 0.55f, 0.0f);
	
	m_gcText.FontSize = m_buttonSize * 0.2f;
	m_gcText.Position = GLKVector3Make(-width / 2.0f + m_buttonSize, -height / 2.0f + m_buttonSize - m_buttonSize * 0.55f, 0.0f);
	
	m_exitText.FontSize = m_buttonSize * 0.2f;
	m_exitText.Position = GLKVector3Make(width / 2.0f - m_buttonSize, -height / 2.0f + m_buttonSize - m_buttonSize * 0.55f, 0.0f);
	
	m_continueRect.top = m_buttonSize;
	m_continueRect.bottom = -m_buttonSize;
	m_continueRect.left = -m_buttonSize;
	m_continueRect.right = m_buttonSize;
	
	m_restartRect.top = m_buttonSize * 0.55f + m_buttonSize / 2.0f;
	m_restartRect.bottom = m_exitRect.top - m_buttonSize;
	m_restartRect.left = -m_buttonSize * 2.0f;
	m_restartRect.right = m_restartRect.left + m_buttonSize;
	
	m_gcRect.top = -height / 2.0f + m_buttonSize * 1.5f;
	m_gcRect.bottom = m_gcRect.top - m_buttonSize;
	m_gcRect.left = -width / 2.0f + m_buttonSize / 2.0f;
	m_gcRect.right = m_gcRect.left + m_buttonSize;
	
	m_exitRect.top = m_gcRect.top;
	m_exitRect.bottom = m_gcRect.bottom;
	m_exitRect.right = width / 2.0f - m_buttonSize / 2.0f;
	m_exitRect.left = m_exitRect.right - m_buttonSize;
}

- (bool)TestButton:(Rect)button X:(float)x Y:(float)y
{
	return (button.top > y && button.bottom < y && button.left < x && button.right > x);
}

- (void)TouchPanBegan:(float)x Y:(float)y Fingers:(int)fingers
{

}

- (void)TouchPanChange:(float)x Y:(float)y Fingers:(int)fingers
{

}

- (void)TouchPanEnd:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_stage == PLAYING)
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
	
	if(m_stage == PLAYING)
	{
		if([self TestButton:m_pauseRect X:rx Y:ry])
		{
			m_pauseButton.Width = m_buttonSize * 0.45f;
		}
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
	}
}

- (void)TouchUp:(float)x Y:(float)y Fingers:(int)fingers;
{
	float rx = x - m_renderBox.ScreenWidth / 2;
	float ry = -y + m_renderBox.ScreenHeight / 2;
	
	if(m_stage == PLAYING)
	{
		if([self TestButton:m_pauseRect X:rx Y:ry])
		{
			m_stage = PAUSE;
			Level.Move = false;
			m_pauseButton.Opasity = 0.0;
			m_points.Opasity = 0.0f;
			m_pauseFade.Opasity = 0.9f;
			m_continueButton.Opasity = 1.0f;
			m_restartButton.Opasity = 1.0f;
			m_gcButton.Opasity = 1.0f;
			m_exitButton.Opasity = 1.0f;
			m_changeButton.Opasity = 1.0f;
			m_continueText.Opasity = 1.0f;
			m_changeText.Opasity = 1.0f;
			m_restartText.Opasity = 1.0f;
			m_gcText.Opasity = 1.0f;
			m_exitText.Opasity = 1.0f;
		}
		m_pauseButton.Width = m_buttonSize / 2.0f;
	}
	else if(m_stage == PAUSE)
	{
		if([self TestButton:m_continueRect X:rx Y:ry])
		{
			m_stage = PLAYING;
			Level.Move = true;
			m_pauseButton.Opasity = 1.0;
			m_points.Opasity = 1.0f;
			m_pauseFade.Opasity = 0.0f;
			m_continueButton.Opasity = 0.0f;
			m_restartButton.Opasity = 0.0f;
			m_gcButton.Opasity = 0.0f;
			m_exitButton.Opasity = 0.0f;
			m_changeButton.Opasity = 0.0f;
			m_continueText.Opasity = 0.0f;
			m_changeText.Opasity = 0.0f;
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
			m_pauseFade.Opasity = 0.0f;
			m_continueButton.Opasity = 0.0f;
			m_restartButton.Opasity = 0.0f;
			m_gcButton.Opasity = 0.0f;
			m_exitButton.Opasity = 0.0f;
			m_changeButton.Opasity = 0.0f;
			m_continueText.Opasity = 0.0f;
			m_changeText.Opasity = 0.0f;
			m_restartText.Opasity = 0.0f;
			m_gcText.Opasity = 0.0f;
			m_exitText.Opasity = 0.0f;
		}
		else if([self TestButton:m_gcRect X:rx Y:ry])
		{
			[[GameKitHelper sharedGameKitHelper] presentGameCenter];
		}
		else if([self TestButton:m_exitRect X:rx Y:ry])
		{
			Exit = true;
		}
		m_continueButton.Width = m_buttonSize * 2.0f;
		m_restartButton.Width = m_buttonSize;
		m_gcButton.Width = m_buttonSize;
	}
}

- (void)OutToMainMenu
{
	m_pauseFade.Opasity = 0.0f;
	m_continueButton.Opasity = 0.0f;
	m_restartButton.Opasity = 0.0f;
	m_gcButton.Opasity = 0.0f;
	m_exitButton.Opasity = 0.0f;
	m_changeButton.Opasity = 0.0f;
	m_continueText.Opasity = 0.0f;
	m_changeText.Opasity = 0.0f;
	m_restartText.Opasity = 0.0f;
	m_gcText.Opasity = 0.0f;
	m_exitText.Opasity = 0.0f;
	
	[m_cubeCamera ResetPivot:Level.FocusedCamera.Pivot];
	[m_cubeCamera ResetPosition:[Level.FocusedCamera PositionWOR]];
	[m_cubeCamera ResetViewUp:Level.FocusedCamera.ViewUp];
	[m_cubeCamera ResetPivotRotation:Level.FocusedCamera.PivotRotation];
	[m_cubeCamera Frame:0.0f];
	
	m_cubeView.Camera = m_cubeCamera;
	[Level Restore];
	
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

- (CLLevel*)Level
{
	return Level;
}

@end