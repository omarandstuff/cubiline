#import "CLgamesetup.h"

@interface CLGameSetpUp()
{
	VERenderBox* m_renderBox;
	VEView* m_cubeView;
	VESprite* m_cubeImage;
	VECamera* m_cubeCamera;
	
	GLKVector3 m_prePosition;
	
	VESprite* m_back;
	VESprite* m_back2;
	VEText* m_speedText;
	VEText* m_sizeText;
	VESprite* m_plusSpeedButton;
	VESprite* m_minusSpeedButton;
	VESprite* m_plusSizeButton;
	VESprite* m_minusSizeButton;
	VESprite* m_playButton;
	
	VEText* m_playText;
	
	VEText* m_speedNumber;
	VEText* m_sizeNumber;

	Rect m_plusSpeedButtonRect;
	Rect m_minusSpeedButtonRect;
	Rect m_plusSizeButtonRect;
	Rect m_minusSizeButtonRect;
	Rect m_playButtonRect;
	
	bool m_plusSpeedButtonEnable;
	bool m_minusSpeedButtonEnable;
	bool m_plusSizeButtonEnable;
	bool m_minusSizeButtonEnable;
	
	float m_buttonSize;
	
	bool m_pressing;
	
	enum CL_SIZE m_size;
	enum CL_SIZE m_speed;

	bool m_play;
	
	VEWatch* m_watch;
	
	enum CL_GRAPHICS m_graphics;
	
	float spriteSize;
	float m_buttonAudioSize;
	
	
	/// Sound
	VEAudioBox* m_audioBox;
	VESound* m_sizeSound;
	VESound* m_speedSound;
	VESound* m_playSound;
	
	VESprite* m_audioSetUpOn;
	VESprite* m_audioSetUpOff;
	Rect m_audioSetUpRect;
	

	VEText* m_gameModeText;
	
	
	CLLAnguage* m_language;
	
}

- (void)ResizeLevel:(enum CL_SIZE)size;
- (void)ChangeSpeed:(enum CL_SIZE)speed;
- (bool)TestButton:(Rect)button X:(float)x Y:(float)y;

- (void)PresentShit;

@end

@implementation CLGameSetpUp

@synthesize Level;
@synthesize Scene;
@synthesize GameData;

