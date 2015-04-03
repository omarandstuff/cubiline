#import "CLmainmenu.h"

@interface CLMainMenu()
{
	VERenderBox* m_renderBox;
	
	VELight* m_light;
	
	VEModel* m_cube;
	
	VEModel* m_playIcon;
	VEModel* m_gameCenterIcon;
	VEModel* m_howToIcon;
	VEModel* m_aboutIcon;
	
	VESprite* m_title;
	
	VESprite* m_right;
	Rect m_rightRect;
	VESprite* m_left;
	Rect m_leftRect;
	
	GLKVector3 m_preRotation;
	
	bool m_toProceed;
	
	float m_realRotation;
	float m_properRotation;
	float m_preProperRotation;
	
	VEText* m_text;
	
	VEScene* m_cubeScene;
	VEView* m_cubeView;
	VESprite* m_cubeImage;
	VECamera* m_cubeCamera;
	
	bool m_inCube;
	float m_cubeLimit;
	
	bool m_selected;
	
	VEWatch* m_watch;
	VERandom* m_random;
	
	enum CL_GRAPHICS m_graphics;
	
	float spriteSize;
	
	bool m_inButton;
	
	bool m_start;
	VEWatch* m_startWatch;
	
	
	/// About
	bool m_viewing;
	VESprite* m_background;
	VESprite* m_logo;
	VEText* m_version;
	VEText* m_developed;
	VEText* m_byOmarDeAnda;
}

- (void)PressCube;
- (void)ReleaseCube;
- (void)ProperCube;
- (void)DoSelect;

- (bool)TestButton:(Rect)button X:(float)x Y:(float)y;
- (void)PresentShit;
- (void)PresentAbout;

@end

@implementation CLMainMenu

@synthesize Scene;
@synthesize Camera;
@synthesize Selection;

@synthesize GameCenter;

