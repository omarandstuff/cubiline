#import "CLlevel.h"

@interface CLLevel()
{
	VERenderBox* m_renderBox;
	VEModel* m_guides;
	
	VEEffect1* m_testSpeed;
	
	bool m_testDirection;
	float m_testSpeedStart;
	float m_testSpeedEnd;
}

- (void)CreateLevel;
- (void)ResizeLevel:(enum CL_SIZE)size;
- (void)ChangeSpeed:(enum CL_SIZE)speed;
- (void)TestModeActions;

@end

@implementation CLLevel

@synthesize Leader;
@synthesize Food;
@synthesize Body;
@synthesize FrontWall;
@synthesize BackWall;
@synthesize RightWall;
@synthesize LeftWall;
@synthesize TopWall;
@synthesize BottomWall;
@synthesize TopLight;
@synthesize BottomLight;
@synthesize Scene;
@synthesize Size = _Size;
@synthesize Speed;
@synthesize Zone;
@synthesize Direction;
@synthesize BodyColor;

- (id)initWithRenderBox:(VERenderBox *)renderbox
{
	self = [super init];
	
	if(self)
	{
		m_renderBox = renderbox;
		
		[self CreateLevel];
		[self Reset];
	}
	
	return self;
}

- (void)Frame:(float)time
{
	[m_testSpeed Frame:time];
	[self TestModeActions];
}

- (void)Reset
{
	[self ResetInZone:CL_ZONE_FRONT Up:CL_ZONE_TOP];
}

- (void)ResetInZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up
{
	float limit = _Size == CL_SIZE_SMALL ? SmallSizeLimit + 0.5f : _Size == CL_SIZE_NORMAL ? NormalSizeLimit + 0.5f : BigSizeLimit + 0.5f;
	
	Zone = zone;
	
	if(zone == CL_ZONE_FRONT)
	{
		[Leader ResetPosition:GLKVector3Make(0.0f, 0.0f, limit)];
		[Leader Frame:0.0f];
		
		if(up == CL_ZONE_TOP)
			Direction = CL_ZONE_RIGHT;
		if(up == CL_ZONE_BOTTOM)
			Direction = CL_ZONE_LEFT;
		if(up == CL_ZONE_RIGHT)
			Direction = CL_ZONE_BOTTOM;
		if(up == CL_ZONE_LEFT)
			Direction = CL_ZONE_TOP;
	}
	else if(zone == CL_ZONE_BACK)
	{
		[Leader ResetPosition:GLKVector3Make(0.0f, 0.0f, -limit)];
		[Leader Frame:0.0f];
		
		if(up == CL_ZONE_TOP)
			Direction = CL_ZONE_LEFT;
		if(up == CL_ZONE_BOTTOM)
			Direction = CL_ZONE_RIGHT;
		if(up == CL_ZONE_RIGHT)
			Direction = CL_ZONE_TOP;
		if(up == CL_ZONE_LEFT)
			Direction = CL_ZONE_BOTTOM;
	}
	else if(zone == CL_ZONE_RIGHT)
	{
		[Leader ResetPosition:GLKVector3Make(limit, 0.0f, 0.0f)];
		[Leader Frame:0.0f];
		
		if(up == CL_ZONE_FRONT)
			Direction = CL_ZONE_TOP;
		if(up == CL_ZONE_BACK)
			Direction = CL_ZONE_BOTTOM;
		if(up == CL_ZONE_TOP)
			Direction = CL_ZONE_BACK;
		if(up == CL_ZONE_BOTTOM)
			Direction = CL_ZONE_FRONT;
	}
	else if(zone == CL_ZONE_LEFT)
	{
		[Leader ResetPosition:GLKVector3Make(-limit, 0.0f, 0.0f)];
		[Leader Frame:0.0f];
		
		if(up == CL_ZONE_FRONT)
			Direction = CL_ZONE_BOTTOM;
		if(up == CL_ZONE_BACK)
			Direction = CL_ZONE_TOP;
		if(up == CL_ZONE_TOP)
			Direction = CL_ZONE_FRONT;
		if(up == CL_ZONE_BOTTOM)
			Direction = CL_ZONE_BACK;
	}
	else if(zone == CL_ZONE_TOP)
	{
		[Leader ResetPosition:GLKVector3Make(0.0f, limit, 0.0f)];
		[Leader Frame:0.0f];
		
		if(up == CL_ZONE_FRONT)
			Direction = CL_ZONE_LEFT;
		if(up == CL_ZONE_BACK)
			Direction = CL_ZONE_RIGHT;
		if(up == CL_ZONE_RIGHT)
			Direction = CL_ZONE_FRONT;
		if(up == CL_ZONE_LEFT)
			Direction = CL_ZONE_BACK;
	}
	else if(zone == CL_ZONE_BOTTOM)
	{
		[Leader ResetPosition:GLKVector3Make(0.0f, -limit, 0.0f)];
		[Leader Frame:0.0f];
		
		if(up == CL_ZONE_FRONT)
			Direction = CL_ZONE_RIGHT;
		if(up == CL_ZONE_BACK)
			Direction = CL_ZONE_LEFT;
		if(up == CL_ZONE_RIGHT)
			Direction = CL_ZONE_BACK;
		if(up == CL_ZONE_LEFT)
			Direction = CL_ZONE_FRONT;
	}
	
	
	// Body.
	[Body removeAllObjects];
	[self AddBodyWithSize:3.0f];
}