- (id)initWithRenderBox:(VERenderBox*)renderbox Graphics:(enum CL_GRAPHICS)graphics
{
	self = [super init];
	
	if(self)
	{
		m_renderBox = renderbox;
		m_graphics = graphics;
		m_audioBox = [VEAudioBox sharedVEAudioBox];
		m_language = [CLLAnguage sharedCLLanguage];
		
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
		m_cubeCamera.Far = 200.0f;
		m_cubeCamera.Near = 5.0f;
		m_cubeCamera.FocusRange = 15.0f;
		m_cubeCamera.PivotRotation = GLKVector3Make(-30.0f, 30.0f, 0.0f);
		
		// Back
		m_back = [m_renderBox NewSolidSpriteWithColor:ColorWhite];
		CommonButtonStyle(m_back);
		m_back.LockAspect = false;
		
		m_back2 = [m_renderBox NewSolidSpriteWithColor:PrimaryColor];
		CommonButtonStyle(m_back2);
		m_back2.LockAspect = false;
		
		m_speedText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:[m_language stringForKey:@"setup_speed"]];
		CommonTextStyle(m_speedText);
		m_sizeText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:[m_language stringForKey:@"setup_size"]];
		CommonTextStyle(m_sizeText);
		
		m_speedNumber = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"1"];
		CommonTextStyle(m_speedNumber);
		m_sizeNumber = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"1"];
		CommonTextStyle(m_sizeNumber);
		
		
		m_plusSpeedButton = [m_renderBox NewSpriteFromFileName:@"game_setup_plus.png"];
		CommonButtonStyle(m_plusSpeedButton);
		m_minusSpeedButton = [m_renderBox NewSpriteFromFileName:@"game_setup_minus.png"];
		CommonButtonStyle(m_minusSpeedButton);
		m_plusSizeButton = [m_renderBox NewSpriteFromFileName:@"game_setup_plus.png"];
		CommonButtonStyle(m_plusSizeButton);
		m_minusSizeButton = [m_renderBox NewSpriteFromFileName:@"game_setup_minus.png"];
		CommonButtonStyle(m_minusSizeButton);
		m_playButton = [m_renderBox NewSpriteFromFileName:@"game_setup_play.png"];
		CommonButtonStyle(m_playButton);

		
		//// Audio SetUp
		m_audioSetUpOn = [m_renderBox NewSpriteFromFileName:@"sound_button_on.png"];
		m_audioSetUpOff = [m_renderBox NewSpriteFromFileName:@"sound_button_off.png"];
		CommonButtonStyle(m_audioSetUpOn);
		CommonButtonStyle(m_audioSetUpOff);
		
		
		/// text game mode
		m_gameModeText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:[m_language stringForKey:@"setup_level"]];
		CommonTextStyle(m_gameModeText);
		
		m_playText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:[m_language stringForKey:@"main_menu_play"]];
		CommonTextStyle(m_playText);
		
		
		// Scene viewable objects
		[Scene addSprite:m_cubeImage];
		[Scene addSprite:m_back];
		[Scene addSprite:m_back2];
		[Scene addText:m_speedText];
		[Scene addText:m_sizeText];
		[Scene addSprite:m_plusSpeedButton];
		[Scene addSprite:m_minusSpeedButton];
		[Scene addSprite:m_plusSizeButton];
		[Scene addSprite:m_minusSizeButton];
		[Scene addSprite:m_playButton];
		[Scene addSprite:m_audioSetUpOn];
		[Scene addSprite:m_audioSetUpOff];
		[Scene addText:m_gameModeText];
		[Scene addText:m_speedNumber];
		[Scene addText:m_sizeNumber];
		[Scene addText:m_playText];
		
		m_watch = [[VEWatch alloc] init];
		m_watch.Style = VE_WATCH_STYLE_LIMITED;
		
		m_size = CL_SIZE_NORMAL;
		m_speed = CL_SIZE_NORMAL;
		
		// Sound
		m_sizeSound = [m_audioBox NewSoundWithFileName:@"size.wav"];
		m_speedSound = [m_audioBox NewSoundWithFileName:@"speed.wav"];
		m_playSound = [m_audioBox NewSoundWithFileName:@"play.wav"];
	}
	
	return self;
}