- (id)initWithRenderBox:(VERenderBox*)renderbox Graphics:(enum CL_GRAPHICS)graphics
{
	self = [super init];
	
	if(self)
	{
		m_renderBox = renderbox;
		m_graphics = graphics;
		
		Scene = [m_renderBox NewSceneWithName:@"MainMenuScene"];
		
		m_cubeScene = [m_renderBox NewSceneWithName:@"MainMenuCubeScene"];
		
		m_cubeView = [m_renderBox NewViewAs:VE_VIEW_TYPE_TEXTURE Width:(float)m_renderBox.ScreenHeight Height:(float)m_renderBox.ScreenHeight];
		m_cubeView.ClearColor = BackgroundColor;
		m_cubeView.RenderMode = VE_RENDER_MODE_DIFFUSE;
		
		m_cubeView.Scene = m_cubeScene;
		
		m_cubeImage = [m_renderBox NewSpriteFromTexture:m_cubeView.Color];
		
		m_playIcon = [m_renderBox NewModelFromFileName:@"main_menu_play"];
		m_playIcon.Scale = GLKVector3Make(1.1f, 1.1f, 1.1f);
		m_playIcon.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_playIcon.ScaleTransitionTime = 0.15f;
		m_playIcon.RotationTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_playIcon.RotationTransitionTime = 0.1f;
		m_playIcon.OpasityTransitionEffect = VE_TRANSITION_EFFECT_BEGIN_EASE;
		m_playIcon.OpasityTransitionTime = 0.3f;
		m_playIcon.ForcedRenderMode = VE_RENDER_MODE_DIFFUSE;
		
		m_gameCenterIcon = [m_renderBox NewModelFromFileName:@"main_menu_game_center"];
		m_gameCenterIcon.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_gameCenterIcon.ScaleTransitionTime = 0.15f;
		m_gameCenterIcon.RotationTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_gameCenterIcon.RotationTransitionTime = 0.1f;
		m_gameCenterIcon.OpasityTransitionEffect = VE_TRANSITION_EFFECT_BEGIN_EASE;
		m_gameCenterIcon.OpasityTransitionTime = 0.3f;
		m_gameCenterIcon.ForcedRenderMode = VE_RENDER_MODE_DIFFUSE;
		
		m_howToIcon = [m_renderBox NewModelFromFileName:@"main_menu_howto"];
		m_howToIcon.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_howToIcon.ScaleTransitionTime = 0.15f;
		m_howToIcon.RotationTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_howToIcon.RotationTransitionTime = 0.1f;
		m_howToIcon.OpasityTransitionEffect = VE_TRANSITION_EFFECT_BEGIN_EASE;
		m_howToIcon.OpasityTransitionTime = 0.3f;
		m_howToIcon.ForcedRenderMode = VE_RENDER_MODE_DIFFUSE;
		
		m_aboutIcon = [m_renderBox NewModelFromFileName:@"main_menu_about"];
		m_aboutIcon.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_aboutIcon.ScaleTransitionTime = 0.15f;
		m_aboutIcon.RotationTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_aboutIcon.RotationTransitionTime = 0.1f;
		m_aboutIcon.OpasityTransitionEffect = VE_TRANSITION_EFFECT_BEGIN_EASE;
		m_aboutIcon.OpasityTransitionTime = 0.3f;
		m_aboutIcon.ForcedRenderMode = VE_RENDER_MODE_DIFFUSE;
		
		m_right = [m_renderBox NewSpriteFromFileName:@"menu_right.png"];
		m_left = [m_renderBox NewSpriteFromFileName:@"menu_left.png"];
		CommonButtonStyle(m_right);
		CommonButtonStyle(m_left);
		m_right.LockAspect = m_left.LockAspect = true;
		m_right.Opasity = 0.0f;
		m_left.Opasity = 0.0f;
		
		m_title = [m_renderBox NewSpriteFromFileName:@"CubilineTitle.png"];
		CommonButtonStyle(m_title);
		m_title.LockAspect = true;
		
		
		//// About /////
		m_background = [m_renderBox NewSolidSpriteWithColor:ColorCubiline];
		m_background.Opasity = 0.0f;
		m_background.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_background.OpasityTransitionTime = 0.15f;
		
		m_logo = [m_renderBox NewSpriteFromFileName:@"Logo.png"];
		CommonButtonStyle(m_logo);
		m_logo.LockAspect = true;
		
		m_version = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Version: 1.0.0"];
		CommonTextStyle(m_version);
		
		m_developed = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Developed by"];
		CommonTextStyle(m_developed);
		
		m_byOmarDeAnda = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"David de Anda"];
		CommonTextStyle(m_byOmarDeAnda);
		m_byOmarDeAnda.Color = FrontColor;
		
		/////////////
		
		m_light = [m_renderBox NewLight];
		m_light.Position = GLKVector3Make(0.0f, 2.0f, 5.0f);
		m_light.Color = GLKVector3Make(1.0f, 1.0f, 1.0f);
		m_light.Intensity = 0.75f;
		m_light.AttenuationDistance = 100.0f;
		m_light.AmbientCoefficient = 0.5f;
		
		m_cube = [m_renderBox NewModelFromFileName:@"white_cube"];
		m_cube.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_cube.ScaleTransitionTime = 0.09f;
		m_cube.RotationTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_cube.RotationTransitionTime = 0.13f;
		
		m_text = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Play"];
		if(m_renderBox.ScreenWidth > m_renderBox.ScreenHeight)
			m_text.FontSize = m_renderBox.ScreenHeight / 8.0f;
		else
			m_text.FontSize = m_renderBox.ScreenWidth / 8.0f;
		m_text.Color = PrimaryColor;
		m_text.Opasity = 0.0f;
		m_text.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_EASE;
		m_text.OpasityTransitionTime = 0.3f;
		
		[m_cubeScene addModel:m_cube];
		[m_cubeScene addLight:m_light];
		[m_cubeScene addModel:m_playIcon];
		[m_cubeScene addModel:m_gameCenterIcon];
		[m_cubeScene addModel:m_howToIcon];
		[m_cubeScene addModel:m_aboutIcon];
		
		[Scene addSprite:m_cubeImage];
		[Scene addText:m_text];
		[Scene addSprite:m_right];
		[Scene addSprite:m_left];
		[Scene addSprite:m_title];
		
		[Scene addSprite:m_background];
		[Scene addSprite:m_logo];
		[Scene addText:m_version];
		[Scene addText:m_developed];
		[Scene addText:m_byOmarDeAnda];
		
		m_cubeCamera = [m_renderBox NewCamera:VE_CAMERA_TYPE_PERSPECTIVE];
		m_cubeCamera.LockLookAt = true;
		m_cubeCamera.Position = GLKVector3Make(0.0f, 0.0f, 600.0f);
		m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -600.0f);
		m_cubeCamera.PivotTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_cubeCamera.PivotTransitionTime = 0.1f;
		m_cubeCamera.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
		m_cubeCamera.PositionTransitionTime = 0.1f;
		m_cubeCamera.PivotRotationTransitionEffect = VE_TRANSITION_EFFECT_EASE;
		m_cubeCamera.PivotRotationEase = 0.5f;
		m_cubeCamera.PivotRotationTransitionTime = 7.0f;
		
		m_cubeView.Camera = m_cubeCamera;
		
		Selection = CL_MAIN_MENU_SELECTION_PLAY;
		m_toProceed = false;
		
		m_watch = [[VEWatch alloc] init];
		m_watch.Style = VE_WATCH_STYLE_LIMITED;
		[m_watch SetLimitInSeconds:7.0f];
		[m_watch Reset];
		
		m_startWatch = [[VEWatch alloc] init];
		m_startWatch.Style = VE_WATCH_STYLE_LIMITED;
		[m_startWatch SetLimitInSeconds:0.01f];
		[m_startWatch Reset];
		
		m_random = [[VERandom alloc] init];
	}
	
	return self;
}

