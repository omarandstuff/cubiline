#import "CLlevel.h"

@interface CLLevel()
{
	VERenderBox* m_renderBox;
	VEModel* m_guides;
	
	// Line control
	GLKVector3 m_preLeaderPosition;
	bool m_toNew;
	
	// Eating control
	bool m_eating;
	float m_stepGrown;
	float m_toGrow;
	
	// Edge control
	float m_cubeEdgeLimit;
	float m_cubeEdgeLogicalLimit;
	bool m_noZone;
	bool m_noZoneFase;
	
	// Camera control
	VE3DObject* m_leaderGhost;
	float m_radious;

	
	// Turn control
	bool m_bufferTurn;
	bool m_justBuffered;
	enum CL_HANDLE m_nextHandle;
}


// Level initialization and reshape.
- (void)CreateLevel;
- (void)ResizeLevel:(enum CL_SIZE)size;
- (void)ChangeSpeed:(enum CL_SIZE)speed;

// Line iteractions.

- (void)AddBodyWithSize:(float)size;
- (void)MannageBody;
- (void)SwitchZoneColor:(enum CL_ZONE)prezone NewZone:(enum CL_ZONE)newzone;
- (void)MannageZones;

// Turn iterations
- (enum CL_ZONE)GetUpOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;
- (enum CL_ZONE)GetDownOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;
- (enum CL_ZONE)GetRightOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;
- (enum CL_ZONE)GetLeftOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;
- (enum CL_HANDLE)GetHandleForDirection:(enum CL_ZONE)direction;
- (enum CL_HANDLE)GetComplexHandleForDirection:(enum CL_ZONE)direction SecundaryDirection:(enum CL_ZONE)secundarydirection;
- (void)doTurn:(enum CL_TURN)turn;
- (void)TurnUpRight;
- (void)TurnUpLeft;
- (void)TurnDownRight;
- (void)TurnDownLeft;
- (void)TurnRightUp;
- (void)TurnRightDown;
- (void)TurnLeftUp;
- (void)TurnLeftDown;



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
@synthesize ZoneUp;
@synthesize BodyColor;
@synthesize FocusedCamera;

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
	[self MannageZones];
	[self MannageBody];
}

