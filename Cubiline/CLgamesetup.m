#import "CLgamesetup.h"

@interface CLGameSetpUp()
{
	VERenderBox* m_renderBox;
	VEView* m_cubeView;
	VESprite* m_cubeImage;
	VECamera* m_cubeCamera;
	
	
	VESprite* m_background;
	
	GLKVector3 m_prePosition;
	
	VEText* m_playText;
	VEText* m_speedText;
	VEText* m_sizeText;
	VESprite* m_plusButton;
	VESprite* m_minusButton;
	VESprite* m_playButton;
	VESprite* m_speedButton;
	VESprite* m_sizeButton;
	
	Rect m_plusButtonRect;
	Rect m_minusButtonRect;
	Rect m_playButtonRect;
	Rect m_speedButtonRect;
	Rect m_sizeButtonRect;
	
	bool m_plusButtonEnable;
	bool m_minusButtonEnable;
	bool m_speedButtonEnable;
	bool m_sizeButtonEnable;
	
	float m_buttonSize;
	
	bool m_pressing;
	
	enum CL_SIZE m_size;
	enum CL_SIZE m_speed;
	
	int m_step;
	
	bool m_play;
	
	VEWatch* m_watch;
	
	enum CL_GRAPHICS m_graphics;
}

- (void)ResizeLevel:(enum CL_SIZE)size;
- (void)ChangeSpeed:(enum CL_SIZE)speed;
- (bool)TestButton:(Rect)button X:(float)x Y:(float)y;

- (void)FocusLeaderInCamera;

@end

@implementation CLGameSetpUp

@synthesize Level;
@synthesize Scene;

- (id)initWithRenderBox:(VERenderBox*)renderbox Background:(VESprite *)background Graphics:(enum CL_GRAPHICS)graphics
{
	self = [super init];
	
	if(self)
	{
		m_renderBox = renderbox;
		m_graphics = graphics;
		m_background = background;
		
		// Scene for full screen presentation.
		Scene = [m_renderBox NewSceneWithName:@"SetUpGameScene"];
		
		// Cube view
		m_cubeView = [m_renderBox NewViewAs:VE_VIEW_TYPE_TEXTURE Width:10 Height:10];
		m_cubeView.ClearColor = BackgroundColor;
		m_cubeImage = [m_renderBox NewSpriteFromTexture:m_cubeView.Color];
		m_cubeCamera = [m_renderBox NewCamera:VE_CAMERA_TYPE_PERSPECTIVE];
		m_cubeView.Camera = m_cubeCamera;
		m_cubeView.RenderMode = VE_RENDER_MODE_DIFFUSE;
		
		// Camera SetUp
		m_cubeCamera.PivotTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_cubeCamera.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_cubeCamera.PivotRotationTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_cubeCamera.PivotTransitionTime = 0.4f;
		m_cubeCamera.PositionTransitionTime = 0.4f;
		m_cubeCamera.PivotRotationTransitionTime = 0.2f;
		m_cubeCamera.LockLookAt = true;
		m_cubeCamera.Far = 60.0f;
		m_cubeCamera.Near = 5.0f;
		m_cubeCamera.FocusRange = 15.0f;
		m_cubeCamera.PivotRotation = GLKVector3Make(-30.0f, 30.0f, 0.0f);
		
		// Back
		m_playText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Play"];
		m_speedText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Speed"];
		m_sizeText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Size"];
		
		m_playText.Opasity = 0.0f;
		m_playText.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_playText.OpasityTransitionTime = 0.5f;
		m_playText.Color = GrayColor;
		
		m_speedText.Opasity = 0.0f;
		m_speedText.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_speedText.OpasityTransitionTime = 0.5f;
		m_speedText.Color = GrayColor;
		
		m_sizeText.Opasity = 0.0f;
		m_sizeText.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_sizeText.OpasityTransitionTime = 0.5f;
		m_sizeText.Color = GrayColor;
		
		m_plusButton = [m_renderBox NewSpriteFromFileName:@"game_setup_plus.png"];
		m_minusButton = [m_renderBox NewSpriteFromFileName:@"game_setup_minus.png"];
		m_playButton = [m_renderBox NewSpriteFromFileName:@"game_setup_play.png"];
		m_speedButton = [m_renderBox NewSpriteFromFileName:@"game_setup_speed.png"];
		m_sizeButton = [m_renderBox NewSpriteFromFileName:@"game_setup_size.png"];
		
		m_plusButton.Opasity = 0.0f;
		m_minusButton.Opasity = 0.0f;
		m_playButton.Opasity = 0.0f;
		m_speedButton.Opasity = 0.0f;
		m_sizeButton.Opasity = 0.0f;
		
		m_plusButton.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_plusButton.OpasityTransitionTime = 0.5f;
		m_minusButton.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_minusButton.OpasityTransitionTime = 0.5f;
		m_playButton.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_playButton.OpasityTransitionTime = 0.5f;
		m_speedButton.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_speedButton.OpasityTransitionTime = 0.5f;
		m_sizeButton.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_sizeButton.OpasityTransitionTime = 0.5f;
		
		m_plusButton.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_plusButton.ScaleTransitionTime = 0.1f;
		m_minusButton.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_minusButton.ScaleTransitionTime = 0.1f;
		m_playButton.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_playButton.ScaleTransitionTime = 0.1f;
		m_speedButton.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_speedButton.ScaleTransitionTime = 0.1f;
		m_sizeButton.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_sizeButton.ScaleTransitionTime = 0.1f;
		
		m_plusButton.LockAspect = true;
		m_minusButton.LockAspect = true;
		m_playButton.LockAspect = true;
		m_speedButton.LockAspect = true;
		m_sizeButton.LockAspect = true;
		
		// Scene viewable objects
		[Scene addSprite:background];
		[Scene addSprite:m_cubeImage];
		[Scene addText:m_playText];
		[Scene addText:m_speedText];
		[Scene addText:m_sizeText];
		[Scene addSprite:m_plusButton];
		[Scene addSprite:m_minusButton];
		[Scene addSprite:m_playButton];
		[Scene addSprite:m_speedButton];
		[Scene addSprite:m_sizeButton];
		
		m_watch = [[VEWatch alloc] init];
		m_watch.Style = VE_WATCH_STYLE_LIMITED;
		
		m_size = CL_SIZE_NORMAL;
		m_speed = CL_SIZE_NORMAL;
	}
	
	return self;
}