- (void)Frame:(float)time
{
	[m_watch Frame:time];
	[m_startWatch Frame:time];
	
	if(!m_startWatch.Active && !m_start)
	{
		[self PresentShit];
		m_start = true;
	}
	
	static bool flip = false;
	
	if(!m_watch.Active && !m_selected)
	{
		m_cubeCamera.PivotRotationTransitionTime = 7.0f;
		if(flip)
			m_cubeCamera.PivotRotation = GLKVector3Make([m_random NextFloatWithMin:-5.0f Max:5.0f], [m_random NextFloatWithMin:2.0f Max:10.0f], 0.0f);
		else
			m_cubeCamera.PivotRotation = GLKVector3Make([m_random NextFloatWithMin:-5.0f Max:5.0f], [m_random NextFloatWithMin:-2.0f Max:-10.0f], 0.0f);
		flip = !flip;
		[m_watch Reset];
	}
}

- (void)Render
{
	[m_cubeView Render];
	m_cubeImage.Texture = m_cubeView.Color;
}

- (void)Resize
{
	float width = m_renderBox.ScreenWidth;
	float height = m_renderBox.ScreenHeight;
	
	// Best size from the screen.
	if(width > height)
		spriteSize = height;
	else
		spriteSize = width;
	
	// Resize elements.
	[m_cubeView ResizeWithWidth:spriteSize Height:spriteSize];
	m_cubeImage.Scale = GLKVector3Make(spriteSize, -spriteSize, 0.0f);
	
	m_text.Position = GLKVector3Make(0.0f, -spriteSize / 3.0f, 0.0f);
	
	m_right.Position = GLKVector3Make(spriteSize * 0.4f, 0.0f, 0.0f);
	m_left.Position = GLKVector3Make(-spriteSize * 0.4f, 0.0f, 0.0f);
	
	m_rightRect.top = spriteSize / 3.0f;
	m_rightRect.bottom = -spriteSize / 3.0f;
	m_rightRect.right = spriteSize / 2.0f;
	m_rightRect.left = m_rightRect.right - spriteSize / 5.0f;
	
	m_leftRect.top = m_rightRect.top;
	m_leftRect.bottom = m_rightRect.bottom;
	m_leftRect.right = -m_rightRect.left;
	m_leftRect.left = -m_rightRect.right;
	
	m_right.Width = m_left.Width = spriteSize / 10.0f;
	
	m_title.Position = GLKVector3Make(0.0f, spriteSize * 0.25f + (height / 2.0f - spriteSize * 0.25f) / 2.0f, 0.0f);
	m_title.Width = spriteSize * 0.85;
	
	m_cubeLimit = spriteSize / 3.5f;
	
	/// About
	m_background.Width = width;
	m_background.Height = height;
	
	GLKVector3 position;
	
	if(width > height)
		position = GLKVector3Make(0.0f, spriteSize / 6.0f, 0.0f);
	else
		position = GLKVector3Make(0.0f, 0.0f, 0.0f);
	
	m_logo.Position = position;
	
	position.y -= spriteSize * 0.30f;
	m_version.Position = position;
	
	position.y -= spriteSize * 0.15f;
	m_developed.Position = position;
	
	position.y -= spriteSize * 0.13f;
	m_byOmarDeAnda.Position = position;
	
}