- (void)Play
{
	GLKVector3 position = Leader.Position;
	if(Direction == CL_ZONE_FRONT)
		position.z = m_cubeEdgeLimit;
	if(Direction == CL_ZONE_BACK)
		position.z = -m_cubeEdgeLimit;
	if(Direction == CL_ZONE_RIGHT)
		position.x = m_cubeEdgeLimit;
	if(Direction == CL_ZONE_LEFT)
		position.x = -m_cubeEdgeLimit;
	if(Direction == CL_ZONE_TOP)
		position.y = m_cubeEdgeLimit;
	if(Direction == CL_ZONE_BOTTOM)
		position.y = -m_cubeEdgeLimit;
	
	Leader.Position = position;
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

- (void)MannageBody
{
	float delta = GLKVector3Length(GLKVector3Subtract(m_preLeaderPosition, Leader.Position));
	[[Body lastObject] Grow:delta];
	
	
	CLBody* first = [Body firstObject];
	
	if(m_eating)
	{
		m_stepGrown += delta;
		
		if(m_stepGrown >= m_toGrow)
		{
			[first Grow:-(m_stepGrown - m_toGrow)];
			m_eating = false;
			m_stepGrown = 0.0f;
			m_toGrow = 0.0f;
		}
	}
	else
	{
		delta = [first Grow:-delta];
		
		if(delta <= 0.0f)
		{
			[m_renderBox ReleaseModel:first.Model];
			[Scene ReleaseModel:first.Model];
			[Body removeObjectAtIndex:0];
			[[Body firstObject] Grow:delta];
		}
	}
	
	m_preLeaderPosition = Leader.Position;
}

- (void)SwitchZoneColor:(enum CL_ZONE)prezone NewZone:(enum CL_ZONE)newzone
{
	if(prezone == CL_ZONE_FRONT)
		FrontWall.Color = GLKVector3Make(0.3f, 0.35f, 0.4f);
	if(prezone == CL_ZONE_BACK)
		BackWall.Color = GLKVector3Make(0.3f, 0.35f, 0.4f);
	if(prezone == CL_ZONE_RIGHT)
		RightWall.Color = GLKVector3Make(0.3f, 0.35f, 0.4f);
	if(prezone == CL_ZONE_LEFT)
		LeftWall.Color = GLKVector3Make(0.3f, 0.35f, 0.4f);
	if(prezone == CL_ZONE_TOP)
		TopWall.Color = GLKVector3Make(0.3f, 0.35f, 0.4f);
	if(prezone == CL_ZONE_BOTTOM)
		BottomWall.Color = GLKVector3Make(0.3f, 0.35f, 0.4f);
	
	if(newzone == CL_ZONE_FRONT)
		FrontWall.Color = GLKVector3Make(0.25f, 1.0f, 0.95f);
	if(newzone == CL_ZONE_BACK)
		BackWall.Color = GLKVector3Make(0.89f, 0.22f, 1.0f);
	if(newzone == CL_ZONE_RIGHT)
		RightWall.Color = GLKVector3Make(0.95f, 1.0f, 0.05f);
	if(newzone == CL_ZONE_LEFT)
		LeftWall.Color = GLKVector3Make(0.43f, 1.0f, 0.2f);
	if(newzone == CL_ZONE_TOP)
		TopWall.Color = GLKVector3Make(1.0f, 0.25f, 0.16f);
	if(newzone == CL_ZONE_BOTTOM)
		BottomWall.Color = GLKVector3Make(0.2f, 0.2f, 0.2f);
}

- (void)MannageZones
{
	GLKVector3 leaderPosition = Leader.Position;
	if(Zone == CL_ZONE_FRONT)
	{
		if(leaderPosition.x <= m_cubeEdgeLogicalLimit && leaderPosition.x >= -m_cubeEdgeLogicalLimit && leaderPosition.y <= m_cubeEdgeLogicalLimit && leaderPosition.y >= -m_cubeEdgeLogicalLimit)
		{
			m_noZone = false;
			m_noZoneFase = false;
			return;
		}
		m_noZone = true;
		if(leaderPosition.x == m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_RIGHT;
			Direction = CL_ZONE_BACK;
			if(ZoneUp == CL_ZONE_RIGHT)
			{
				ZoneUp = CL_ZONE_BACK;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			if(ZoneUp == CL_ZONE_LEFT)
			{
				ZoneUp = CL_ZONE_FRONT;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			leaderPosition.z = -m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_FRONT NewZone:CL_ZONE_RIGHT];
			
			return;
		}
		if(leaderPosition.x == -m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_LEFT;
			Direction = CL_ZONE_BACK;
			if(ZoneUp == CL_ZONE_RIGHT)
			{
				ZoneUp = CL_ZONE_FRONT;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			if(ZoneUp == CL_ZONE_LEFT)
			{
				ZoneUp = CL_ZONE_BACK;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			leaderPosition.z = -m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(-m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_FRONT NewZone:CL_ZONE_LEFT];
			
			return;
		}
		if(leaderPosition.y == m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_TOP;
			Direction = CL_ZONE_BACK;
			if(ZoneUp == CL_ZONE_TOP)
			{
				ZoneUp = CL_ZONE_BACK;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			if(ZoneUp == CL_ZONE_BOTTOM)
			{
				ZoneUp = CL_ZONE_FRONT;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			leaderPosition.z = -m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_FRONT NewZone:CL_ZONE_TOP];
			
			return;
		}
		if(leaderPosition.y == -m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_BOTTOM;
			Direction = CL_ZONE_BACK;
			if(ZoneUp == CL_ZONE_TOP)
			{
				ZoneUp = CL_ZONE_FRONT;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			if(ZoneUp == CL_ZONE_BOTTOM)
			{
				ZoneUp = CL_ZONE_BACK;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			leaderPosition.z = -m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, -m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_FRONT NewZone:CL_ZONE_BOTTOM];
			
			return;
		}
	}
	if(Zone == CL_ZONE_BACK)
	{
		if(leaderPosition.x <= m_cubeEdgeLogicalLimit && leaderPosition.x >= -m_cubeEdgeLogicalLimit && leaderPosition.y <= m_cubeEdgeLogicalLimit && leaderPosition.y >= -m_cubeEdgeLogicalLimit)
		{
			m_noZone = false;
			m_noZoneFase = false;
			return;
		}
		m_noZone = true;
		if(leaderPosition.x == -m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_LEFT;
			Direction = CL_ZONE_FRONT;
			if(ZoneUp == CL_ZONE_RIGHT)
			{
				ZoneUp = CL_ZONE_BACK;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			if(ZoneUp == CL_ZONE_LEFT)
			{
				ZoneUp = CL_ZONE_FRONT;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			leaderPosition.z = m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(-m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BACK NewZone:CL_ZONE_LEFT];
			
			return;
		}
		if(leaderPosition.x == m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_RIGHT;
			Direction = CL_ZONE_FRONT;
			if(ZoneUp == CL_ZONE_RIGHT)
			{
				ZoneUp = CL_ZONE_FRONT;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			if(ZoneUp == CL_ZONE_LEFT)
			{
				ZoneUp = CL_ZONE_BACK;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			leaderPosition.z = m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BACK NewZone:CL_ZONE_RIGHT];
			
			return;
		}
		if(leaderPosition.y == m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_TOP;
			Direction = CL_ZONE_FRONT;
			if(ZoneUp == CL_ZONE_TOP)
			{
				ZoneUp = CL_ZONE_FRONT;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			if(ZoneUp == CL_ZONE_BOTTOM)
			{
				ZoneUp = CL_ZONE_BACK;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			leaderPosition.z = m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BACK NewZone:CL_ZONE_TOP];
			
			return;
		}
		if(leaderPosition.y == -m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_BOTTOM;
			Direction = CL_ZONE_FRONT;
			if(ZoneUp == CL_ZONE_TOP)
			{
				ZoneUp = CL_ZONE_BACK;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			if(ZoneUp == CL_ZONE_BOTTOM)
			{
				ZoneUp = CL_ZONE_FRONT;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			leaderPosition.z = m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, -m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BACK NewZone:CL_ZONE_BOTTOM];
			
			return;
		}
	}
	if(Zone == CL_ZONE_RIGHT)
	{
		if(leaderPosition.z <= m_cubeEdgeLogicalLimit && leaderPosition.z >= -m_cubeEdgeLogicalLimit && leaderPosition.y <= m_cubeEdgeLogicalLimit && leaderPosition.y >= -m_cubeEdgeLogicalLimit)
		{
			m_noZone = false;
			m_noZoneFase = false;
			return;
		}
		m_noZone = true;
		if(leaderPosition.z == -m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_BACK;
			Direction = CL_ZONE_LEFT;
			if(ZoneUp == CL_ZONE_FRONT)
			{
				ZoneUp = CL_ZONE_RIGHT;
				FocusedCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_BACK)
			{
				ZoneUp = CL_ZONE_LEFT;
				FocusedCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = -m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, -m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_RIGHT NewZone:CL_ZONE_BACK];
			
			return;
		}
		if(leaderPosition.z == m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_FRONT;
			Direction = CL_ZONE_LEFT;
			if(ZoneUp == CL_ZONE_FRONT)
			{
				ZoneUp = CL_ZONE_LEFT;
				FocusedCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_BACK)
			{
				ZoneUp = CL_ZONE_RIGHT;
				FocusedCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = -m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_RIGHT NewZone:CL_ZONE_FRONT];
			
			return;
		}
		if(leaderPosition.y == m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_TOP;
			Direction = CL_ZONE_LEFT;
			if(ZoneUp == CL_ZONE_TOP)
			{
				ZoneUp = CL_ZONE_LEFT;
				FocusedCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_BOTTOM)
			{
				ZoneUp = CL_ZONE_RIGHT;
				FocusedCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = -m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_RIGHT NewZone:CL_ZONE_TOP];
			
			return;
		}
		if(leaderPosition.y == -m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_BOTTOM;
			Direction = CL_ZONE_LEFT;
			if(ZoneUp == CL_ZONE_TOP)
			{
				ZoneUp = CL_ZONE_RIGHT;
				FocusedCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_BOTTOM)
			{
				ZoneUp = CL_ZONE_LEFT;
				FocusedCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = -m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, -m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_RIGHT NewZone:CL_ZONE_BOTTOM];
			
			return;
		}
	}
	if(Zone == CL_ZONE_LEFT)
	{
		if(leaderPosition.z <= m_cubeEdgeLogicalLimit && leaderPosition.z >= -m_cubeEdgeLogicalLimit && leaderPosition.y <= m_cubeEdgeLogicalLimit && leaderPosition.y >= -m_cubeEdgeLogicalLimit)
		{
			m_noZone = false;
			m_noZoneFase = false;
			return;
		}
		m_noZone = true;
		if(leaderPosition.z == m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_FRONT;
			Direction = CL_ZONE_RIGHT;
			if(ZoneUp == CL_ZONE_FRONT)
			{
				ZoneUp = CL_ZONE_RIGHT;
				FocusedCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_BACK)
			{
				ZoneUp = CL_ZONE_LEFT;
				FocusedCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_LEFT NewZone:CL_ZONE_FRONT];
			
			return;
		}
		if(leaderPosition.z == -m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_BACK;
			Direction = CL_ZONE_RIGHT;
			if(ZoneUp == CL_ZONE_FRONT)
			{
				ZoneUp = CL_ZONE_LEFT;
				FocusedCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_BACK)
			{
				ZoneUp = CL_ZONE_RIGHT;
				FocusedCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, -m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_LEFT NewZone:CL_ZONE_BACK];
			
			return;
		}
		if(leaderPosition.y == m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_TOP;
			Direction = CL_ZONE_RIGHT;
			if(ZoneUp == CL_ZONE_TOP)
			{
				ZoneUp = CL_ZONE_RIGHT;
				FocusedCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_BOTTOM)
			{
				ZoneUp = CL_ZONE_LEFT;
				FocusedCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_LEFT NewZone:CL_ZONE_TOP];
			
			return;
		}
		if(leaderPosition.y == -m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_BOTTOM;
			Direction = CL_ZONE_RIGHT;
			if(ZoneUp == CL_ZONE_TOP)
			{
				ZoneUp = CL_ZONE_LEFT;
				FocusedCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_BOTTOM)
			{
				ZoneUp = CL_ZONE_RIGHT;
				FocusedCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, -m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_LEFT NewZone:CL_ZONE_BOTTOM];
			
			return;
		}
	}
	if(Zone == CL_ZONE_TOP)
	{
		if(leaderPosition.x <= m_cubeEdgeLogicalLimit && leaderPosition.x >= -m_cubeEdgeLogicalLimit && leaderPosition.z <= m_cubeEdgeLogicalLimit && leaderPosition.z >= -m_cubeEdgeLogicalLimit)
		{
			m_noZone = false;
			m_noZoneFase = false;
			return;
		}
		m_noZone = true;
		if(leaderPosition.z == m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_FRONT;
			Direction = CL_ZONE_BOTTOM;
			if(ZoneUp == CL_ZONE_FRONT)
			{
				ZoneUp = CL_ZONE_BOTTOM;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_BACK)
			{
				ZoneUp = CL_ZONE_TOP;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			leaderPosition.y = -m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_TOP NewZone:CL_ZONE_FRONT];
			
			return;
		}
		if(leaderPosition.z == -m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_BACK;
			Direction = CL_ZONE_BOTTOM;
			if(ZoneUp == CL_ZONE_FRONT)
			{
				ZoneUp = CL_ZONE_TOP;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_BACK)
			{
				ZoneUp = CL_ZONE_BOTTOM;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			leaderPosition.y = -m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, -m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_TOP NewZone:CL_ZONE_BACK];
			
			return;
		}
		if(leaderPosition.x == m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_RIGHT;
			Direction = CL_ZONE_BOTTOM;
			if(ZoneUp == CL_ZONE_LEFT)
			{
				ZoneUp = CL_ZONE_TOP;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_RIGHT)
			{
				ZoneUp = CL_ZONE_BOTTOM;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			leaderPosition.y = -m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_TOP NewZone:CL_ZONE_RIGHT];
			
			return;
		}
		if(leaderPosition.x == -m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_LEFT;
			Direction = CL_ZONE_BOTTOM;
			if(ZoneUp == CL_ZONE_RIGHT)
			{
				ZoneUp = CL_ZONE_TOP;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_LEFT)
			{
				ZoneUp = CL_ZONE_BOTTOM;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			leaderPosition.y = -m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(-m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_TOP NewZone:CL_ZONE_LEFT];
			
			return;
		}
	}
	if(Zone == CL_ZONE_BOTTOM)
	{
		if(leaderPosition.x <= m_cubeEdgeLogicalLimit && leaderPosition.x >= -m_cubeEdgeLogicalLimit && leaderPosition.z <= m_cubeEdgeLogicalLimit && leaderPosition.z >= -m_cubeEdgeLogicalLimit)
		{
			m_noZone = false;
			m_noZoneFase = false;
			return;
		}
		m_noZone = true;
		if(leaderPosition.z == m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_FRONT;
			Direction = CL_ZONE_TOP;
			if(ZoneUp == CL_ZONE_FRONT)
			{
				ZoneUp = CL_ZONE_TOP;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_BACK)
			{
				ZoneUp = CL_ZONE_BOTTOM;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			leaderPosition.y = m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BOTTOM NewZone:CL_ZONE_FRONT];
			
			return;
		}
		if(leaderPosition.z == -m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_BACK;
			Direction = CL_ZONE_TOP;
			if(ZoneUp == CL_ZONE_FRONT)
			{
				ZoneUp = CL_ZONE_BOTTOM;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_BACK)
			{
				ZoneUp = CL_ZONE_TOP;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			leaderPosition.y = m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, -m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BOTTOM NewZone:CL_ZONE_BACK];
			
			return;
		}
		if(leaderPosition.x == m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_RIGHT;
			Direction = CL_ZONE_TOP;
			if(ZoneUp == CL_ZONE_RIGHT)
			{
				ZoneUp = CL_ZONE_TOP;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_LEFT)
			{
				ZoneUp = CL_ZONE_BOTTOM;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			leaderPosition.y = m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BOTTOM NewZone:CL_ZONE_RIGHT];
			
			return;
		}
		if(leaderPosition.x == -m_cubeEdgeLimit)
		{
			Zone = CL_ZONE_LEFT;
			Direction = CL_ZONE_TOP;
			if(ZoneUp == CL_ZONE_RIGHT)
			{
				ZoneUp = CL_ZONE_BOTTOM;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			if(ZoneUp == CL_ZONE_LEFT)
			{
				ZoneUp = CL_ZONE_TOP;
				FocusedCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			leaderPosition.y = m_cubeEdgeLimit;
			Leader.Position = leaderPosition;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(-m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BOTTOM NewZone:CL_ZONE_LEFT];
			
			return;
		}
	}
}

- (enum CL_ZONE)GetUpOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up
{
	return up;
}

- (enum CL_ZONE)GetDownOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up
{
	if(zone == CL_ZONE_FRONT || zone == CL_ZONE_BACK)
	{
		if(up == CL_ZONE_RIGHT)
			return CL_ZONE_LEFT;
		if(up == CL_ZONE_LEFT)
			return CL_ZONE_RIGHT;
		if(up == CL_ZONE_TOP)
			return CL_ZONE_BOTTOM;
		if(up == CL_ZONE_BOTTOM)
			return CL_ZONE_TOP;
	}
	if(zone == CL_ZONE_RIGHT || zone == CL_ZONE_LEFT)
	{
		if(up == CL_ZONE_FRONT)
			return CL_ZONE_BACK;
		if(up == CL_ZONE_BACK)
			return CL_ZONE_FRONT;
		if(up == CL_ZONE_TOP)
			return CL_ZONE_BOTTOM;
		if(up == CL_ZONE_BOTTOM)
			return CL_ZONE_TOP;
	}
	if(zone == CL_ZONE_TOP || zone == CL_ZONE_BOTTOM)
	{
		if(up == CL_ZONE_FRONT)
			return CL_ZONE_BACK;
		if(up == CL_ZONE_BACK)
			return CL_ZONE_FRONT;
		if(up == CL_ZONE_RIGHT)
			return CL_ZONE_LEFT;
		if(up == CL_ZONE_LEFT)
			return CL_ZONE_RIGHT;
	}
	return 0;
}

- (enum CL_ZONE)GetRightOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up
{
	if(zone == CL_ZONE_FRONT)
	{
		if(up == CL_ZONE_RIGHT)
			return CL_ZONE_BOTTOM;
		if(up == CL_ZONE_LEFT)
			return CL_ZONE_TOP;
		if(up == CL_ZONE_TOP)
			return CL_ZONE_RIGHT;
		if(up == CL_ZONE_BOTTOM)
			return CL_ZONE_LEFT;
	}
	if(zone == CL_ZONE_BACK)
	{
		if(up == CL_ZONE_RIGHT)
			return CL_ZONE_TOP;
		if(up == CL_ZONE_LEFT)
			return CL_ZONE_BOTTOM;
		if(up == CL_ZONE_TOP)
			return CL_ZONE_LEFT;
		if(up == CL_ZONE_BOTTOM)
			return CL_ZONE_RIGHT;
	}
	if(zone == CL_ZONE_RIGHT)
	{
		if(up == CL_ZONE_FRONT)
			return CL_ZONE_TOP;
		if(up == CL_ZONE_BACK)
			return CL_ZONE_BOTTOM;
		if(up == CL_ZONE_TOP)
			return CL_ZONE_BACK;
		if(up == CL_ZONE_BOTTOM)
			return CL_ZONE_FRONT;
	}
	if(zone == CL_ZONE_LEFT)
	{
		if(up == CL_ZONE_FRONT)
			return CL_ZONE_BOTTOM;
		if(up == CL_ZONE_BACK)
			return CL_ZONE_TOP;
		if(up == CL_ZONE_TOP)
			return CL_ZONE_FRONT;
		if(up == CL_ZONE_BOTTOM)
			return CL_ZONE_BACK;
	}
	if(zone == CL_ZONE_TOP)
	{
		if(up == CL_ZONE_FRONT)
			return CL_ZONE_LEFT;
		if(up == CL_ZONE_BACK)
			return CL_ZONE_RIGHT;
		if(up == CL_ZONE_RIGHT)
			return CL_ZONE_FRONT;
		if(up == CL_ZONE_LEFT)
			return CL_ZONE_BACK;
	}
	if(zone == CL_ZONE_BOTTOM)
	{
		if(up == CL_ZONE_FRONT)
			return CL_ZONE_RIGHT;
		if(up == CL_ZONE_BACK)
			return CL_ZONE_LEFT;
		if(up == CL_ZONE_RIGHT)
			return CL_ZONE_BACK;
		if(up == CL_ZONE_LEFT)
			return CL_ZONE_FRONT;
	}
	return 0;
}

- (enum CL_ZONE)GetLeftOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up
{
	if(zone == CL_ZONE_FRONT)
	{
		if(up == CL_ZONE_RIGHT)
			return CL_ZONE_TOP;
		if(up == CL_ZONE_LEFT)
			return CL_ZONE_BOTTOM;
		if(up == CL_ZONE_TOP)
			return CL_ZONE_LEFT;
		if(up == CL_ZONE_BOTTOM)
			return CL_ZONE_RIGHT;
	}
	if(zone == CL_ZONE_BACK)
	{
		if(up == CL_ZONE_RIGHT)
			return CL_ZONE_BOTTOM;
		if(up == CL_ZONE_LEFT)
			return CL_ZONE_TOP;
		if(up == CL_ZONE_TOP)
			return CL_ZONE_RIGHT;
		if(up == CL_ZONE_BOTTOM)
			return CL_ZONE_LEFT;
	}
	if(zone == CL_ZONE_RIGHT)
	{
		if(up == CL_ZONE_FRONT)
			return CL_ZONE_BOTTOM;
		if(up == CL_ZONE_BACK)
			return CL_ZONE_TOP;
		if(up == CL_ZONE_TOP)
			return CL_ZONE_FRONT;
		if(up == CL_ZONE_BOTTOM)
			return CL_ZONE_BACK;
	}
	if(zone == CL_ZONE_LEFT)
	{
		if(up == CL_ZONE_FRONT)
			return CL_ZONE_TOP;
		if(up == CL_ZONE_BACK)
			return CL_ZONE_BOTTOM;
		if(up == CL_ZONE_TOP)
			return CL_ZONE_BACK;
		if(up == CL_ZONE_BOTTOM)
			return CL_ZONE_FRONT;
	}
	if(zone == CL_ZONE_TOP)
	{
		if(up == CL_ZONE_FRONT)
			return CL_ZONE_RIGHT;
		if(up == CL_ZONE_BACK)
			return CL_ZONE_LEFT;
		if(up == CL_ZONE_RIGHT)
			return CL_ZONE_BACK;
		if(up == CL_ZONE_LEFT)
			return CL_ZONE_FRONT;
	}
	if(zone == CL_ZONE_BOTTOM)
	{
		if(up == CL_ZONE_FRONT)
			return CL_ZONE_LEFT;
		if(up == CL_ZONE_BACK)
			return CL_ZONE_RIGHT;
		if(up == CL_ZONE_RIGHT)
			return CL_ZONE_FRONT;
		if(up == CL_ZONE_LEFT)
			return CL_ZONE_BACK;
	}
	return 0;
}

- (enum CL_HANDLE)GetHandleForDirection:(enum CL_ZONE)direction
{
	if(direction == CL_ZONE_FRONT) return CL_HANDLE_FRONT;
	if(direction == CL_ZONE_BACK) return CL_HANDLE_BACK;
	if(direction == CL_ZONE_RIGHT) return CL_HANDLE_RIGHT;
	if(direction == CL_ZONE_LEFT) return CL_HANDLE_LEFT;
	if(direction == CL_ZONE_TOP) return CL_HANDLE_TOP;
	if(direction == CL_ZONE_BOTTOM) return CL_HANDLE_BOTTOM;
	return 0;
}

- (enum CL_HANDLE)GetComplexHandleForDirection:(enum CL_ZONE)direction SecundaryDirection:(enum CL_ZONE)secundarydirection
{
	if(direction == CL_ZONE_FRONT)
	{
		if(secundarydirection == CL_ZONE_RIGHT)
			return CL_HANDLE_FRONT_RIGHT;
		if(secundarydirection == CL_ZONE_LEFT)
			return CL_HANDLE_FRONT_LEFT;
		if(secundarydirection == CL_ZONE_TOP)
			return CL_HANDLE_FRONT_TOP;
		if(secundarydirection == CL_ZONE_BOTTOM)
			return CL_HANDLE_FRONT_BOTTOM;
	}
	if(direction == CL_ZONE_BACK)
	{
		if(secundarydirection == CL_ZONE_RIGHT)
			return CL_HANDLE_BACK_RIGHT;
		if(secundarydirection == CL_ZONE_LEFT)
			return CL_HANDLE_BACK_LEFT;
		if(secundarydirection == CL_ZONE_TOP)
			return CL_HANDLE_BACK_TOP;
		if(secundarydirection == CL_ZONE_BOTTOM)
			return CL_HANDLE_BACK_BOTTOM;
	}
	if(direction == CL_ZONE_RIGHT)
	{
		if(secundarydirection == CL_ZONE_FRONT)
			return CL_HANDLE_RIGHT_FRONT;
		if(secundarydirection == CL_ZONE_BACK)
			return CL_HANDLE_RIGHT_BACK;
		if(secundarydirection == CL_ZONE_TOP)
			return CL_HANDLE_RIGHT_TOP;
		if(secundarydirection == CL_ZONE_BOTTOM)
			return CL_HANDLE_RIGHT_BOTTOM;
	}
	if(direction == CL_ZONE_LEFT)
	{
		if(secundarydirection == CL_ZONE_FRONT)
			return CL_HANDLE_LEFT_FRONT;
		if(secundarydirection == CL_ZONE_BACK)
			return CL_HANDLE_LEFT_BACK;
		if(secundarydirection == CL_ZONE_TOP)
			return CL_HANDLE_LEFT_TOP;
		if(secundarydirection == CL_ZONE_BOTTOM)
			return CL_HANDLE_LEFT_BOTTOM;
	}
	if(direction == CL_ZONE_TOP)
	{
		if(secundarydirection == CL_ZONE_FRONT)
			return CL_HANDLE_TOP_FRONT;
		if(secundarydirection == CL_ZONE_BACK)
			return CL_HANDLE_TOP_BACK;
		if(secundarydirection == CL_ZONE_RIGHT)
			return CL_HANDLE_TOP_RIGHT;
		if(secundarydirection == CL_ZONE_LEFT)
			return CL_HANDLE_TOP_LEFT;
	}
	if(direction == CL_ZONE_BOTTOM)
	{
		if(secundarydirection == CL_ZONE_FRONT)
			return CL_HANDLE_BOTTOM_FRONT;
		if(secundarydirection == CL_ZONE_BACK)
			return CL_HANDLE_BOTTOM_BACK;
		if(secundarydirection == CL_ZONE_RIGHT)
			return CL_HANDLE_BOTTOM_RIGHT;
		if(secundarydirection == CL_ZONE_LEFT)
			return CL_HANDLE_BOTTOM_LEFT;
	}
	return 0;
}

- (void)doTurn:(enum CL_TURN)turn
{
	if(turn == CL_TURN_UP_RIGHT)
		return [self TurnUpRight];
	if(turn == CL_TURN_UP_LEFT)
		return [self TurnUpLeft];
	if(turn == CL_TURN_DOWN_RIGHT)
		return [self TurnDownRight];
	if(turn == CL_TURN_DOWN_LEFT)
		return [self TurnDownLeft];
	if(turn == CL_TURN_RIGHT_UP)
		return [self TurnRightUp];
	if(turn == CL_TURN_RIGHT_DOWN)
		return [self TurnRightDown];
	if(turn == CL_TURN_LEFT_UP)
		return [self TurnLeftUp];
	if(turn == CL_TURN_LEFT_DOWN)
		return [self TurnLeftDown];
}

- (void)TurnUpRight
{
	if(m_noZone && !m_noZoneFase)
	{
		m_bufferTurn = CL_TURN_UP_RIGHT;
		return;
	}
	
	enum CL_ZONE up = [self GetUpOfZone:Zone Up:ZoneUp];
	if(Direction == up)return;
	
	enum CL_ZONE right = [self GetRightOfZone:Zone Up:ZoneUp];
	
	if(Direction == [self GetDownOfZone:Zone Up:ZoneUp])
		m_nextHandle = [self GetComplexHandleForDirection:up SecundaryDirection:right];
	else
		m_nextHandle = [self GetHandleForDirection:up];
}

- (void)TurnUpLeft
{
	if(m_noZone && !m_noZoneFase)
	{
		m_bufferTurn = CL_TURN_UP_LEFT;
		return;
	}
	
	enum CL_ZONE up = [self GetUpOfZone:Zone Up:ZoneUp];
	if(Direction == up)return;
	
	enum CL_ZONE left = [self GetLeftOfZone:Zone Up:ZoneUp];
	
	if(Direction == [self GetDownOfZone:Zone Up:ZoneUp])
		m_nextHandle = [self GetComplexHandleForDirection:up SecundaryDirection:left];
	else
		m_nextHandle = [self GetHandleForDirection:up];
}

- (void)TurnDownRight
{
	if(m_noZone && !m_noZoneFase)
	{
		m_bufferTurn = CL_TURN_DOWN_RIGHT;
		return;
	}
	
	enum CL_ZONE down = [self GetDownOfZone:Zone Up:ZoneUp];
	if(Direction == down)return;
	
	enum CL_ZONE right = [self GetRightOfZone:Zone Up:ZoneUp];
	
	if(Direction == [self GetUpOfZone:Zone Up:ZoneUp])
		m_nextHandle = [self GetComplexHandleForDirection:down SecundaryDirection:right];
	else
		m_nextHandle = [self GetHandleForDirection:down];
}

- (void)TurnDownLeft
{
	if(m_noZone && !m_noZoneFase)
	{
		m_bufferTurn = CL_TURN_DOWN_LEFT;
		return;
	}
	
	enum CL_ZONE down = [self GetDownOfZone:Zone Up:ZoneUp];
	if(Direction == down)return;
	
	enum CL_ZONE left = [self GetLeftOfZone:Zone Up:ZoneUp];
	
	if(Direction == [self GetUpOfZone:Zone Up:ZoneUp])
		m_nextHandle = [self GetComplexHandleForDirection:down SecundaryDirection:left];
	else
		m_nextHandle = [self GetHandleForDirection:down];
}

- (void)TurnRightUp
{
	if(m_noZone && !m_noZoneFase)
	{
		m_bufferTurn = CL_TURN_RIGHT_UP;
		return;
	}
	
	enum CL_ZONE right = [self GetRightOfZone:Zone Up:ZoneUp];
	if(Direction == right)return;
	
	enum CL_ZONE up = [self GetUpOfZone:Zone Up:ZoneUp];
	
	if(Direction == [self GetLeftOfZone:Zone Up:ZoneUp])
		m_nextHandle = [self GetComplexHandleForDirection:right SecundaryDirection:up];
	else
		m_nextHandle = [self GetHandleForDirection:right];
}

- (void)TurnRightDown
{
	if(m_noZone && !m_noZoneFase)
	{
		m_bufferTurn = CL_TURN_RIGHT_DOWN;
		return;
	}
	
	enum CL_ZONE right = [self GetRightOfZone:Zone Up:ZoneUp];
	if(Direction == right)return;
	
	enum CL_ZONE down = [self GetDownOfZone:Zone Up:ZoneUp];
	
	if(Direction == [self GetLeftOfZone:Zone Up:ZoneUp])
		m_nextHandle = [self GetComplexHandleForDirection:right SecundaryDirection:down];
	else
		m_nextHandle = [self GetHandleForDirection:right];
}

- (void)TurnLeftUp
{
	if(m_noZone && !m_noZoneFase)
	{
		m_bufferTurn = CL_TURN_LEFT_UP;
		return;
	}
	
	enum CL_ZONE left = [self GetLeftOfZone:Zone Up:ZoneUp];
	if(Direction == left)return;
	
	enum CL_ZONE up = [self GetUpOfZone:Zone Up:ZoneUp];
	
	if(Direction == [self GetRightOfZone:Zone Up:ZoneUp])
		m_nextHandle = [self GetComplexHandleForDirection:left SecundaryDirection:up];
	else
		m_nextHandle = [self GetHandleForDirection:left];
}

- (void)TurnLeftDown
{
	if(m_noZone && !m_noZoneFase)
	{
		m_bufferTurn = CL_TURN_LEFT_DOWN;
		return;
	}
	
	enum CL_ZONE left = [self GetLeftOfZone:Zone Up:ZoneUp];
	if(Direction == left)return;
	
	enum CL_ZONE down = [self GetDownOfZone:Zone Up:ZoneUp];
	
	if(Direction == [self GetRightOfZone:Zone Up:ZoneUp])
		m_nextHandle = [self GetComplexHandleForDirection:left SecundaryDirection:down];
	else
		m_nextHandle = [self GetHandleForDirection:left];
}

- (void)CreateLevel
{
	BodyColor = GLKVector3Make(0.9f, 0.95f, 1.0f);
	
	// Leader
	Leader = [m_renderBox NewModelFromFileName:@"quad"];
	Leader.PositionTransitionEffect = VE_TRANSITION_EFFECT_HARD;
	Leader.Color = BodyColor;
	Leader.PositionTransitionSpeed = 5.0f;
	
	// Ghost
	m_leaderGhost = [[VE3DObject alloc] init];
	m_leaderGhost.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	
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
		
		m_cubeEdgeLimit = 5.0f;
		m_cubeEdgeLogicalLimit = 4.0f;
		
		m_radious = SmallSizeLimit * 2.3f;
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
		
		m_cubeEdgeLimit = 8.0f;
		m_cubeEdgeLogicalLimit = 7.0f;
		
		m_radious = NormalSizeLimit * 2.3f;
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
		
		m_cubeEdgeLimit = 11.0f;
		m_cubeEdgeLogicalLimit = 10.0f;
		
		m_radious = BigSizeLimit * 2.3f;
	}
}

- (void)Reset
{
	[self ResetInZone:CL_ZONE_FRONT Up:CL_ZONE_TOP];
}

- (void)ResetInZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up
{
	Zone = zone;
	
	if(zone == CL_ZONE_FRONT)
	{
		[Leader ResetPosition:GLKVector3Make(0.0f, 0.0f, m_cubeEdgeLimit)];
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
		[Leader ResetPosition:GLKVector3Make(0.0f, 0.0f, -m_cubeEdgeLimit)];
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
		[Leader ResetPosition:GLKVector3Make(m_cubeEdgeLimit, 0.0f, 0.0f)];
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
		[Leader ResetPosition:GLKVector3Make(-m_cubeEdgeLimit, 0.0f, 0.0f)];
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
		[Leader ResetPosition:GLKVector3Make(0.0f, m_cubeEdgeLimit, 0.0f)];
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
		[Leader ResetPosition:GLKVector3Make(0.0f, -m_cubeEdgeLimit, 0.0f)];
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

- (void)ChangeSpeed:(enum CL_SIZE)speed
{
	if(speed == CL_SIZE_SMALL)
	{
		Leader.PositionTransitionSpeed = 5.0f;
	}
	else if(speed == CL_SIZE_NORMAL)
	{
		Leader.PositionTransitionSpeed = 7.0f;
	}
	else if(speed == CL_SIZE_BIG)
	{
		Leader.PositionTransitionSpeed = 10.0f;
	}
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