- (void)Frame:(float)time
{
	[m_watch Frame:time];
	if(m_graphics == CL_GRAPHICS_HIGH)
		[self FocusLeaderInCamera];
}

- (void)FocusLeaderInCamera
{
	float focusDistance = GLKVector3Length(GLKVector3Subtract(Level.Leader.Position, m_cubeCamera.Position));
	m_cubeCamera.FocusDistance = focusDistance;
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
	
	m_plusButton.Height = m_buttonSize;
	m_minusButton.Height = m_buttonSize;
	m_playButton.Height = m_buttonSize;
	m_speedButton.Height = m_buttonSize;
	m_sizeButton.Height = m_buttonSize;
	
	m_plusButton.Position = GLKVector3Make(width / 2 - m_buttonSize / 1.9f, -height / 2.0f + m_buttonSize / 1.9f * 2.0f, 0.0f);
	m_minusButton.Position = GLKVector3Make(-width / 2 + m_buttonSize / 1.9f, -height / 2.0f + m_buttonSize / 1.9f * 2.0f, 0.0f);
	m_playButton.Position = GLKVector3Make(m_buttonSize, -height / 2.0f + m_buttonSize / 1.9f, 0.0f);
	m_speedButton.Position = GLKVector3Make(0.0f, -height / 2.0f + m_buttonSize / 1.9f, 0.0f);
	m_sizeButton.Position = GLKVector3Make(-m_buttonSize, -height / 2.0f + m_buttonSize / 1.9f, 0.0f);
	
	m_plusButtonRect.top = -height / 2.0f + m_buttonSize / 1.9f * 2.0f + m_buttonSize / 2.0f;
	m_plusButtonRect.bottom = m_plusButtonRect.top - m_buttonSize;
	m_plusButtonRect.left = width / 2 - m_buttonSize / 1.9 - m_buttonSize / 2.0f;
	m_plusButtonRect.right = m_plusButtonRect.left + m_buttonSize;
	
	m_minusButtonRect.top = m_plusButtonRect.top;
	m_minusButtonRect.bottom = m_plusButtonRect.bottom;
	m_minusButtonRect.left = -width / 2 + m_buttonSize / 1.9 - m_buttonSize / 2.0f;
	m_minusButtonRect.right = m_minusButtonRect.left + m_buttonSize;
	
	m_playButtonRect.top = -height / 2.0f + m_buttonSize / 1.9f + m_buttonSize / 2.0f;
	m_playButtonRect.bottom = m_playButtonRect.top - m_buttonSize;
	m_playButtonRect.left = m_buttonSize / 2.0f;
	m_playButtonRect.right = m_buttonSize * 1.5f;
	
	m_speedButtonRect.top = -height / 2.0f + m_buttonSize / 1.9f + m_buttonSize / 2.0f;
	m_speedButtonRect.bottom = m_playButtonRect.top - m_buttonSize;
	m_speedButtonRect.left = -m_buttonSize / 2.0f;
	m_speedButtonRect.right = -m_speedButtonRect.left;
	
	m_sizeButtonRect.top = -height / 2.0f + m_buttonSize / 1.9f + m_buttonSize / 2.0f;
	m_sizeButtonRect.bottom = m_playButtonRect.top - m_buttonSize;
	m_sizeButtonRect.left = -m_buttonSize * 1.5f;
	m_sizeButtonRect.right = -m_buttonSize / 2.0f;
	
	m_speedText.Width = m_buttonSize * 0.7f;
	m_speedText.Position = GLKVector3Make(0.0f, m_playButtonRect.top + m_playText.Height * 0.3f, 0.0f);
	
	m_playText.FontSize = m_speedText.FontSize;
	m_playText.Position = GLKVector3Make(m_buttonSize, m_playButtonRect.top + m_playText.Height * 0.3f, 0.0f);

	m_sizeText.FontSize = m_playText.FontSize = m_speedText.FontSize;
	m_sizeText.Position = GLKVector3Make(-m_buttonSize, m_playButtonRect.top + m_playText.Height * 0.3f, 0.0f);
}