- (void)Frame:(float)time
{
	[m_watch Frame:time];
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
	float buttonspace;
	
	// Best size from the screen.
	if(width > height)
		spriteSize = height;
	else
		spriteSize = width;
	
	m_buttonAudioSize = spriteSize / 5.0f;
	
	buttonspace = spriteSize / 100.0f;
	m_buttonSize = (spriteSize - buttonspace * 6.0f) / 6.0f;
	
	// Resize elements.
	[m_cubeView ResizeWithWidth:spriteSize Height:spriteSize];
	m_cubeImage.Scale = GLKVector3Make(spriteSize, -spriteSize, 0.0f);
	
	GLKVector3 position = GLKVector3Make(-spriteSize / 2.0f + buttonspace + m_buttonSize / 2.0f, -height / 2.0f + buttonspace + m_buttonSize / 2.0f, 0.0f);
	m_minusSizeButton.Position = position;
	
	m_minusSizeButtonRect.top = position.y + m_buttonSize / 2.0f;
	m_minusSizeButtonRect.bottom = m_minusSizeButtonRect.top - m_buttonSize;
	m_minusSizeButtonRect.left = position.x - m_buttonSize / 2.0f;
	m_minusSizeButtonRect.right = m_minusSizeButtonRect.left + m_buttonSize;
	
	position.x += m_buttonSize * 0.5f + buttonspace * 0.5f;
	m_sizeNumber.Position = position;
	
	position.x += m_buttonSize * 0.5f + buttonspace * 0.5f;
	m_plusSizeButton.Position = position;
	
	m_plusSizeButtonRect.top = position.y + m_buttonSize / 2.0f;
	m_plusSizeButtonRect.bottom = m_plusSizeButtonRect.top - m_buttonSize;
	m_plusSizeButtonRect.left = position.x - m_buttonSize / 2.0f;
	m_plusSizeButtonRect.right = m_plusSizeButtonRect.left + m_buttonSize;
	
	position.x += m_buttonSize + buttonspace;
	m_minusSpeedButton.Position = position;
	
	m_minusSpeedButtonRect.top = position.y + m_buttonSize / 2.0f;
	m_minusSpeedButtonRect.bottom = m_minusSpeedButtonRect.top - m_buttonSize;
	m_minusSpeedButtonRect.left = position.x - m_buttonSize / 2.0f;
	m_minusSpeedButtonRect.right = m_minusSpeedButtonRect.left + m_buttonSize;
	
	position.x += m_buttonSize * 0.5f + buttonspace * 0.5f;
	m_speedNumber.Position = position;
	
	position.x += m_buttonSize * 0.5f + buttonspace * 0.5f;
	m_plusSpeedButton.Position = position;
	
	m_plusSpeedButtonRect.top = position.y + m_buttonSize / 2.0f;
	m_plusSpeedButtonRect.bottom = m_plusSpeedButtonRect.top - m_buttonSize;
	m_plusSpeedButtonRect.left = position.x - m_buttonSize / 2.0f;
	m_plusSpeedButtonRect.right = m_plusSpeedButtonRect.left + m_buttonSize;
	
	position.x = spriteSize / 2.0f - m_buttonSize - buttonspace;
	position.y = -height / 2.0f + buttonspace * 1.5f + m_buttonSize * 1.2f;
	m_playButton.Position = position;
	
	m_playButtonRect.top = position.y + m_buttonSize;
	m_playButtonRect.bottom = m_playButtonRect.top - m_buttonSize * 2.0f;
	m_playButtonRect.left = position.x - m_buttonSize;
	m_playButtonRect.right = m_playButtonRect.left + m_buttonSize *2.0f;
	
	position.y -= m_buttonSize * 0.8f;
	m_playText.Position = position;
	
	position.x = -spriteSize / 2.0f + buttonspace * 1.5f + m_buttonSize;
	position.y = -height / 2.0f + m_buttonSize;
	m_sizeText.Position = position;
	
	position.x += buttonspace * 1.5f + m_buttonSize * 2.0f;
	m_speedText.Position = position;
	
	position.y += m_buttonSize * 0.5f;
	position.x = m_plusSizeButtonRect.right + buttonspace / 2.0f;
	m_gameModeText.Position = position;
	
	m_back.Position = GLKVector3Make(0.0f, -height * 0.5f + m_buttonSize, 0.0f);
	m_back.Width = width;
	m_back.Height = m_buttonSize * 2.0f;
	
	m_back2.Position = GLKVector3Make(0.0f, -height * 0.5f + m_buttonSize * 2.0f, 0.0f);
	m_back2.Width = width;
	m_back2.Height = m_buttonSize * 0.02f;
	
	/// Audio
	
	m_audioSetUpOn.Position = GLKVector3Make(width / 2.0f - m_buttonAudioSize / 3.0f, height / 2.0f - m_buttonAudioSize / 3.0f, 0.0f);
	m_audioSetUpOff.Position = GLKVector3Make(width / 2.0f - m_buttonAudioSize / 3.0f, height / 2.0f - m_buttonAudioSize / 3.0f, 0.0f);
	
	m_audioSetUpRect.bottom = height / 2.0f - (m_buttonAudioSize / 3.0f) * 1.8f;
	m_audioSetUpRect.top = height / 2.0f;
	m_audioSetUpRect.left = width / 2.0f - (m_buttonAudioSize / 3.0f) * 1.8f;
	m_audioSetUpRect.right = width / 2.0f;
	
}