- (void)PresentShit
{
	[m_title ResetOpasity:0.0f];
	m_title.Opasity = 1.0f;
	[m_text ResetOpasity:0.0f];
	m_text.Opasity = 1.0f;
	[m_right ResetOpasity:0.0f];
	m_right.Opasity = 1.0f;
	[m_left ResetOpasity:0.0f];
	m_left.Opasity = 1.0f;
	m_cubeCamera.Position = GLKVector3Make(0.0f, 0.0f, 3.0f);
	m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -3.0f);
}

- (void)About
{
	m_viewing = true;
	[self PresentAbout];
}

- (void)PresentAbout
{
	m_background.Opasity = 0.96f;
	
	[m_logo ResetScale:GLKVector3Make(spriteSize / 2.0f, spriteSize / 2.0f, 0.0f)];
	[m_logo ResetOpasity];
	m_logo.Width = spriteSize * 0.75f;
	m_logo.Opasity = 1.0f;
	
	[m_version ResetFontSize:spriteSize * 0.1f];
	[m_version ResetOpasity];
	m_version.FontSize = spriteSize * 0.05f;
	m_version.Opasity = 1.0f;
	
	[m_developed ResetFontSize:spriteSize * 0.2f];
	[m_developed ResetOpasity];
	m_developed.FontSize = spriteSize * 0.1f;
	m_developed.Opasity = 1.0f;
	
	[m_byOmarDeAnda ResetFontSize:spriteSize * 0.15f];
	[m_byOmarDeAnda ResetOpasity];
	m_byOmarDeAnda.FontSize = spriteSize * 0.08f;
	m_byOmarDeAnda.Opasity = 1.0f;
}

- (bool)TestButton:(Rect)button X:(float)x Y:(float)y
{
	return (button.top > y && button.bottom < y && button.left < x && button.right > x);
}

- (void)TouchPanBegan:(float)x Y:(float)y Fingers:(int)fingers
{
	m_preRotation = m_cube.Rotation;
}

- (void)TouchPanChange:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_viewing)return;
	
	float move = x * 180.0f / spriteSize;
	GLKVector3 newRotation = GLKVector3Add(m_preRotation, GLKVector3Make(0.0f, move, 0.0f));
	
	m_playIcon.Rotation = newRotation;
	m_gameCenterIcon.Rotation = newRotation;
	m_howToIcon.Rotation = newRotation;
	m_aboutIcon.Rotation = newRotation;
	
	m_cube.Rotation = newRotation;
	
	m_realRotation = newRotation.y;
	
	[self DoSelect];
	
	m_toProceed = false;
	[self ReleaseCube];
}

- (void)TouchPanEnd:(float)x Y:(float)y Fingers:(int)fingers
{
	
}

- (void)TouchTap:(float)x Y:(float)y Fingers:(int)fingers Taps:(int)taps
{
	
}

