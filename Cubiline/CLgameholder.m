#import "CLgameholder.h"

@interface CLGameHolder()
{
	VERenderBox* m_renderBox;
	VEView* m_cubeView;
	VESprite* m_cubeImage;
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
		
		// Scene viewable objects
		[Scene addSprite:m_cubeImage];
	}
	
	return self;
}

- (void)Frame:(float)time
{
	
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
	}
	else
	{
		spriteSize = width;
	}
	
	// Resize elements.
	[m_cubeView ResizeWithWidth:spriteSize Height:spriteSize];
	m_cubeImage.Scale = GLKVector3Make(spriteSize, -spriteSize, 0.0f);
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