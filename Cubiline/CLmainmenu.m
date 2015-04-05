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
	float m_buttonSize;
	
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
	
	
	/// Sounds
	VEAudioBox* m_audioBox;
	VESound* m_flipSound;
	
	VESprite* m_audioSetUpOn;
	VESprite* m_audioSetUpOff;
	Rect m_audioSetUpRect;
	
	
	enum HOW_TO
	{
		HOW_TO_NONE,
		HOW_TO_MOVE,
		HOW_TO_MOVE_WELL,
		HOW_TO_EAT,
		HOW_TO_POWER,
		HOW_TO_SCORE,
		HOW_TO_LEVEL
	};
	
	enum HOW_TO m_howtoFase;
	
	
	//// Move
	VESprite* m_moveUp;
	VESprite* m_moveDown;
	VESprite* m_moveLeft;
	VESprite* m_moveRight;
	VEText* m_moveText;
	VEText* m_moveTitle;
	
	VESprite* m_moveWell1;
	VESprite* m_moveWell2;
	VESprite* m_moveWell3;
	VESprite* m_moveWell4;
	VEText* m_moveWellText;
	VEText* m_moveWellTitle;
	
	VEText* m_tapToNextText;
}

- (void)PressCube;
- (void)ReleaseCube;
- (void)ProperCube;
- (void)DoSelect;

- (bool)TestButton:(Rect)button X:(float)x Y:(float)y;
- (void)PresentShit;
- (void)PresentAbout;
- (void)PresentHowTo;
- (void)PresentHowToWell;

@end

@implementation CLMainMenu

@synthesize Scene;
@synthesize Camera;
@synthesize Selection;

@synthesize GameCenter;
@synthesize GameData;

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
		
		
		//// Audio SetUp
		m_audioSetUpOn = [m_renderBox NewSpriteFromFileName:@"sound_button_on.png"];
		m_audioSetUpOff = [m_renderBox NewSpriteFromFileName:@"sound_button_off.png"];
		CommonButtonStyle(m_audioSetUpOn);
		CommonButtonStyle(m_audioSetUpOff);
		
		
		
		////////
		
		m_moveUp = [m_renderBox NewSpriteFromFileName:@"how_to_move_up.png"];
		CommonButtonStyle(m_moveUp);
		m_moveDown = [m_renderBox NewSpriteFromFileName:@"how_to_move_down.png"];
		CommonButtonStyle(m_moveDown);
		m_moveRight = [m_renderBox NewSpriteFromFileName:@"how_to_move_right.png"];
		CommonButtonStyle(m_moveRight);
		m_moveLeft = [m_renderBox NewSpriteFromFileName:@"how_to_move_left.png"];
		CommonButtonStyle(m_moveLeft);
		m_moveText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Drag to the side you want to turn"];
		CommonTextStyle(m_moveText);
		m_moveTitle = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"How To Turn"];
		CommonTextStyle(m_moveTitle);
		
		m_moveWell1 = [m_renderBox NewSpriteFromFileName:@"how_to_move_well3.png"];
		CommonButtonStyle(m_moveWell1);
		m_moveWell2 = [m_renderBox NewSpriteFromFileName:@"how_to_move_well4.png"];
		CommonButtonStyle(m_moveWell2);
		m_moveWell3 = [m_renderBox NewSpriteFromFileName:@"how_to_move_well1.png"];
		CommonButtonStyle(m_moveWell3);
		m_moveWell4 = [m_renderBox NewSpriteFromFileName:@"how_to_move_well2.png"];
		CommonButtonStyle(m_moveWell4);
		m_moveWellText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Drag to the opposite direction tilting the sweep"];
		CommonTextStyle(m_moveWellText);
		m_moveWellTitle = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"How To Return Quickly"];
		CommonTextStyle(m_moveWellTitle);
		
		m_tapToNextText = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Tap To See Next"];
		CommonTextStyle(m_tapToNextText);
		
		////
		
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
		
		[Scene addSprite:m_audioSetUpOn];
		[Scene addSprite:m_audioSetUpOff];
		
		[Scene addSprite:m_background];
		[Scene addSprite:m_logo];
		[Scene addText:m_version];
		[Scene addText:m_developed];
		[Scene addText:m_byOmarDeAnda];
		
		[Scene addSprite:m_moveUp];
		[Scene addSprite:m_moveDown];
		[Scene addSprite:m_moveRight];
		[Scene addSprite:m_moveLeft];
		[Scene addText:m_moveText];
		[Scene addText:m_moveTitle];
		
		[Scene addSprite:m_moveWell1];
		[Scene addSprite:m_moveWell2];
		[Scene addSprite:m_moveWell3];
		[Scene addSprite:m_moveWell4];
		[Scene addText:m_moveWellText];
		[Scene addText:m_moveWellTitle];
		
		[Scene addText:m_tapToNextText];
		
		
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
		
		/// Sounds
		m_audioBox = [VEAudioBox sharedVEAudioBox];
		m_flipSound = [m_audioBox NewSoundWithFileName:@"flip.wav"];
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
	
	m_buttonSize = spriteSize / 5.0f;
	
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
	
	m_audioSetUpOn.Position = GLKVector3Make(width / 2.0f - m_buttonSize / 3.0f, -height / 2.0f + m_buttonSize / 3.0f, 0.0f);
	m_audioSetUpOff.Position = GLKVector3Make(width / 2.0f - m_buttonSize / 3.0f, -height / 2.0f + m_buttonSize / 3.0f, 0.0f);
	
	m_audioSetUpRect.top = -height / 2.0f + (m_buttonSize / 3.0f) * 1.8f;
	m_audioSetUpRect.bottom = -height / 2.0f;
	m_audioSetUpRect.left = width / 2.0f - (m_buttonSize / 3.0f) * 1.8f;
	m_audioSetUpRect.right = width / 2.0f;
	
	
	m_moveUp.Position = GLKVector3Make(-m_buttonSize, m_buttonSize, 0.0f);
	m_moveDown.Position = GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f);
	m_moveRight.Position = GLKVector3Make(-m_buttonSize, -m_buttonSize, 0.0f);
	m_moveLeft.Position = GLKVector3Make(m_buttonSize, -m_buttonSize, 0.0f);
	m_moveTitle.Position = GLKVector3Make(0.0f, m_buttonSize * 2.2f, 0.0f);
	
	m_moveWell1.Position = GLKVector3Make(-m_buttonSize, m_buttonSize, 0.0f);
	m_moveWell2.Position = GLKVector3Make(m_buttonSize, m_buttonSize, 0.0f);
	m_moveWell3.Position = GLKVector3Make(-m_buttonSize, -m_buttonSize, 0.0f);
	m_moveWell4.Position = GLKVector3Make(m_buttonSize, -m_buttonSize, 0.0f);
	m_moveWellTitle.Position = GLKVector3Make(0.0f, m_buttonSize * 2.2f, 0.0f);
	
	m_tapToNextText.Position = GLKVector3Make(0.0f, -m_buttonSize * 2.3f, 0.0f);
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
	
	if(!GameData.New)
	{
		m_realRotation += 90.0f;
		[self DoSelect];
		m_realRotation += 90.0f;
		[self DoSelect];
		[self ProperCube];
		
		GameData.New = true;
	}
	
	
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