- (void)TestModeActions
{
	float limit = FrontWall.Scale.x / 2.0f + 0.5;
	
	VEModel* first = ((CLBody*)[Body firstObject]).Model;
	
	if(!m_testSpeed.IsActive)
	{
		if(m_testDirection)
			m_testSpeed.Value = m_testSpeedEnd;
		else
			m_testSpeed.Value = m_testSpeedStart;
		m_testDirection = !m_testDirection;
	}
	
	[Leader ResetPosition:GLKVector3Make(m_testSpeed.Value, 0.0f, limit)];
	[first ResetPosition:GLKVector3Make(m_testSpeed.Value - 2.0f, 0.0f, limit)];
}

- (void)ResizeLevel:(enum CL_SIZE)size
{
	if(size == CL_SIZE_SMALL)
	{
		FrontWall.Scale = SmallSizeVector;
		BackWall.Scale = SmallSizeVector;
		RightWall.Scale = SmallSizeVector;
		LeftWall.Scale = SmallSizeVector;
		TopWall.Scale = SmallSizeVector;
		BottomWall.Scale = SmallSizeVector;
		
		m_guides.Scale = GuidesSmallSizeVector;
		m_guides.TextureCompression = SmallSizeVector;
		
		m_testSpeedStart = -SmallSizeLimit + 3.5f;
		m_testSpeedEnd = SmallSizeLimit - 0.5f;
	}
	else if(size == CL_SIZE_NORMAL)
	{
		FrontWall.Scale = NormalSizeVector;
		BackWall.Scale = NormalSizeVector;
		RightWall.Scale = NormalSizeVector;
		LeftWall.Scale = NormalSizeVector;
		TopWall.Scale = NormalSizeVector;
		BottomWall.Scale = NormalSizeVector;
		
		m_guides.Scale = GuidesNormalSizeVector;
		m_guides.TextureCompression = NormalSizeVector;
		
		m_testSpeedStart = -NormalSizeLimit + 3.5f;
		m_testSpeedEnd = NormalSizeLimit - 0.5f;
	}
	else if(size == CL_SIZE_BIG)
	{
		FrontWall.Scale = BigSizeVector;
		BackWall.Scale = BigSizeVector;
		RightWall.Scale = BigSizeVector;
		LeftWall.Scale = BigSizeVector;
		TopWall.Scale = BigSizeVector;
		BottomWall.Scale = BigSizeVector;
		
		m_guides.Scale = GuidesBigSizeVector;
		m_guides.TextureCompression = BigSizeVector;
		
		m_testSpeedStart = -BigSizeLimit + 3.5f;
		m_testSpeedEnd = BigSizeLimit - 0.5f;
	}
	
	[m_testSpeed Reset:m_testSpeed.Value];
	
	if(!m_testDirection)
		m_testSpeed.Value = m_testSpeedEnd;
	else
		m_testSpeed.Value = m_testSpeedStart;
	
	if(m_testDirection && m_testSpeed.Value > m_testSpeedEnd)
	{
		m_testDirection = false;
		m_testSpeed.Value = m_testSpeedStart;
	}
	if(!m_testDirection && m_testSpeed.Value < m_testSpeedStart)
	{
		m_testDirection = true;
		m_testSpeed.Value = m_testSpeedEnd;
	}
}

- (void)ChangeSpeed:(enum CL_SIZE)speed
{
	if(speed == CL_SIZE_SMALL)
	{
		m_testSpeed.TransitionSpeed = 5.0f;
		Leader.PositionTransitionSpeed = 1.0f;
	}
	else if(speed == CL_SIZE_NORMAL)
	{
		m_testSpeed.TransitionSpeed = 7.0f;
		Leader.PositionTransitionSpeed = 2.0f;
	}
	else if(speed == CL_SIZE_BIG)
	{
		m_testSpeed.TransitionSpeed = 10.0f;
		Leader.PositionTransitionSpeed = 3.0f;
	}
	
	[m_testSpeed Reset:m_testSpeed.Value];
	
	if(!m_testDirection)
		m_testSpeed.Value = m_testSpeedEnd;
	else
		m_testSpeed.Value = m_testSpeedStart;
}