- (void)PresentShit
{
	[m_plusSizeButton ResetScale:GLKVector3Make(m_buttonSize * 2.0f, m_buttonSize * 2.0f, 0.0f)];
	[m_plusSizeButton ResetOpasity];
	m_plusSizeButton.Width = m_buttonSize;
	if(m_size == CL_SIZE_EXTRA)
		m_plusSizeButton.Opasity = 0.5f;
	else
		m_plusSizeButton.Opasity = 1.0f;
		
	[m_minusSizeButton ResetScale:GLKVector3Make(m_buttonSize * 2.0f, m_buttonSize * 2.0f, 0.0f)];
	[m_minusSizeButton ResetOpasity];
	m_minusSizeButton.Width = m_buttonSize;
	if(m_size == CL_SIZE_SMALL)
		m_minusSizeButton.Opasity = 0.5f;
	else
		m_minusSizeButton.Opasity = 1.0f;
	
	[m_plusSpeedButton ResetScale:GLKVector3Make(m_buttonSize * 2.0f, m_buttonSize * 2.0f, 0.0f)];
	[m_plusSpeedButton ResetOpasity];
	m_plusSpeedButton.Width = m_buttonSize;
	if(m_speed == CL_SIZE_EXTRA)
		m_plusSpeedButton.Opasity = 0.5f;
	else
		m_plusSpeedButton.Opasity = 1.0f;
	
	[m_minusSpeedButton ResetScale:GLKVector3Make(m_buttonSize * 2.0f, m_buttonSize * 2.0f, 0.0f)];
	[m_minusSpeedButton ResetOpasity];
	m_minusSpeedButton.Width = m_buttonSize;
	if(m_speed == CL_SIZE_SMALL)
		m_minusSpeedButton.Opasity = 0.5f;
	else
		m_minusSpeedButton.Opasity = 1.0f;
	
	[m_playButton ResetScale:GLKVector3Make(m_buttonSize * 3.0f, m_buttonSize * 3.0f, 0.0f)];
	[m_playButton ResetOpasity];
	m_playButton.Width = m_buttonSize * 2.0f;
	m_playButton.Opasity = 1.0f;
	
	[m_sizeText ResetFontSize:m_buttonSize * 0.8f];
	[m_sizeText ResetOpasity];
	m_sizeText.FontSize = m_buttonSize * 0.28f;
	m_sizeText.Opasity = 1.0f;
	
	[m_speedText ResetFontSize:m_buttonSize * 0.8f];
	[m_speedText ResetOpasity];
	m_speedText.FontSize = m_buttonSize * 0.28f;
	m_speedText.Opasity = 1.0f;
	
	[m_sizeNumber ResetFontSize:m_buttonSize * 0.8f];
	[m_sizeNumber ResetOpasity];
	m_sizeNumber.FontSize = m_buttonSize * 0.28f;
	m_sizeNumber.Opasity = 1.0f;
	
	[m_speedNumber ResetFontSize:m_buttonSize * 0.8f];
	[m_speedNumber ResetOpasity];
	m_speedNumber.FontSize = m_buttonSize * 0.28f;
	m_speedNumber.Opasity = 1.0f;
	
	[m_gameModeText ResetFontSize:m_buttonSize * 0.8f];
	[m_gameModeText ResetOpasity];
	m_gameModeText.FontSize = m_buttonSize * 0.4f;
	m_gameModeText.Opasity = 1.0f;
	
	[m_playText ResetFontSize:m_buttonSize * 0.8f];
	[m_playText ResetOpasity];
	m_playText.FontSize = m_buttonSize * 0.4f;
	m_playText.Opasity = 1.0f;
	
	m_back.Opasity = 1.0f;
	m_back2.Opasity = 1.0f;
	
	if(m_audioBox.Mute)
	{
		[m_audioSetUpOff ResetScale:GLKVector3Make(m_buttonAudioSize, m_buttonAudioSize, 0.0f)];
		[m_audioSetUpOff ResetOpasity];
		m_audioSetUpOff.Width = m_buttonAudioSize / 3.0f;
		m_audioSetUpOff.Opasity = 1.0f;
	}
	else
	{
		[m_audioSetUpOn ResetScale:GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f)];
		[m_audioSetUpOn ResetOpasity];
		m_audioSetUpOn.Width = m_buttonAudioSize / 3.0f;
		m_audioSetUpOn.Opasity = 1.0f;
	}
}