- (void)ResizeLevel:(enum CL_SIZE)size
{
	Level.Size = size;
	
	float radious;
	
	if(size == CL_SIZE_SMALL)
	{
		radious = 9.0f * 2.3;
		m_minusButton.Opasity = 0.5f;
		m_minusButtonEnable = false;
		m_plusButton.Opasity = 1.0f;
		m_plusButtonEnable = true;
	}
	else if(size == CL_SIZE_NORMAL)
	{
		radious = 15.0f * 2.3;
		m_minusButton.Opasity = 1.0f;
		m_minusButtonEnable = true;
		m_plusButton.Opasity = 1.0f;
		m_plusButtonEnable = true;
	}
	else if(size == CL_SIZE_BIG)
	{
		radious = 21.0f * 2.3;
		m_minusButton.Opasity = 1.0f;
		m_minusButtonEnable = true;
		m_plusButton.Opasity = 0.5f;
		m_plusButtonEnable = false;
	}
	
	// Re positionate the camera view.
	m_cubeCamera.Position = GLKVector3Make(0.0f, 0.0f, radious);
	m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -radious);
}

- (void)ChangeSpeed:(enum CL_SIZE)speed
{
	Level.Speed = speed;
	
	if(speed == CL_SIZE_SMALL)
	{
		m_minusButton.Opasity = 0.5f;
		m_minusButtonEnable = false;
		m_plusButton.Opasity = 1.0f;
		m_plusButtonEnable = true;
	}
	else if(speed == CL_SIZE_NORMAL)
	{
		m_minusButton.Opasity = 1.0f;
		m_minusButtonEnable = true;
		m_plusButton.Opasity = 1.0f;
		m_plusButtonEnable = true;
	}
	else if(speed == CL_SIZE_BIG)
	{
		m_minusButton.Opasity = 1.0f;
		m_minusButtonEnable = true;
		m_plusButton.Opasity = 0.5f;
		m_plusButtonEnable = false;
	}
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
	
}

- (void)TouchTap:(float)x Y:(float)y Fingers:(int)fingers
{
		
}