- (void)TouchDown:(float)x Y:(float)y Fingers:(int)fingers
{
	float rx = x - (m_renderBox.ScreenWidth / 2);
	float ry = -(y - (m_renderBox.ScreenHeight / 2));
	
	if(m_viewing)return;
	
	m_selected = false;
	
	m_cubeCamera.PivotRotationTransitionTime = 1.0f;
	m_cubeCamera.PivotRotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
	[m_watch Reset];
	
	if([self TestButton:m_rightRect X:rx Y:ry])
	{
		m_right.Width = spriteSize / 15.0f;
		m_inButton = true;
	}
	else if([self TestButton:m_leftRect X:rx Y:ry])
	{
		m_left.Width = spriteSize / 15.0f;
		m_inButton = true;
	}
	else if(rx < m_cubeLimit && rx > -m_cubeLimit && ry < m_cubeLimit && ry > -m_cubeLimit)
	{
		m_inCube = true;
		m_toProceed = true;
		[self PressCube];
	}

}

- (void)TouchUp:(float)x Y:(float)y Fingers:(int)fingers;
{
	float rx = x - (m_renderBox.ScreenWidth / 2);
	float ry = -(y - (m_renderBox.ScreenHeight / 2));
	
	if(m_viewing)
	{
		m_logo.Opasity = 0.0f;
		m_version.Opasity = 0.0f;
		m_developed.Opasity = 0.0f;
		m_byOmarDeAnda.Opasity = 0.0f;
		m_background.Opasity = 0.0f;
		m_viewing = false;
		return;
	}
	
	m_right.Width = spriteSize / 10.0f;
	m_left.Width = spriteSize / 10.0f;
	
	if([self TestButton:m_rightRect X:rx Y:ry] && m_inButton)
	{
		m_realRotation -= 90.0f;
		[self DoSelect];
		[self ProperCube];
	}
	else if([self TestButton:m_leftRect X:rx Y:ry] && m_inButton)
	{
		m_realRotation += 90.0f;
		[self DoSelect];
		[self ProperCube];
	}
	else
	{
		[self ProperCube];
		[self ReleaseCube];
	}
	
	m_inButton = false;
}

- (void)PressCube
{
	GLKVector3 newScale = GLKVector3Make(0.9f, 0.9f, 0.9f);
	m_playIcon.Scale = newScale;
	m_gameCenterIcon.Scale = newScale;
	m_howToIcon.Scale = newScale;
	m_aboutIcon.Scale = newScale;
	
	m_cube.Scale = newScale;
}

- (void)ReleaseCube
{
	GLKVector3 newScale = GLKVector3Make(1.0f, 1.0f, 1.0f);
	GLKVector3 newSelectedScale = GLKVector3Make(1.1f, 1.1f, 1.1f);
	
	if(!GLKVector3AllEqualToVector3(m_cube.Scale, newScale))
	{
		if(Selection == CL_MAIN_MENU_SELECTION_PLAY)
			m_playIcon.Scale = newSelectedScale;
		else
			m_playIcon.Scale = newScale;
		
		if(Selection == CL_MAIN_MENU_SELECTION_GC)
			m_gameCenterIcon.Scale = newSelectedScale;
		else
			m_gameCenterIcon.Scale = newScale;
		
		if(Selection == CL_MAIN_MENU_SELECTION_HOWTO)
			m_howToIcon.Scale = newSelectedScale;
		else
			m_howToIcon.Scale = newScale;

		if(Selection == CL_MAIN_MENU_SELECTION_ABOUT)
			m_aboutIcon.Scale = newSelectedScale;
		else
			m_aboutIcon.Scale = newScale;
		
		m_cube.Scale = newScale;
	}
	
	if(m_inCube)
		m_selected = m_toProceed;
	
	m_inCube = false;
}