- (void)FocusLeaderInCamera:(VECamera*)camera
{
	float focusDistance = GLKVector3Length(GLKVector3Subtract(Leader.Position, camera.Position));
	camera.FocusDistance = focusDistance;
}

- (void)AddBodyWithSize:(float)size
{
	[Body addObject:[[CLBody alloc] initWithRenderBox:m_renderBox Scene:Scene Zone:Zone Direction:Direction BornPosition:Leader.Position Size:size Color:BodyColor]];
}

- (void)CreateLevel
{
	BodyColor = GLKVector3Make(0.9f, 0.95f, 1.0f);
	
	// Leader
	Leader = [m_renderBox NewModelFromFileName:@"quad"];
	Leader.PositionTransitionEffect = VE_TRANSITION_EFFECT_HARD;
	Leader.Color = BodyColor;
	
	// Food
	Food = [m_renderBox NewModelFromFileName:@"geosphere_medium"];
	
	// Create Walls
	FrontWall = [m_renderBox NewModelFromFileName:@"front_wall"];
	BackWall = [m_renderBox NewModelFromFileName:@"back_wall"];
	RightWall = [m_renderBox NewModelFromFileName:@"right_wall"];
	LeftWall = [m_renderBox NewModelFromFileName:@"left_wall"];
	TopWall = [m_renderBox NewModelFromFileName:@"top_wall"];
	BottomWall = [m_renderBox NewModelFromFileName:@"bottom_wall"];
	
	m_guides = [m_renderBox NewModelFromFileName:@"game_guides"];
	m_guides.TextureCompressionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_guides.TextureCompressionTransitionTime = 0.3f;
	m_guides.Opasity = 0.25f;
	
	FrontWall.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	BackWall.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	RightWall.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	LeftWall.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	TopWall.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	BottomWall.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	
	m_guides.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	
	FrontWall.ScaleTransitionTime = 0.2f;
	BackWall.ScaleTransitionTime = 0.2f;
	RightWall.ScaleTransitionTime = 0.2f;
	LeftWall.ScaleTransitionTime = 0.2f;
	TopWall.ScaleTransitionTime = 0.2f;
	BottomWall.ScaleTransitionTime = 0.2f;
	
	m_guides.ScaleTransitionTime = 0.2f;
	
	FrontWall.Color = FrontColor;
	BackWall.Color = GrayColor;
	RightWall.Color = GrayColor;
	LeftWall.Color = GrayColor;
	TopWall.Color = GrayColor;
	BottomWall.Color = GrayColor;
	
	FrontWall.ColorTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	BackWall.ColorTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	RightWall.ColorTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	LeftWall.ColorTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	TopWall.ColorTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	BottomWall.ColorTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	
	FrontWall.ColorTransitionTime = 0.4f;
	BackWall.ColorTransitionTime = 0.4f;
	RightWall.ColorTransitionTime = 0.4f;
	LeftWall.ColorTransitionTime = 0.4f;
	TopWall.ColorTransitionTime = 0.4f;
	BottomWall.ColorTransitionTime = 0.4f;
	
	// Lights
	TopLight = [m_renderBox NewLight];
	TopLight.Position = GLKVector3Make(-45.0, 40.0f, 40.0f);
	TopLight.AmbientCoefficient = 0.1f;
	TopLight.AttenuationDistance = 200.0f;
	TopLight.Intensity = 1.7f;
	
	BottomLight = [m_renderBox NewLight];
	BottomLight.Position = GLKVector3Make(45.0, -40.0f, -40.0);
	BottomLight.AmbientCoefficient = 0.1f;
	BottomLight.AttenuationDistance = 200.0f;
	BottomLight.Intensity = 1.7f;
	
	// Scene
	Scene = [m_renderBox NewSceneWithName:@"LevelScene"];
	
	// Add models to scene
	[Scene addModel:FrontWall];
	[Scene addModel:BackWall];
	[Scene addModel:RightWall];
	[Scene addModel:LeftWall];
	[Scene addModel:TopWall];
	[Scene addModel:BottomWall];
	[Scene addModel:Leader];
	[Scene addModel:Food];
	[Scene addModel:m_guides];
	
	[Scene addLight:TopLight];
	[Scene addLight:BottomLight];
	
	// Body
	Body = [[NSMutableArray alloc] init];
	
	// Test speed
	m_testSpeed = [[VEEffect1 alloc] init];
	m_testSpeed.TransitionEffect = VE_TRANSITION_EFFECT_HARD;
	m_testSpeed.TransitionSpeed = 5.0f;
}

- (void)setSize:(enum CL_SIZE)size
{
	_Size = size;
	[self ResizeLevel:size];
}

- (enum CL_SIZE)Size
{
	return _Size;
}

- (void)setSpeed:(enum CL_SIZE)speed
{
	Speed = speed;
	[self ChangeSpeed:speed];
}

- (enum CL_SIZE)Speed
{
	return Speed;
}

@end