- (void)TouchDown:(float)x Y:(float)y Fingers:(int)fingers
{
	float rx = x - m_renderBox.ScreenWidth / 2;
	float ry = -y + m_renderBox.ScreenHeight / 2;
	
	if([self TestButton:m_plusButtonRect X:rx Y:ry] && m_plusButtonEnable)
	{
		m_plusButton.Width = m_buttonSize * 0.7f;
	}
	else if([self TestButton:m_minusButtonRect X:rx Y:ry] && m_minusButtonEnable)
	{
		m_minusButton.Width = m_buttonSize * 0.7f;
	}
	else if([self TestButton:m_speedButtonRect X:rx Y:ry] && m_speedButtonEnable)
	{
		m_speedButton.Width = m_buttonSize * 0.7f;
	}
	else if([self TestButton:m_sizeButtonRect X:rx Y:ry] && m_sizeButtonEnable)
	{
		m_sizeButton.Width = m_buttonSize * 0.7f;
	}
	else if([self TestButton:m_playButtonRect X:rx Y:ry])
	{
		m_playButton.Width = m_buttonSize * 0.7f;
	}
}

- (void)TouchUp:(float)x Y:(float)y Fingers:(int)fingers
{
	float rx = x - m_renderBox.ScreenWidth / 2;
	float ry = -y + m_renderBox.ScreenHeight / 2;
	
	m_pressing = false;
	
	if([self TestButton:m_plusButtonRect X:rx Y:ry] && m_plusButtonEnable)
	{
		if(m_step == 0)
		{
			if(m_size == CL_SIZE_SMALL)
			{
				m_size = CL_SIZE_NORMAL;
			}
			else if(m_size == CL_SIZE_NORMAL)
			{
				m_size = CL_SIZE_BIG;
				m_plusButtonEnable = false;
				m_plusButton.Opasity = 0.5f;
			}
			[self ResizeLevel:m_size];
		}
		else if(m_step == 1)
		{
			if(m_speed == CL_SIZE_SMALL)
			{
				m_speed = CL_SIZE_NORMAL;
			}
			else if(m_speed == CL_SIZE_NORMAL)
			{
				m_speed = CL_SIZE_BIG;
				m_plusButtonEnable = false;
				m_plusButton.Opasity = 0.5f;
			}
			[self ChangeSpeed:m_speed];
		}
		m_minusButtonEnable = true;
		m_minusButton.Opasity = 1.0f;
	}
	else if([self TestButton:m_minusButtonRect X:rx Y:ry] && m_minusButtonEnable)
	{
		if(m_step == 0)
		{
			if(m_size == CL_SIZE_BIG)
			{
				m_size = CL_SIZE_NORMAL;
			}
			else if(m_size == CL_SIZE_NORMAL)
			{
				m_size = CL_SIZE_SMALL;
				m_minusButtonEnable = false;
				m_minusButton.Opasity = 0.5f;
			}
			[self ResizeLevel:m_size];
		}
		else if(m_step == 1)
		{
			if(m_speed == CL_SIZE_BIG)
			{
				m_speed = CL_SIZE_NORMAL;
			}
			else if(m_speed == CL_SIZE_NORMAL)
			{
				m_speed = CL_SIZE_SMALL;
				m_minusButtonEnable = false;
				m_minusButton.Opasity = 0.5f;
			}
			[self ChangeSpeed:m_speed];
		}
		m_plusButtonEnable = true;
		m_plusButton.Opasity = 1.0f;
	}
	else if([self TestButton:m_speedButtonRect X:rx Y:ry] && m_speedButtonEnable)
	{
		m_step = 1;
		m_speedButtonEnable = false;
		m_speedButton.Opasity = 0.5f;
		m_sizeButtonEnable = true;
		m_sizeButton.Opasity = 1.0f;
		
		if(m_speed == CL_SIZE_SMALL)
		{
			m_minusButtonEnable = false;
			m_minusButton.Opasity = 0.5f;
			m_plusButtonEnable = true;
			m_plusButton.Opasity = 1.0f;
		}
		else if(m_speed == CL_SIZE_NORMAL)
		{
			m_minusButtonEnable = true;
			m_minusButton.Opasity = 1.0f;
			m_plusButtonEnable = true;
			m_plusButton.Opasity = 1.0f;
		}
		if(m_speed == CL_SIZE_BIG)
		{
			m_minusButtonEnable = true;
			m_minusButton.Opasity = 1.0f;
			m_plusButtonEnable = false;
			m_plusButton.Opasity = 0.5f;
		}
	}
	else if([self TestButton:m_sizeButtonRect X:rx Y:ry] && m_sizeButtonEnable)
	{
		m_step = 0;
		m_speedButtonEnable = true;
		m_speedButton.Opasity = 1.0f;
		m_sizeButtonEnable = false;
		m_sizeButton.Opasity = 0.5f;
		
		if(m_size == CL_SIZE_SMALL)
		{
			m_minusButtonEnable = false;
			m_minusButton.Opasity = 0.5f;
			m_plusButtonEnable = true;
			m_plusButton.Opasity = 1.0f;
		}
		else if(m_size == CL_SIZE_NORMAL)
		{
			m_minusButtonEnable = true;
			m_minusButton.Opasity = 1.0f;
			m_plusButtonEnable = true;
			m_plusButton.Opasity = 1.0f;
		}
		if(m_size == CL_SIZE_BIG)
		{
			m_minusButtonEnable = true;
			m_minusButton.Opasity = 1.0f;
			m_plusButtonEnable = false;
			m_plusButton.Opasity = 0.5f;
		}
	}
	else if([self TestButton:m_playButtonRect X:rx Y:ry])
	{
		m_play = true;
	}
	
	m_plusButton.Width = m_buttonSize;
	m_minusButton.Width = m_buttonSize;
	m_playButton.Width = m_buttonSize;
	m_speedButton.Width = m_buttonSize;
	m_sizeButton.Width = m_buttonSize;
}