- (void)ProperCube
{
	GLKVector3 newRotation = GLKVector3Make(0.0f, m_properRotation, 0.0f);
	
	m_playIcon.Rotation = newRotation;
	m_gameCenterIcon.Rotation = newRotation;
	m_howToIcon.Rotation = newRotation;
	m_aboutIcon.Rotation = newRotation;
	
	m_cube.Rotation = newRotation;
	
	m_realRotation = newRotation.y;
}

- (void)DoSelect
{
	float normal = fmodf(m_realRotation, 360.0f);
	
	if(normal >= 0.0f)
	{
		if(normal >= 315.0f || normal < 45.0f)
		{
			if(Selection == CL_MAIN_MENU_SELECTION_PLAY)return;
			Selection = CL_MAIN_MENU_SELECTION_PLAY;
			
			m_playIcon.Scale = GLKVector3Make(1.1f, 1.1f, 1.1f);
			m_gameCenterIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			m_aboutIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			
			if(m_properRotation < m_realRotation)
				m_properRotation += 90.0f;
			else
				m_properRotation -= 90.0f;
			m_preProperRotation = m_realRotation;
			
			m_text.Text = @"Play";
		}
		
		if(normal >= 45.0f && normal < 135.0f)
		{
			if(Selection == CL_MAIN_MENU_SELECTION_ABOUT)return;
			Selection = CL_MAIN_MENU_SELECTION_ABOUT;
			
			m_aboutIcon.Scale = GLKVector3Make(1.1f, 1.1f, 1.1f);
			m_playIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			m_howToIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			
			if(m_properRotation < m_realRotation)
				m_properRotation += 90.0f;
			else
				m_properRotation -= 90.0f;
			m_preProperRotation = m_realRotation;
			
			m_text.Text = @"About";
		}
		
		if(normal >= 135.0f && normal < 225.0f)
		{
			if(Selection == CL_MAIN_MENU_SELECTION_HOWTO)return;
			Selection = CL_MAIN_MENU_SELECTION_HOWTO;
			
			m_howToIcon.Scale = GLKVector3Make(1.1f, 1.1f, 1.1f);
			m_gameCenterIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			m_aboutIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			
			if(m_properRotation < m_realRotation)
				m_properRotation += 90.0f;
			else
				m_properRotation -= 90.0f;
			m_preProperRotation = m_realRotation;
			
			m_text.Text = @"How To Play";
		}
		
		if(normal >= 225.0f && normal < 315.0f)
		{
			if(Selection == CL_MAIN_MENU_SELECTION_GC)return;
			Selection = CL_MAIN_MENU_SELECTION_GC;
			
			m_gameCenterIcon.Scale = GLKVector3Make(1.1f, 1.1f, 1.1f);
			m_playIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			m_howToIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			
			if(m_properRotation < m_realRotation)
				m_properRotation += 90.0f;
			else
				m_properRotation -= 90.0f;
			m_preProperRotation = m_realRotation;
			
			m_text.Text = @"Game Center";
		}
	}
	else
	{
		if(normal <= -315.0f || normal > -45.0f)
		{
			if(Selection == CL_MAIN_MENU_SELECTION_PLAY)return;
			Selection = CL_MAIN_MENU_SELECTION_PLAY;
			
			m_playIcon.Scale = GLKVector3Make(1.1f, 1.1f, 1.1f);
			m_gameCenterIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			m_aboutIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			
			if(m_properRotation < m_realRotation)
				m_properRotation += 90.0f;
			else
				m_properRotation -= 90.0f;
			m_preProperRotation = m_realRotation;
			
			m_text.Text = @"Play";
		}
		if(normal <= -45.0f && normal > -135.0f)
		{
			if(Selection == CL_MAIN_MENU_SELECTION_GC)return;
			Selection = CL_MAIN_MENU_SELECTION_GC;
			
			m_gameCenterIcon.Scale = GLKVector3Make(1.1f, 1.1f, 1.1f);
			m_playIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			m_howToIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			
			if(m_properRotation < m_realRotation)
				m_properRotation += 90.0f;
			else
				m_properRotation -= 90.0f;
			m_preProperRotation = m_realRotation;
			
			m_text.Text = @"Game Center";
		}
		if(normal <= -135.0f && normal > -225.0f)
		{
			if(Selection == CL_MAIN_MENU_SELECTION_HOWTO)return;
			Selection = CL_MAIN_MENU_SELECTION_HOWTO;
			
			m_howToIcon.Scale = GLKVector3Make(1.1f, 1.1f, 1.1f);
			m_gameCenterIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			m_aboutIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			
			if(m_properRotation < m_realRotation)
				m_properRotation += 90.0f;
			else
				m_properRotation -= 90.0f;
			m_preProperRotation = m_realRotation;
			
			m_text.Text = @"How To Play";
		}
		if(normal <= -225.0f && normal > -315.0f)
		{
			if(Selection == CL_MAIN_MENU_SELECTION_ABOUT)return;
			Selection = CL_MAIN_MENU_SELECTION_ABOUT;
			
			m_aboutIcon.Scale = GLKVector3Make(1.1f, 1.1f, 1.1f);
			m_playIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			m_howToIcon.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
			
			if(m_properRotation < m_realRotation)
				m_properRotation += 90.0f;
			else
				m_properRotation -= 90.0f;
			m_preProperRotation = m_realRotation;
			
			m_text.Text = @"About";
		}
	}
}