- (void)ResizeLevel:(enum CL_SIZE)size
{
	Level.Size = size;
	
	float radious;
	
	if(size == CL_SIZE_SMALL)
	{
		radious = 9.0f * 2.3;
		m_sizeNumber.Text = @"1";
	}
	else if(size == CL_SIZE_NORMAL)
	{
		radious = 15.0f * 2.3;
		m_sizeNumber.Text = @"2";
	}
	else if(size == CL_SIZE_BIG)
	{
		radious = 21.0f * 2.3;
		m_sizeNumber.Text = @"3";
	}
	else if(size == CL_SIZE_EXTRA)
	{
		radious = 27.0f * 2.3;
		m_sizeNumber.Text = @"4";
	}
	
	GameData.Size = m_size;
	
	// Re positionate the camera view.
	m_cubeCamera.Position = GLKVector3Make(0.0f, 0.0f, radious);
	m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -radious);
}

- (void)ChangeSpeed:(enum CL_SIZE)speed
{
	Level.Speed = speed;
	
	if(speed == CL_SIZE_SMALL)
	{
		m_speedNumber.Text = @"1";
	}
	else if(speed == CL_SIZE_NORMAL)
	{
		m_speedNumber.Text = @"2";
	}
	else if(speed == CL_SIZE_BIG)
	{
		m_speedNumber.Text = @"3";
	}
	else if(speed == CL_SIZE_EXTRA)
	{
		m_speedNumber.Text = @"4";
	}
	
	GameData.Speed = m_speed;
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

- (void)TouchTap:(float)x Y:(float)y Fingers:(int)fingers Taps:(int)taps
{
		
}

- (void)TouchDown:(float)x Y:(float)y Fingers:(int)fingers
{
	float rx = x - m_renderBox.ScreenWidth / 2;
	float ry = -y + m_renderBox.ScreenHeight / 2;
	
	m_pressing = true;
	
	if([self TestButton:m_playButtonRect X:rx Y:ry])
		m_playButton.Width = m_buttonSize * 1.5f;
	else if([self TestButton:m_plusSizeButtonRect X:rx Y:ry])
		m_plusSizeButton.Width = m_buttonSize * 0.5f;
	else if([self TestButton:m_minusSizeButtonRect X:rx Y:ry])
		m_minusSizeButton.Width = m_buttonSize * 0.5f;
	else if([self TestButton:m_plusSpeedButtonRect X:rx Y:ry])
		m_plusSpeedButton.Width = m_buttonSize * 0.5f;
	else if([self TestButton:m_minusSpeedButtonRect X:rx Y:ry])
		m_minusSpeedButton.Width = m_buttonSize * 0.5f;
	else if([self TestButton:m_audioSetUpRect X:rx Y:ry])
	{
		m_audioSetUpOn.Width = m_buttonSize * 0.2f;
		m_audioSetUpOff.Height = m_buttonSize * 0.2f;
	}
}

- (void)TouchUp:(float)x Y:(float)y Fingers:(int)fingers
{
	float rx = x - m_renderBox.ScreenWidth / 2;
	float ry = -y + m_renderBox.ScreenHeight / 2;
	
	if(!m_pressing)return;
	m_pressing = false;
	
	if([self TestButton:m_playButtonRect X:rx Y:ry])
	{
		m_play = true;
		[m_playSound Play];
	}
	else if([self TestButton:m_plusSizeButtonRect X:rx Y:ry] && m_plusSizeButtonEnable)
	{
		if(m_size == CL_SIZE_SMALL)
		{
			m_size = CL_SIZE_NORMAL;
		}
		else if(m_size == CL_SIZE_NORMAL)
		{
			m_size = CL_SIZE_BIG;
		}
		else if(m_size == CL_SIZE_BIG)
		{
			m_size = CL_SIZE_EXTRA;
			m_plusSizeButtonEnable = false;
			m_plusSizeButton.Opasity = 0.5f;
		}
		[self ResizeLevel:m_size];
		m_minusSizeButtonEnable = true;
		m_minusSizeButton.Opasity = 1.0f;
		[m_sizeSound Stop];
		[m_sizeSound Play];
	}
	else if([self TestButton:m_minusSizeButtonRect X:rx Y:ry] && m_minusSizeButtonEnable)
	{
		if(m_size == CL_SIZE_EXTRA)
		{
			m_size = CL_SIZE_BIG;
		}
		else if(m_size == CL_SIZE_BIG)
		{
			m_size = CL_SIZE_NORMAL;
		}
		else if(m_size == CL_SIZE_NORMAL)
		{
			m_size = CL_SIZE_SMALL;
			m_minusSizeButtonEnable = false;
			m_minusSizeButton.Opasity = 0.5f;
		}
		[self ResizeLevel:m_size];
		m_plusSizeButtonEnable = true;
		m_plusSizeButton.Opasity = 1.0f;
		[m_sizeSound Stop];
		[m_sizeSound Play];
	}
	else if([self TestButton:m_plusSpeedButtonRect X:rx Y:ry] && m_plusSpeedButtonEnable)
	{
		if(m_speed == CL_SIZE_SMALL)
		{
			m_speed = CL_SIZE_NORMAL;
		}
		else if(m_speed == CL_SIZE_NORMAL)
		{
			m_speed = CL_SIZE_BIG;
		}
		else if(m_speed == CL_SIZE_BIG)
		{
			m_speed = CL_SIZE_EXTRA;
			m_plusSpeedButtonEnable = false;
			m_plusSpeedButton.Opasity = 0.5f;
		}
		[self ChangeSpeed:m_speed];
		m_minusSpeedButtonEnable = true;
		m_minusSpeedButton.Opasity = 1.0f;
		[m_speedSound Stop];
		[m_speedSound Play];
	}
	else if([self TestButton:m_minusSpeedButtonRect X:rx Y:ry] && m_minusSpeedButtonEnable)
	{
		if(m_speed == CL_SIZE_EXTRA)
		{
			m_speed = CL_SIZE_BIG;
		}
		else if(m_speed == CL_SIZE_BIG)
		{
			m_speed = CL_SIZE_NORMAL;
		}
		else if(m_speed == CL_SIZE_NORMAL)
		{
			m_speed = CL_SIZE_SMALL;
			m_minusSpeedButtonEnable = false;
			m_minusSpeedButton.Opasity = 0.5f;
		}
		[self ChangeSpeed:m_speed];
		m_plusSpeedButtonEnable = true;
		m_plusSpeedButton.Opasity = 1.0f;
		[m_speedSound Stop];
		[m_speedSound Play];
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
	
	m_playButton.Width = m_buttonSize * 2.0f;
	m_plusSizeButton.Width = m_buttonSize;
	m_minusSizeButton.Width = m_buttonSize;
	m_plusSpeedButton.Width = m_buttonSize;
	m_minusSpeedButton.Width = m_buttonSize;
	m_audioSetUpOn.Width = m_buttonSize / 3.0f;
	m_audioSetUpOff.Height = m_buttonSize / 3.0f;
}

- (void)InToSetUp
{
	m_cubeView.Camera = m_cubeCamera;
	[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, 7.3f)];
	[m_cubeCamera ResetPivot:GLKVector3Make(0.0f, 0.0f, -7.3f)];
	[m_cubeCamera ResetPivotRotation:GLKVector3Make(26.5650501, 0.0f, 0.0f)];
}
- (void)Begin:(bool)forced
{
	[Level Reset];
	[self ChangeSpeed:m_speed];
	[self ResizeLevel:m_size];
	Level.Dance = true;
	m_play = false;
	
	
	if(m_size == CL_SIZE_SMALL)
	{
		m_minusSizeButtonEnable = false;
		m_plusSizeButtonEnable = true;
	}
	else if(m_size == CL_SIZE_NORMAL)
	{
		m_minusSizeButtonEnable = true;
		m_plusSizeButtonEnable = true;
	}
	else if(m_size == CL_SIZE_BIG)
	{
		m_minusSizeButtonEnable = true;
		m_plusSizeButtonEnable = true;
	}
	else
	{
		m_minusSizeButtonEnable = true;
		m_plusSizeButtonEnable = false;
	}
	
	if(m_speed == CL_SIZE_SMALL)
	{
		m_minusSpeedButtonEnable = false;
		m_plusSpeedButtonEnable = true;
	}
	else if(m_speed == CL_SIZE_NORMAL)
	{
		m_minusSpeedButtonEnable = true;
		m_plusSpeedButtonEnable = true;
	}
	else if(m_speed == CL_SIZE_BIG)
	{
		m_minusSpeedButtonEnable = true;
		m_plusSpeedButtonEnable = true;
	}
	else
	{
		m_minusSpeedButtonEnable = true;
		m_plusSpeedButtonEnable = false;
	}
	
	if(forced)
	{
		m_play = true;
		[m_playSound Play];
	}
	else
		[self PresentShit];
}

- (void)OutToPlay
{
	m_playButton.OpasityTransitionTime = 0.1f;
	m_sizeText.OpasityTransitionTime = 0.1f;
	m_speedText.OpasityTransitionTime = 0.1f;
	m_speedNumber.OpasityTransitionTime = 0.1f;
	m_sizeNumber.OpasityTransitionTime = 0.1f;
	m_back.OpasityTransitionTime = 0.1f;
	m_back2.OpasityTransitionTime = 0.1f;
	m_playText.OpasityTransitionTime = 0.1f;
	
	m_playButton.Opasity = 0.0f;
	m_sizeText.Opasity = 0.0f;
	m_speedText.Opasity = 0.0f;
	m_plusSizeButton.Opasity = 0.0f;
	m_minusSizeButton.Opasity = 0.0f;
	m_plusSpeedButton.Opasity = 0.0f;
	m_minusSpeedButton.Opasity = 0.0f;
	
	m_speedNumber.Opasity = 0.0f;
	m_sizeNumber.Opasity = 0.0f;
	
	m_audioSetUpOn.Opasity = 0.0f;
	m_audioSetUpOff.Opasity = 0.0f;
	
	m_back.Opasity = 0.0f;
	m_back2.Opasity = 0.0f;
	
	m_playText.Opasity = 0.0f;
	
	m_gameModeText.Opasity = 0.0f;
	
	m_cubeView.Camera = Level.FocusedCamera;
	
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

- (void)setGameData:(CLData *)gameData
{
	GameData = gameData;
	if(!GameData.New)
	{
		GameData.Size = CL_SIZE_NORMAL;
		GameData.Speed = CL_SIZE_NORMAL;
	}
	
	m_size = GameData.Size;
	m_speed = GameData.Speed;
}

- (CLData*)GameData
{
	return GameData;
}

@end