- (void)InToSetUp
{
	m_cubeView.Camera = m_cubeCamera;
	[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, 7.3f)];
	[m_cubeCamera ResetPivot:GLKVector3Make(0.0f, 0.0f, -7.3f)];
	[m_cubeCamera ResetPivotRotation:GLKVector3Make(26.5650501, 0.0f, 0.0f)];
}
- (void)Begin
{
	[Level Reset];
	[self ChangeSpeed:m_speed];
	[self ResizeLevel:m_size];
	Level.Dance = true;
	m_playText.Opasity = 1.0f;
	m_speedText.Opasity = 1.0f;
	m_sizeText.Opasity = 1.0f;
	m_playButton.Opasity = 1.0f;
	m_speedButton.Opasity = 1.0f;
	m_sizeButton.Opasity = 0.5f;
	m_sizeButtonEnable = false;
	m_speedButtonEnable = true;
	m_step = 0;
	m_play = false;
}

- (void)OutToPlay
{
	m_playButton.OpasityTransitionTime = 0.1f;
	m_sizeButton.OpasityTransitionTime = 0.1f;
	m_speedButton.OpasityTransitionTime = 0.1f;
	m_plusButton.OpasityTransitionTime = 0.1f;
	m_minusButton.OpasityTransitionTime = 0.1f;
	m_playText.OpasityTransitionTime = 0.1f;
	m_sizeText.OpasityTransitionTime = 0.1f;
	m_speedText.OpasityTransitionTime = 0.1f;
	
	m_playButton.Opasity = 0.0f;
	m_sizeButton.Opasity = 0.0f;
	m_speedButton.Opasity = 0.0f;
	m_plusButton.Opasity = 0.0f;
	m_minusButton.Opasity = 0.0f;
	m_playText.Opasity = 0.0f;
	m_sizeText.Opasity = 0.0f;
	m_speedText.Opasity = 0.0f;
	
	m_cubeView.Camera = Level.FocusedCamera;
	
	m_background.Color = SecundaryColor;
	
	[m_renderBox Frame:0.0f];
	
	[m_watch Reset];
	[m_watch SetLimitInSeconds:1.0f];
}

- (bool)OutReady
{
	return !m_watch.Active;
}

- (void)setLevel:(CLLevel *)level
{
	Level = level;
	m_cubeView.Scene = Level.Scene;
}

- (CLLevel*)Level
{
	return Level;
}

- (bool)Ready
{
	return m_play;
}

@end