- (void)InFromPlaying
{
	[m_cubeCamera ResetPivot:GLKVector3Make(0.0f, 0.0f, -7.5f)];
	[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, 7.5f)];
	[m_cubeCamera ResetPivotRotation:GLKVector3Make(0.0f, 0.0f, 0.0f)];
	[m_cubeCamera Frame:0.0f];
	m_text.Opasity = 1.0f;
	m_playIcon.Opasity = 1.0f;
	m_gameCenterIcon.Opasity = 1.0f;
	Selection = CL_MAIN_MENU_SELECTION_PLAY;
	[m_watch Reset];
	[m_watch SetLimitInSeconds:7.0f];
	m_cubeCamera.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_cubeCamera.PositionTransitionTime = 0.1f;
	m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -3.0f);
	m_cubeCamera.Position = GLKVector3Make(0.0f, 0.0f, 3.0f);
	
	m_right.Opasity = 1.0f;
	m_left.Opasity = 1.0f;
	m_title.Opasity = 1.0f;
}

- (void)OutToPlay
{
	m_cubeCamera.PivotTransitionEffect = VE_TRANSITION_EFFECT_HARD;
	m_cubeCamera.PivotTransitionTime = 0.8f;
	m_cubeCamera.PositionTransitionEffect = VE_TRANSITION_EFFECT_HARD;
	m_cubeCamera.PositionTransitionTime = 0.8f;
	
	m_playIcon.Opasity = 0.0f;
	m_gameCenterIcon.Opasity = 0.0f;
	m_cubeCamera.PivotTransitionEffect = VE_TRANSITION_EFFECT_HARD;
	m_cubeCamera.PivotTransitionTime = 0.8f;
	m_cubeCamera.PositionTransitionEffect = VE_TRANSITION_EFFECT_HARD;
	m_cubeCamera.PositionTransitionTime = 0.8f;
	m_cubeCamera.PivotRotationTransitionTime = 0.8f;
	m_cubeCamera.PivotRotationTransitionEffect = VE_TRANSITION_EFFECT_HARD;
	m_cubeCamera.Position = GLKVector3Make(0.0f, 0.0f, 7.3f);
	m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -7.3f);
	m_cubeCamera.PivotRotation = GLKVector3Make(26.5650501f, 0.0f, 0.0f);
	m_text.Opasity = 0.0f;
	
	m_right.Opasity = 0.0f;
	m_left.Opasity = 0.0f;
	m_title.Opasity = 0.0f;
	
	[m_watch Reset];
	[m_watch SetLimitInSeconds:0.8f];
}

- (void)Reset
{
	m_selected = false;
}

- (bool)Selected
{
	return m_selected;
}

- (bool)OutReady
{
	return !m_watch.Active;
}

@end