- (void)About
{
	m_viewing = true;
	[self PresentAbout];
}

- (void)HowTo
{
	m_howtoFase = HOW_TO_MOVE;
	[self PresentHowTo];
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

- (void)PresentHowTo
{
	m_background.Opasity = 0.96f;
	
	[m_tapToNextText ResetFontSize:m_buttonSize * 1.2f];
	[m_tapToNextText ResetOpasity];
	m_tapToNextText.FontSize = m_buttonSize * 0.35f;
	m_tapToNextText.Opasity = 1.0f;
	
	[m_moveUp ResetScale:GLKVector3Make(m_buttonSize * 3.0f, m_buttonSize * 3.0f, 0.0f)];
	[m_moveUp ResetOpasity];
	m_moveUp.Width = m_buttonSize * 2.0f;
	m_moveUp.Opasity = 1.0f;
	
	[m_moveDown ResetScale:GLKVector3Make(m_buttonSize * 3.0f, m_buttonSize * 3.0f, 0.0f)];
	[m_moveDown ResetOpasity];
	m_moveDown.Width = m_buttonSize * 2.0f;
	m_moveDown.Opasity = 1.0f;
	
	[m_moveRight ResetScale:GLKVector3Make(m_buttonSize * 3.0f, m_buttonSize * 3.0f, 0.0f)];
	[m_moveRight ResetOpasity];
	m_moveRight.Width = m_buttonSize * 2.0f;
	m_moveRight.Opasity = 1.0f;
	
	[m_moveLeft ResetScale:GLKVector3Make(m_buttonSize * 3.0f, m_buttonSize * 3.0f, 0.0f)];
	[m_moveLeft ResetOpasity];
	m_moveLeft.Width = m_buttonSize * 2.0f;
	m_moveLeft.Opasity = 1.0f;
	
	[m_moveText ResetFontSize:m_buttonSize * 0.8f];
	[m_moveText ResetOpasity];
	m_moveText.FontSize = m_buttonSize * 0.2f;
	m_moveText.Opasity = 1.0f;
	
	[m_moveTitle ResetFontSize:m_buttonSize * 1.2f];
	[m_moveTitle ResetOpasity];
	m_moveTitle.FontSize = m_buttonSize * 0.35f;
	m_moveTitle.Opasity = 1.0f;
}

- (void)PresentHowToWell
{
	m_moveUp.Opasity = 0.0f;
	m_moveDown.Opasity = 0.0f;
	m_moveRight.Opasity = 0.0f;
	m_moveLeft.Opasity = 0.0f;
	m_moveTitle.Opasity = 0.0f;
	m_moveText.Opasity = 0.0f;
	
	[m_moveWell1 ResetScale:GLKVector3Make(m_buttonSize * 3.0f, m_buttonSize * 3.0f, 0.0f)];
	[m_moveWell1 ResetOpasity];
	m_moveWell1.Width = m_buttonSize * 2.0f;
	m_moveWell1.Opasity = 1.0f;
	
	[m_moveWell2 ResetScale:GLKVector3Make(m_buttonSize * 3.0f, m_buttonSize * 3.0f, 0.0f)];
	[m_moveWell2 ResetOpasity];
	m_moveWell2.Width = m_buttonSize * 2.0f;
	m_moveWell2.Opasity = 1.0f;
	
	[m_moveWell3 ResetScale:GLKVector3Make(m_buttonSize * 3.0f, m_buttonSize * 3.0f, 0.0f)];
	[m_moveWell3 ResetOpasity];
	m_moveWell3.Width = m_buttonSize * 2.0f;
	m_moveWell3.Opasity = 1.0f;
	
	[m_moveWell4 ResetScale:GLKVector3Make(m_buttonSize * 3.0f, m_buttonSize * 3.0f, 0.0f)];
	[m_moveWell4 ResetOpasity];
	m_moveWell4.Width = m_buttonSize * 2.0f;
	m_moveWell4.Opasity = 1.0f;
	
	[m_moveWellText ResetFontSize:m_buttonSize * 0.8f];
	[m_moveWellText ResetOpasity];
	m_moveWellText.FontSize = m_buttonSize * 0.2f;
	m_moveWellText.Opasity = 1.0f;
	
	[m_moveWellTitle ResetFontSize:m_buttonSize * 1.2f];
	[m_moveWellTitle ResetOpasity];
	m_moveWellTitle.FontSize = m_buttonSize * 0.35f;
	m_moveWellTitle.Opasity = 1.0f;
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
	if(m_viewing || m_howtoFase != HOW_TO_NONE)return;
	
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
	
	if(m_viewing || m_howtoFase != HOW_TO_NONE)return;
	
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
	else if([self TestButton:m_audioSetUpRect X:rx Y:ry])
	{
		m_audioSetUpOn.Width = m_buttonSize * 0.2f;
		m_audioSetUpOff.Width = m_buttonSize * 0.2f;
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
	
	if(m_howtoFase == HOW_TO_MOVE)
	{
		m_howtoFase = HOW_TO_MOVE_WELL;
		[self PresentHowToWell];
		return;
	}
	else if(m_howtoFase == HOW_TO_MOVE_WELL)
	{
		m_howtoFase = HOW_TO_EAT;
		return;
	}
	else if(m_howtoFase == HOW_TO_EAT)
	{
		m_howtoFase = HOW_TO_POWER;
		return;
	}
	else if(m_howtoFase == HOW_TO_POWER)
	{
		m_howtoFase = HOW_TO_SCORE;
		return;
	}
	else if(m_howtoFase == HOW_TO_SCORE)
	{
		m_howtoFase = HOW_TO_LEVEL;
		return;
	}
	else if(m_howtoFase == HOW_TO_LEVEL)
	{
		m_howtoFase = HOW_TO_NONE;
		m_background.Opasity = 0.0f;
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
	else if([self TestButton:m_audioSetUpRect X:rx Y:ry] && m_inButton)
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
	else
	{
		[self ProperCube];
		[self ReleaseCube];
	}
	
	m_audioSetUpOn.Width = m_buttonSize / 3.0f;
	m_audioSetUpOff.Width = m_buttonSize / 3.0f;
	
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
			
			[m_flipSound Stop];
			[m_flipSound Play];
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
			
			[m_flipSound Stop];
			[m_flipSound Play];
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
			
			[m_flipSound Stop];
			[m_flipSound Play];
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
			
			[m_flipSound Stop];
			[m_flipSound Play];
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
			
			[m_flipSound Stop];
			[m_flipSound Play];
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
			
			[m_flipSound Stop];
			[m_flipSound Play];
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
			
			[m_flipSound Stop];
			[m_flipSound Play];
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
			
			[m_flipSound Stop];
			[m_flipSound Play];
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
	
	if(m_audioBox.Mute)
	{
		m_audioSetUpOff.Opasity = 1.0f;
	}
	else
	{
		m_audioSetUpOn.Opasity = 1.0f;
	}
	
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
	
	m_audioSetUpOn.Opasity = 0.0f;
	m_audioSetUpOff.Opasity = 0.0f;
	
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

- (void)setGameData:(CLData *)gameData
{
	GameData = gameData;

}

- (CLData*)GameData
{
	return GameData;
}

@end