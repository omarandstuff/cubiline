#import "CLgameholder.h"

@interface CLGameHolder()
{
	VERenderBox* m_renderBox;
	VEView* m_cubeView;
	VESprite* m_cubeImage;
	VEText* m_points;
	VEEffect1* m_pointsEffect;
}

@end

@implementation CLGameHolder

@synthesize Level;
@synthesize Scene;

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
		m_cubeView.EnableLight = true;
		
		
		// Points text
		m_points = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"0"];
		m_points.Color = GrayColor;
		m_points.Opasity = 0.0f;
		m_points.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_points.OpasityTransitionTime = 0.3f;
		m_points.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_points.PositionTransitionTime = 0.7f;
		
		m_pointsEffect = [[VEEffect1 alloc] init];
		m_pointsEffect.TransitionEffect = VE_TRANSITION_EFFECT_HARD;
		m_pointsEffect.TransitionTime = 0.5f;
		
		// Scene viewable objects
		[Scene addSprite:m_cubeImage];
		[Scene addText:m_points];
	}
	
	return self;
}

- (void)Frame:(float)time
{
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
	}
	else
	{
		spriteSize = width;
	}
	
	// Resize elements.
	[m_cubeView ResizeWithWidth:spriteSize Height:spriteSize];
	m_cubeImage.Scale = GLKVector3Make(spriteSize, -spriteSize, 0.0f);
	
	m_points.FontSize = width > height ? height / 10 : width / 10;
	m_points.Position = GLKVector3Make(m_renderBox.ScreenWidth / 2 - m_points.Width, m_renderBox.ScreenHeight / 2 - m_points.Height, 0.0f);
}

- (void)TouchPanBegan:(float)x Y:(float)y Fingers:(int)fingers
{

}

- (void)TouchPanChange:(float)x Y:(float)y Fingers:(int)fingers
{

}

- (void)TouchPanEnd:(float)x Y:(float)y Fingers:(int)fingers
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

- (void)TouchTap:(float)x Y:(float)y Fingers:(int)fingers
{

}

- (void)TouchDown:(float)x Y:(float)y Fingers:(int)fingers
{

}

- (void)TouchUp:(float)x Y:(float)y Fingers:(int)fingers;
{

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