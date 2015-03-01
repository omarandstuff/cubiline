#import "CLlevel.h"

@implementation Slot
@end

@interface CLLevel()
{
	VERenderBox* m_renderBox;
	VEModel* m_guides;
	
	// Line control
	GLKVector3 m_preLeaderPosition;
	bool m_toNew;
	bool m_playing;
	
	// Eating control
	bool m_eating;
	float m_stepGrown;
	float m_toGrow;
	
	// Edge control
	float m_cubeEdgeLimit;
	float m_cubeEdgeLogicalLimit;
	float m_cubeSideSize;
	int m_cubeFaceSlotLimit;
	bool m_noZone;
	bool m_noZoneFase;
	
	// Camera control
	float m_radious;

	// Turn control
	enum CL_TURN m_bufferTurn;
	bool m_justBuffered;
	enum CL_HANDLE m_nextHandle;
	enum CL_ZONE m_nextDirection;
	bool m_inComplex;
	GLKVector3 m_toTurnPosition;
	GLKVector3 m_nextDirectionPosition;
	bool m_toTurn;

	// Resizing control.
	bool m_resizing;
	
	// Collision control.
	NSMutableArray* m_slots;
	int m_leaderFaceX;
	int m_leaderFaceY;
	enum CL_ZONE m_leaderFaceZone;
	int m_slotControl;
	bool* m_facesMap[CL_ZONE_NUMBER];
	int m_occupied[CL_ZONE_NUMBER];
	
	// Feed control.
	VERandom* m_random;
	
	// Point Control
	unsigned int m_taken;
}


// Level initialization and reshape.
- (void)CreateLevel;
- (void)ResizeLevel:(enum CL_SIZE)size;
- (void)ChangeSpeed:(enum CL_SIZE)speed;
- (void)ManageResizing;

// Line directives.
- (void)Play;
- (void)Stop;
- (void)AddBodyWithSize:(float)size;
- (void)MannageBody;
- (void)SwitchZoneColor:(enum CL_ZONE)prezone NewZone:(enum CL_ZONE)newzone;
- (void)MannageZones;

// Dance
- (void)ManageDance;

// Turn directives
- (void)ManageHandles;
- (void)ManageTurns;
- (enum CL_ZONE)GetUpOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;
- (enum CL_ZONE)GetDownOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;
- (enum CL_ZONE)GetRightOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;
- (enum CL_ZONE)GetLeftOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;
- (enum CL_HANDLE)GetHandleForDirection:(enum CL_ZONE)direction;
- (enum CL_HANDLE)GetComplexHandleForDirection:(enum CL_ZONE)direction SecundaryDirection:(enum CL_ZONE)secundarydirection;
- (void)TurnUpRight;
- (void)TurnUpLeft;
- (void)TurnDownRight;
- (void)TurnDownLeft;
- (void)TurnRightUp;
- (void)TurnRightDown;
- (void)TurnLeftUp;
- (void)TurnLeftDown;

// Collisions
- (void)ManageColloisions;
- (bool)CheckColition:(enum CL_ZONE)zone CoordX:(int)coordx CoordY:(int)coordy;
- (void)AddSlot:(enum CL_ZONE)zone CoordX:(int)coordx CoordY:(int)coordy Position:(GLKVector3)position InZone:(bool)inzone;
- (void)RemoveFirstSlot;

// Feed
- (void)MannageFood;
- (void)RandomFood;

// Camera
- (void)FocusLeaderInCamera;
- (void)FollowWithCamera;
- (GLKVector2)CameraRotationBase:(float)base Horizontal:(float)horizontal Vertical:(float)vertical;
- (void)ManageFollow;


- (void)PrintZone;
- (void)PrintDirection;
- (void)PrintUp;
- (void)PrintNextHandle;
- (void)PrintNextDirection;
- (void)PrintToTurnPosition;
- (void)PrintNextDirectionPosition;
- (void)PrintBuffer;

- (void)PrintLog;

@end

@implementation CLLevel

@synthesize Leader;
@synthesize LeaderGhost;
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
@synthesize Dance;
@synthesize Follow;
@synthesize Collide;
@synthesize Feed;
@synthesize Points;
@synthesize TotalEaten;
@synthesize Move;

- (void)PrintZone
{
	if(Zone == CL_ZONE_FRONT)
		NSLog(@"Zone: Front");
	if(Zone == CL_ZONE_BACK)
		NSLog(@"Zone: Back");
	if(Zone == CL_ZONE_RIGHT)
		NSLog(@"Zone: Right");
	if(Zone == CL_ZONE_LEFT)
		NSLog(@"Zone: Left");
	if(Zone == CL_ZONE_TOP)
		NSLog(@"Zone: Top");
	if(Zone == CL_ZONE_BOTTOM)
		NSLog(@"Zone: Bottom");
}

- (void)PrintDirection
{
	if(Direction == CL_ZONE_FRONT)
		NSLog(@"Direction: Front");
	if(Direction == CL_ZONE_BACK)
		NSLog(@"Direction: Back");
	if(Direction == CL_ZONE_RIGHT)
		NSLog(@"Direction: Right");
	if(Direction == CL_ZONE_LEFT)
		NSLog(@"Direction: Left");
	if(Direction == CL_ZONE_TOP)
		NSLog(@"Direction: Top");
	if(Direction == CL_ZONE_BOTTOM)
		NSLog(@"Direction: Bottom");
}

- (void)PrintNextDirection
{
	if(m_nextDirection == CL_ZONE_FRONT)
		NSLog(@"Direction: Front");
	if(m_nextDirection == CL_ZONE_BACK)
		NSLog(@"Direction: Back");
	if(m_nextDirection == CL_ZONE_RIGHT)
		NSLog(@"Direction: Right");
	if(m_nextDirection == CL_ZONE_LEFT)
		NSLog(@"Direction: Left");
	if(m_nextDirection == CL_ZONE_TOP)
		NSLog(@"Direction: Top");
	if(m_nextDirection == CL_ZONE_BOTTOM)
		NSLog(@"Direction: Bottom");
}

- (void)PrintUp
{
	if(ZoneUp == CL_ZONE_FRONT)
		NSLog(@"ZoneUp: Front");
	if(ZoneUp == CL_ZONE_BACK)
		NSLog(@"ZoneUp: Back");
	if(ZoneUp == CL_ZONE_RIGHT)
		NSLog(@"ZoneUp: Right");
	if(ZoneUp == CL_ZONE_LEFT)
		NSLog(@"ZoneUp: Left");
	if(ZoneUp == CL_ZONE_TOP)
		NSLog(@"ZoneUp: Top");
	if(ZoneUp == CL_ZONE_BOTTOM)
		NSLog(@"ZoneUp: Bottom");
}

- (void)PrintNextHandle
{
	if(m_nextHandle == CL_HANDLE_FRONT)
		NSLog(@"NextHandle: Front");
	if(m_nextHandle == CL_HANDLE_FRONT_RIGHT)
		NSLog(@"NextHandle: Front Right");
	if(m_nextHandle == CL_HANDLE_FRONT_LEFT)
		NSLog(@"NextHandle: Front Left");
	if(m_nextHandle == CL_HANDLE_FRONT_TOP)
		NSLog(@"NextHandle: Front Top");
	if(m_nextHandle == CL_HANDLE_FRONT_BOTTOM)
		NSLog(@"NextHandle: Front Bottom");
	
	if(m_nextHandle == CL_HANDLE_BACK)
		NSLog(@"NextHandle: Back");
	if(m_nextHandle == CL_HANDLE_BACK_RIGHT)
		NSLog(@"NextHandle: Back Right");
	if(m_nextHandle == CL_HANDLE_BACK_LEFT)
		NSLog(@"NextHandle: Back Left");
	if(m_nextHandle == CL_HANDLE_BACK_TOP)
		NSLog(@"NextHandle: Back Top");
	if(m_nextHandle == CL_HANDLE_BACK_BOTTOM)
		NSLog(@"NextHandle: Back Bottom");
	
	if(m_nextHandle == CL_HANDLE_RIGHT)
		NSLog(@"NextHandle: Right");
	if(m_nextHandle == CL_HANDLE_RIGHT_FRONT)
		NSLog(@"NextHandle: Right Front");
	if(m_nextHandle == CL_HANDLE_RIGHT_BACK)
		NSLog(@"NextHandle: Right Back");
	if(m_nextHandle == CL_HANDLE_RIGHT_TOP)
		NSLog(@"NextHandle: Right Top");
	if(m_nextHandle == CL_HANDLE_RIGHT_BOTTOM)
		NSLog(@"NextHandle: Right Bottom");
	
	if(m_nextHandle == CL_HANDLE_LEFT)
		NSLog(@"NextHandle: Left");
	if(m_nextHandle == CL_HANDLE_LEFT_FRONT)
		NSLog(@"NextHandle: Left Front");
	if(m_nextHandle == CL_HANDLE_LEFT_BACK)
		NSLog(@"NextHandle: Left Back");
	if(m_nextHandle == CL_HANDLE_LEFT_TOP)
		NSLog(@"NextHandle: Left Top");
	if(m_nextHandle == CL_HANDLE_LEFT_BOTTOM)
		NSLog(@"NextHandle: Left Bottom");
	
	if(m_nextHandle == CL_HANDLE_TOP)
		NSLog(@"NextHandle: Top");
	if(m_nextHandle == CL_HANDLE_TOP_FRONT)
		NSLog(@"NextHandle: Top Front");
	if(m_nextHandle == CL_HANDLE_TOP_BACK)
		NSLog(@"NextHandle: Top Back");
	if(m_nextHandle == CL_HANDLE_TOP_RIGHT)
		NSLog(@"NextHandle: Top Right");
	if(m_nextHandle == CL_HANDLE_TOP_LEFT)
		NSLog(@"NextHandle: Top Left");
	
	if(m_nextHandle == CL_HANDLE_BOTTOM)
		NSLog(@"NextHandle: Bottom");
	if(m_nextHandle == CL_HANDLE_BOTTOM_FRONT)
		NSLog(@"NextHandle: Bottom Front");
	if(m_nextHandle == CL_HANDLE_BOTTOM_BACK)
		NSLog(@"NextHandle: Bottom Back");
	if(m_nextHandle == CL_HANDLE_BOTTOM_RIGHT)
		NSLog(@"NextHandle: Bottom Right");
	if(m_nextHandle == CL_HANDLE_BOTTOM_LEFT)
		NSLog(@"NextHandle: Bottom Left");
}
- (void)PrintToTurnPosition
{
	NSLog(@"ToTurnPosition: (%f, %f, %f)", m_toTurnPosition.x, m_toTurnPosition.y, m_toTurnPosition.z);
}

- (void)PrintNextDirectionPosition
{
	NSLog(@"NextDirectionPosition: (%f, %f, %f)", m_nextDirectionPosition.x, m_nextDirectionPosition.y, m_nextDirectionPosition.z);
}

- (void)PrintBuffer
{
	if(m_bufferTurn == CL_TURN_UP_RIGHT)
		NSLog(@"TurnBuffered: Up Right");
	if(m_bufferTurn == CL_TURN_UP_LEFT)
		NSLog(@"TurnBuffered: Up Left");
	if(m_bufferTurn == CL_TURN_DOWN_RIGHT)
		NSLog(@"TurnBuffered: Down Right");
	if(m_bufferTurn == CL_TURN_DOWN_LEFT)
		NSLog(@"TurnBuffered: Down Left");
	if(m_bufferTurn == CL_TURN_RIGHT_UP)
		NSLog(@"TurnBuffered: Right Up");
	if(m_bufferTurn == CL_TURN_RIGHT_DOWN)
		NSLog(@"TurnBuffered: Right Down");
	if(m_bufferTurn == CL_TURN_LEFT_UP)
		NSLog(@"TurnBuffered: Left Up");
	if(m_bufferTurn == CL_TURN_LEFT_DOWN)
		NSLog(@"TurnBuffered: Left Down");
}

- (void)PrintLog
{
	//[self PrintZone];
	//[self PrintDirection];
	//[self PrintUp];
	//[self PrintNextHandle];
	//[self PrintNextDirection];
	//[self PrintToTurnPosition];
	//[self PrintNextDirectionPosition];
	//[self PrintBuffer];
}

- (id)initWithRenderBox:(VERenderBox *)renderbox
{
	self = [super init];
	
	if(self)
	{
		m_renderBox = renderbox;
		
		_Size = 456;
		ZoneUp = CL_ZONE_TOP;
		
		[self CreateLevel];
		[self Reset];
	}
	
	return self;
}

- (void)Frame:(float)time
{
	[LeaderGhost Frame:time];
	
	if(m_playing)
	{
		[self MannageZones];
		[self ManageHandles];
		[self ManageTurns];
		
		if(!m_toNew)
			[self MannageBody];
		m_toNew = false;
		
		[self ManageFollow];
		
		if(Feed)
			[self MannageFood];
		
		if(Collide)
			[self ManageColloisions];
	}
	else
	{
		if(FrontWall.Scale.x >= SmallSizeLimit)
			[self Play];
	}
	
	if(m_resizing)
		[self ManageResizing];
	
	if(Dance)
		[self ManageDance];
}

- (void)Play
{
	if(!Move)
	{
		[self Stop];
		return;
	}
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
	
	m_playing = true;
}

- (void)Stop
{
	[Leader ResetPosition:Leader.Position];
}

- (void)FocusLeaderInCamera
{
	float focusDistance = GLKVector3Length(GLKVector3Subtract(Leader.Position, FocusedCamera.Position));
	FocusedCamera.FocusDistance = focusDistance;
}

- (void)FollowWithCamera
{
	GLKVector3 leaderGhostPosition = LeaderGhost.Position;
	GLKVector2 newRotations;
	if(Zone == CL_ZONE_FRONT)
	{
		newRotations = [self CameraRotationBase:leaderGhostPosition.z Horizontal:leaderGhostPosition.x Vertical:-leaderGhostPosition.y];
		FocusedCamera.PivotRotation = GLKVector3Make(newRotations.x, newRotations.y, 0.0f);
	}
	if(Zone == CL_ZONE_BACK)
	{
		newRotations = [self CameraRotationBase:leaderGhostPosition.z Horizontal:leaderGhostPosition.x Vertical:leaderGhostPosition.y];
		FocusedCamera.PivotRotation = GLKVector3Make(newRotations.x, newRotations.y, 0.0f);
	}
	if(Zone == CL_ZONE_RIGHT)
	{
		newRotations = [self CameraRotationBase:leaderGhostPosition.x Horizontal:leaderGhostPosition.y Vertical:-leaderGhostPosition.z];
		FocusedCamera.PivotRotation = GLKVector3Make(0.0f, newRotations.x, newRotations.y);
	}
	if(Zone == CL_ZONE_LEFT)
	{
		newRotations = [self CameraRotationBase:leaderGhostPosition.x Horizontal:leaderGhostPosition.y Vertical:leaderGhostPosition.z];
		FocusedCamera.PivotRotation = GLKVector3Make(0.0f, newRotations.x, newRotations.y);
	}
	if(Zone == CL_ZONE_TOP)
	{
		newRotations = [self CameraRotationBase:leaderGhostPosition.y Horizontal:-leaderGhostPosition.x Vertical:leaderGhostPosition.z];
		FocusedCamera.PivotRotation = GLKVector3Make(newRotations.x, 0.0f, newRotations.y);
	}
	if(Zone == CL_ZONE_BOTTOM)
	{
		newRotations = [self CameraRotationBase:leaderGhostPosition.y Horizontal:-leaderGhostPosition.x Vertical:-leaderGhostPosition.z];
		FocusedCamera.PivotRotation = GLKVector3Make(newRotations.x, 0.0f, newRotations.y);
	}
}

- (GLKVector2)CameraRotationBase:(float)base Horizontal:(float)horizontal Vertical:(float)vertical
{
	float anglexz;
	float spherey;
	
	anglexz = horizontal == 0.0f || base == 0.0f ? 0.0f : horizontal / base;
	
	// New value for the sphere y angle.
	spherey =  GLKMathRadiansToDegrees(atanf(anglexz));
	
	// New value for the sphere x angle.
	float auxhy = sqrtf(powf(horizontal, 2.0f) + powf(base, 2.0f));
	float xangle =  GLKMathRadiansToDegrees(atanf(vertical / auxhy));
	
	// Set the new pivot rotation base these angles.
	return GLKVector2Make(xangle, spherey);
}

- (void)ManageFollow
{
	if(Follow)
		LeaderGhost.Position = Leader.Position;
	else
	{
		if(Zone == CL_ZONE_FRONT)
		{
			if(ZoneUp == CL_ZONE_TOP)
				LeaderGhost.Position = GLKVector3Make(0.0f, -m_cubeEdgeLimit / 2.0f, m_cubeEdgeLimit);
		}
	}
	
	[self FollowWithCamera];
	[self FocusLeaderInCamera];
}

- (void)AddBodyWithSize:(float)size
{
	[Body addObject:[[CLBody alloc] initWithRenderBox:m_renderBox Scene:Scene Zone:Zone Direction:Direction BornPosition:Leader.Position Size:size Color:BodyColor]];
}

- (void)MannageBody
{
	if(m_resizing)
	{
		if(Zone == CL_ZONE_FRONT || Zone == CL_ZONE_BACK)
			m_preLeaderPosition.z = Leader.Position.z;
		else if(Zone == CL_ZONE_RIGHT || Zone == CL_ZONE_LEFT)
			m_preLeaderPosition.x = Leader.Position.x;
		else if(Zone == CL_ZONE_TOP || Zone == CL_ZONE_BOTTOM)
			m_preLeaderPosition.y = Leader.Position.y;
	}

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
		FrontWall.Color = SecundaryColor;
	if(prezone == CL_ZONE_BACK)
		BackWall.Color = SecundaryColor;
	if(prezone == CL_ZONE_RIGHT)
		RightWall.Color = SecundaryColor;
	if(prezone == CL_ZONE_LEFT)
		LeftWall.Color = SecundaryColor;
	if(prezone == CL_ZONE_TOP)
		TopWall.Color = SecundaryColor;
	if(prezone == CL_ZONE_BOTTOM)
		BottomWall.Color = SecundaryColor;
	
	if(newzone == CL_ZONE_FRONT)
		FrontWall.Color = FrontColor;
	if(newzone == CL_ZONE_BACK)
		BackWall.Color = BackColor;
	if(newzone == CL_ZONE_RIGHT)
		RightWall.Color = RightColor;
	if(newzone == CL_ZONE_LEFT)
		LeftWall.Color = LeftColor;
	if(newzone == CL_ZONE_TOP)
		TopWall.Color = TopColor;
	if(newzone == CL_ZONE_BOTTOM)
		BottomWall.Color = BottomColor;
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
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.x == -m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.y == m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
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
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.x == m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.y == m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.y == -m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
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
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.z == m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.y == m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.y == -m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
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
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.z == -m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.y == m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.y == -m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
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
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.z == -m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.x == m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.x == -m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
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
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.z == -m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.x == m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
		if(leaderPosition.x == -m_cubeEdgeLimit)
		{
			//NSLog(@"Pre Zone Change");
			[self PrintLog];
			
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
			
			//NSLog(@"Zone Changed");
			[self PrintLog];
			
			return;
		}
	}
}

- (void)ManageHandles
{
	if(m_nextHandle == CL_HANDLE_NONE || m_inComplex || (m_noZone && !m_noZoneFase)) return;
	if(m_justBuffered)
	{
		m_justBuffered = false;
		return;
	}
	
	m_toTurnPosition = Leader.Position;
	
	if(Direction == CL_ZONE_FRONT)
	{
		m_toTurnPosition.z += m_cubeEdgeLimit;
		m_toTurnPosition.z = (int)m_toTurnPosition.z + 1;
		m_toTurnPosition.z -= m_cubeEdgeLimit;
	}
	if(Direction == CL_ZONE_BACK)
	{
		m_toTurnPosition.z -= m_cubeEdgeLimit;
		m_toTurnPosition.z = (int)m_toTurnPosition.z - 1;
		m_toTurnPosition.z += m_cubeEdgeLimit;
	}
	if(Direction == CL_ZONE_RIGHT)
	{
		m_toTurnPosition.x += m_cubeEdgeLimit;
		m_toTurnPosition.x = (int)m_toTurnPosition.x + 1;
		m_toTurnPosition.x -= m_cubeEdgeLimit;
	}
	if(Direction == CL_ZONE_LEFT)
	{
		m_toTurnPosition.x -= m_cubeEdgeLimit;
		m_toTurnPosition.x = (int)m_toTurnPosition.x - 1;
		m_toTurnPosition.x += m_cubeEdgeLimit;
	}
	if(Direction == CL_ZONE_TOP)
	{
		m_toTurnPosition.y += m_cubeEdgeLimit;
		m_toTurnPosition.y = (int)m_toTurnPosition.y + 1;
		m_toTurnPosition.y -= m_cubeEdgeLimit;
	}
	if(Direction == CL_ZONE_BOTTOM)
	{
		m_toTurnPosition.y -= m_cubeEdgeLimit;
		m_toTurnPosition.y = (int)m_toTurnPosition.y - 1;
		m_toTurnPosition.y += m_cubeEdgeLimit;
	}
	
	m_toTurn = true;
	m_nextDirectionPosition = m_toTurnPosition;
	
	if(m_nextHandle == CL_HANDLE_FRONT)
	{
		m_nextDirectionPosition.z = m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_FRONT;
		
		m_nextHandle = CL_HANDLE_NONE;
		return;
	}
	if(m_nextHandle == CL_HANDLE_BACK)
	{
		m_nextDirectionPosition.z = -m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_BACK;
		
		m_nextHandle = CL_HANDLE_NONE;
		return;
	}
	if(m_nextHandle == CL_HANDLE_RIGHT)
	{
		m_nextDirectionPosition.x = m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_RIGHT;
		
		m_nextHandle = CL_HANDLE_NONE;
		return;
	}
	if(m_nextHandle == CL_HANDLE_LEFT)
	{
		m_nextDirectionPosition.x = -m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_LEFT;
		
		m_nextHandle = CL_HANDLE_NONE;
		return;
	}
	if(m_nextHandle == CL_HANDLE_TOP)
	{
		m_nextDirectionPosition.y = m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_TOP;
		
		m_nextHandle = CL_HANDLE_NONE;
		return;
	}
	if(m_nextHandle == CL_HANDLE_BOTTOM)
	{
		m_nextDirectionPosition.y = -m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_BOTTOM;
		
		m_nextHandle = CL_HANDLE_NONE;
		return;
	}
	
	if(m_nextHandle == CL_HANDLE_FRONT_RIGHT || m_nextHandle == CL_HANDLE_BACK_RIGHT)
	{
		m_nextDirectionPosition.x = m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_RIGHT;
		
		if(m_nextHandle == CL_HANDLE_FRONT_RIGHT)
			m_nextHandle = CL_HANDLE_FRONT;
		
		if(m_nextHandle == CL_HANDLE_BACK_RIGHT)
			m_nextHandle = CL_HANDLE_BACK;
		
		m_inComplex = true;
		return;
	}
	if(m_nextHandle == CL_HANDLE_FRONT_LEFT || m_nextHandle == CL_HANDLE_BACK_LEFT)
	{
		m_nextDirectionPosition.x = -m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_LEFT;
		
		if(m_nextHandle == CL_HANDLE_FRONT_LEFT)
			m_nextHandle = CL_HANDLE_FRONT;
		
		if(m_nextHandle == CL_HANDLE_BACK_LEFT)
			m_nextHandle = CL_HANDLE_BACK;
		
		m_inComplex = true;
		return;
	}
	if(m_nextHandle == CL_HANDLE_FRONT_TOP || m_nextHandle == CL_HANDLE_BACK_TOP)
	{
		m_nextDirectionPosition.y = m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_TOP;
		
		if(m_nextHandle == CL_HANDLE_FRONT_TOP)
			m_nextHandle = CL_HANDLE_FRONT;
		
		if(m_nextHandle == CL_HANDLE_BACK_TOP)
			m_nextHandle = CL_HANDLE_BACK;
		
		m_inComplex = true;
		return;
	}
	if(m_nextHandle == CL_HANDLE_FRONT_BOTTOM || m_nextHandle == CL_HANDLE_BACK_BOTTOM)
	{
		m_nextDirectionPosition.y = -m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_BOTTOM;
		
		if(m_nextHandle == CL_HANDLE_FRONT_BOTTOM)
			m_nextHandle = CL_HANDLE_FRONT;
		
		if(m_nextHandle == CL_HANDLE_BACK_BOTTOM)
			m_nextHandle = CL_HANDLE_BACK;
		
		m_inComplex = true;
		return;
	}
	
	if(m_nextHandle == CL_HANDLE_RIGHT_FRONT || m_nextHandle == CL_HANDLE_LEFT_FRONT)
	{
		m_nextDirectionPosition.z = m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_FRONT;
		
		if(m_nextHandle == CL_HANDLE_RIGHT_FRONT)
			m_nextHandle = CL_HANDLE_RIGHT;
		
		if(m_nextHandle == CL_HANDLE_LEFT_FRONT)
			m_nextHandle = CL_HANDLE_LEFT;
		
		m_inComplex = true;
		return;
	}
	if(m_nextHandle == CL_HANDLE_RIGHT_BACK || m_nextHandle == CL_HANDLE_LEFT_BACK)
	{
		m_nextDirectionPosition.z = -m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_BACK;
		
		if(m_nextHandle == CL_HANDLE_RIGHT_BACK)
			m_nextHandle = CL_HANDLE_RIGHT;
		
		if(m_nextHandle == CL_HANDLE_LEFT_BACK)
			m_nextHandle = CL_HANDLE_LEFT;
		
		m_inComplex = true;
		return;
	}
	if(m_nextHandle == CL_HANDLE_RIGHT_TOP || m_nextHandle == CL_HANDLE_LEFT_TOP)
	{
		m_nextDirectionPosition.y = m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_TOP;
		
		if(m_nextHandle == CL_HANDLE_RIGHT_TOP)
			m_nextHandle = CL_HANDLE_RIGHT;
		
		if(m_nextHandle == CL_HANDLE_LEFT_TOP)
			m_nextHandle = CL_HANDLE_LEFT;
		
		m_inComplex = true;
		return;
	}
	if(m_nextHandle == CL_HANDLE_RIGHT_BOTTOM|| m_nextHandle == CL_HANDLE_LEFT_BOTTOM)
	{
		m_nextDirectionPosition.y = -m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_BOTTOM;
		
		if(m_nextHandle == CL_HANDLE_RIGHT_BOTTOM)
			m_nextHandle = CL_HANDLE_RIGHT;
		
		if(m_nextHandle == CL_HANDLE_LEFT_BOTTOM)
			m_nextHandle = CL_HANDLE_LEFT;
		
		m_inComplex = true;
		return;
	}
	
	if(m_nextHandle == CL_HANDLE_TOP_FRONT|| m_nextHandle == CL_HANDLE_BOTTOM_FRONT)
	{
		m_nextDirectionPosition.z = m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_FRONT;
		
		if(m_nextHandle == CL_HANDLE_TOP_FRONT)
			m_nextHandle = CL_HANDLE_TOP;
		
		if(m_nextHandle == CL_HANDLE_BOTTOM_FRONT)
			m_nextHandle = CL_HANDLE_BOTTOM;
		
		m_inComplex = true;
		return;
	}
	if(m_nextHandle == CL_HANDLE_TOP_BACK || m_nextHandle == CL_HANDLE_BOTTOM_BACK)
	{
		m_nextDirectionPosition.z = -m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_BACK;
		
		if(m_nextHandle == CL_HANDLE_TOP_BACK)
			m_nextHandle = CL_HANDLE_TOP;
		
		if(m_nextHandle == CL_HANDLE_BOTTOM_BACK)
			m_nextHandle = CL_HANDLE_BOTTOM;
		
		m_inComplex = true;
		return;
	}
	if(m_nextHandle == CL_HANDLE_TOP_RIGHT || m_nextHandle == CL_HANDLE_BOTTOM_RIGHT)
	{
		m_nextDirectionPosition.x = m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_RIGHT;
		
		if(m_nextHandle == CL_HANDLE_TOP_RIGHT)
			m_nextHandle = CL_HANDLE_TOP;
		
		if(m_nextHandle == CL_HANDLE_BOTTOM_RIGHT)
			m_nextHandle = CL_HANDLE_BOTTOM;
		
		m_inComplex = true;
		return;
	}
	if(m_nextHandle == CL_HANDLE_TOP_LEFT|| m_nextHandle == CL_HANDLE_BOTTOM_LEFT)
	{
		m_nextDirectionPosition.x = -m_cubeEdgeLimit;
		m_nextDirection = CL_ZONE_LEFT;
		
		if(m_nextHandle == CL_HANDLE_TOP_LEFT)
			m_nextHandle = CL_HANDLE_TOP;
		
		if(m_nextHandle == CL_HANDLE_BOTTOM_LEFT)
			m_nextHandle = CL_HANDLE_BOTTOM;
		
		m_inComplex = true;
		return;
	}
}

- (void)ManageTurns
{
	if(!m_toTurn) return;
	
	GLKVector3 leaderPosition = Leader.Position;
	if(Direction == CL_ZONE_FRONT)
	{
		if(leaderPosition.z >= m_toTurnPosition.z)
		{
			[Leader ResetPosition:m_toTurnPosition];
			[Leader Frame:0.0f];
			Leader.Position = m_nextDirectionPosition;
			
			Direction = m_nextDirection;
			m_toTurn = false;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			return;
		}
	}
	if(Direction == CL_ZONE_BACK)
	{
		if(leaderPosition.z <= m_toTurnPosition.z)
		{
			[Leader ResetPosition:m_toTurnPosition];
			[Leader Frame:0.0f];
			Leader.Position = m_nextDirectionPosition;
			
			Direction = m_nextDirection;
			m_toTurn = false;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			return;
		}
	}
	if(Direction == CL_ZONE_RIGHT)
	{
		if(leaderPosition.x >= m_toTurnPosition.x)
		{
			[Leader ResetPosition:m_toTurnPosition];
			[Leader Frame:0.0f];
			Leader.Position = m_nextDirectionPosition;
			
			Direction = m_nextDirection;
			m_toTurn = false;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			return;
		}
	}
	if(Direction == CL_ZONE_LEFT)
	{
		if(leaderPosition.x <= m_toTurnPosition.x)
		{
			[Leader ResetPosition:m_toTurnPosition];
			[Leader Frame:0.0f];
			Leader.Position = m_nextDirectionPosition;
			
			Direction = m_nextDirection;
			m_toTurn = false;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			return;
		}
	}
	if(Direction == CL_ZONE_TOP)
	{
		if(leaderPosition.y >= m_toTurnPosition.y)
		{
			[Leader ResetPosition:m_toTurnPosition];
			[Leader Frame:0.0f];
			Leader.Position = m_nextDirectionPosition;
			
			Direction = m_nextDirection;
			m_toTurn = false;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			return;
		}
	}
	if(Direction == CL_ZONE_BOTTOM)
	{
		if(leaderPosition.y <= m_toTurnPosition.y)
		{
			[Leader ResetPosition:m_toTurnPosition];
			[Leader Frame:0.0f];
			Leader.Position = m_nextDirectionPosition;
			
			Direction = m_nextDirection;
			m_toTurn = false;
			
			[self MannageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
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
	
	m_bufferTurn = CL_TURN_UP_RIGHT;
	
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
	
	m_bufferTurn = CL_TURN_UP_LEFT;
	
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
	
	m_bufferTurn = CL_TURN_DOWN_RIGHT;
	
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
	
	m_bufferTurn = CL_TURN_DOWN_LEFT;
	
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
	
	m_bufferTurn = CL_TURN_RIGHT_UP;
	
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
	
	m_bufferTurn = CL_TURN_RIGHT_DOWN;
	
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
	
	m_bufferTurn = CL_TURN_LEFT_UP;
	
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
	
	m_bufferTurn = CL_TURN_LEFT_DOWN;
	
	enum CL_ZONE left = [self GetLeftOfZone:Zone Up:ZoneUp];
	if(Direction == left)return;
	
	enum CL_ZONE down = [self GetDownOfZone:Zone Up:ZoneUp];
	
	if(Direction == [self GetRightOfZone:Zone Up:ZoneUp])
		m_nextHandle = [self GetComplexHandleForDirection:left SecundaryDirection:down];
	else
		m_nextHandle = [self GetHandleForDirection:left];
}

- (void)ManageColloisions
{
	GLKVector3 position = Leader.Position;
	GLKVector3 p;
	int nowX = 0;
	int nowY = 0;
	
	if(Zone == CL_ZONE_FRONT || Zone == CL_ZONE_BACK)
	{
		nowX = roundf(position.x);
		nowY = roundf(position.y);
		p = GLKVector3Make(nowX, nowY, position.z);
	}
	if(Zone == CL_ZONE_RIGHT || Zone == CL_ZONE_LEFT)
	{
		nowX = roundf(position.z);
		nowY = roundf(position.y);
		p = GLKVector3Make(position.x, nowY, nowX);
	}
	if(Zone == CL_ZONE_TOP || Zone == CL_ZONE_BOTTOM)
	{
		nowX = roundf(position.x);
		nowY = roundf(position.z);
		p = GLKVector3Make(nowX, position.y, nowY);
	}
	
	if(nowX == m_leaderFaceX && nowY == m_leaderFaceY) return;
	
	m_leaderFaceX = nowX;
	m_leaderFaceY = nowY;
	m_leaderFaceZone = Zone;
	
	static bool inNoZone;
	static int inNoZoneReleased;
	if(m_leaderFaceX == -m_cubeEdgeLimit || m_leaderFaceY == -m_cubeEdgeLimit || m_leaderFaceX == m_cubeEdgeLimit || m_leaderFaceY == m_cubeEdgeLimit)
		inNoZone = true;
	
	if(inNoZone)
		inNoZoneReleased++;
	else
		inNoZoneReleased = 0;
	
	inNoZone = false;
	
	if(inNoZoneReleased > 1) return;
	
	if([self CheckColition:Zone CoordX:nowX CoordY:nowY])
	{
		//[[GameKitHelper sharedGameKitHelper] submitScore:Points category:@"cubiline_high_score"];
		//[[GameKitHelper sharedGameKitHelper] GetHighScore];
		[self ResetInZone:Zone Up:ZoneUp];
		[self Play];
		return;
	}
	
	[self AddSlot:Zone CoordX:nowX CoordY:nowY Position:p InZone:inNoZone == 0 ? true : false];
	
	
	if (!m_slotControl)
	{
		[self RemoveFirstSlot];
	}
	else
		m_slotControl--;
}

- (bool)CheckColition:(enum CL_ZONE)zone CoordX:(int)coordx CoordY:(int)coordy
{
	int slotPos = (coordy + m_cubeEdgeLimit) * m_cubeSideSize + (coordx + m_cubeEdgeLimit);
	
	return m_facesMap[zone][slotPos];
}

- (void)AddSlot:(enum CL_ZONE)zone CoordX:(int)coordx CoordY:(int)coordy Position:(GLKVector3)position InZone:(bool)inzone
{
	Slot* newSlot = [[Slot alloc] init];
	
	newSlot.Zone = zone;
	newSlot.CoordX = coordx;
	newSlot.CoordY = coordy;
	newSlot.inZone = inzone;
	
	if(inzone)
		m_occupied[zone]++;
	
	if(m_occupied[zone] == m_cubeFaceSlotLimit)
		NSLog(@"Full");
	
	
	int slotPos = (coordy + m_cubeEdgeLimit) * m_cubeSideSize + (coordx + m_cubeEdgeLimit);
	m_facesMap[zone][slotPos] = true;
	
	[m_slots addObject:newSlot];
}

- (void)RemoveFirstSlot
{
	Slot* first = [m_slots firstObject];
	int slotPos = (first.CoordY + m_cubeEdgeLimit) * m_cubeSideSize + (first.CoordX + m_cubeEdgeLimit);
	m_facesMap[first.Zone][slotPos] = false;
	
	if(first.inZone)
		m_occupied[first.Zone]--;
	
	[m_slots removeObjectAtIndex:0];
}

- (void)MannageFood
{
	float dist = GLKVector3Length(GLKVector3Subtract(Food.Position, Leader.Position));
	
	if(dist < 0.5f)
	{
		m_toGrow += 1.0f;
		m_slotControl += 1;
		m_taken += 1;
		
		Points += 1;
		TotalEaten += 1;
		
		m_eating = true;
		[self RandomFood];
	}
}

- (void)RandomFood
{
	GLKVector3 position;
	int face;
	int nowX = 0;
	int nowY = 0;
	int realX = 0;
	int realY = 0;
	int randomthreshold = 0;
	
	do
	{
		face = [m_random NextIntegerWithMin:0 Max:5];
		randomthreshold++;
		if(randomthreshold > 50)
		{
			for(int i = 0; i < 6; i++)
			{
				if(m_occupied[i] < m_cubeFaceSlotLimit)
				{
					face = i;
					break;
				}
				
			}
		}
	}
	while(m_occupied[face] >= m_cubeFaceSlotLimit);
	
	randomthreshold = 0;
	
	bool done = false;
	do
	{
		nowX = [m_random NextIntegerWithMin:-m_cubeEdgeLogicalLimit Max:m_cubeEdgeLogicalLimit];
		nowY = [m_random NextIntegerWithMin:-m_cubeEdgeLogicalLimit Max:m_cubeEdgeLogicalLimit];
		realX = nowX + m_cubeEdgeLimit;
		realY = nowY + m_cubeEdgeLimit;
		randomthreshold++;
		if(randomthreshold > 50)
		{
			for(int i = 1; i < m_cubeSideSize - 1; i++)
			{
				for(int o = 1; o < m_cubeSideSize - 1; o++)
				{
					if(!m_facesMap[face][i * (int)m_cubeSideSize + o])
					{
						realX = o;
						realY = i;
						done = true;
						break;
					}
				}
				if(done) break;
			}
		}
	}
	while(m_facesMap[face][realY * (int)m_cubeSideSize + realX]);
	
	if(face == CL_ZONE_FRONT)
	{
		position.x = nowX;
		position.y = nowY;
		position.z = m_cubeEdgeLimit;
	}
	if(face == CL_ZONE_BACK)
	{
		position.x = nowX;
		position.y = nowY;
		position.z = -m_cubeEdgeLimit;
	}
	if(face == CL_ZONE_RIGHT)
	{
		position.x = m_cubeEdgeLimit;
		position.y = nowY;
		position.z = nowX;
	}
	if(face == CL_ZONE_LEFT)
	{
		position.x = -m_cubeEdgeLimit;
		position.y = nowY;
		position.z = nowX;
	}
	if(face == CL_ZONE_TOP)
	{
		position.x = nowX;
		position.y = m_cubeEdgeLimit;;
		position.z = nowY;
	}
	if(face == CL_ZONE_BOTTOM)
	{
		position.x = nowX;
		position.y = -m_cubeEdgeLimit;;
		position.z = nowY;
	}
	
	Food.Position = position;
	[Food ResetScale:GLKVector3Make(0.0f, 0.0f, 0.0f)];
	Food.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
}

- (void)ManageDance
{
	GLKVector3 leaderPosition = Leader.Position;
	if(Zone == CL_ZONE_FRONT && !m_toTurn)
	{
		if(Direction == CL_ZONE_RIGHT)
		{
			if(leaderPosition.x > SmallSizeLimit - 1.5f)
				m_nextHandle = CL_HANDLE_TOP;
		}
		if(Direction == CL_ZONE_LEFT)
		{
			if(leaderPosition.x < -SmallSizeLimit + 1.5f)
				m_nextHandle = CL_HANDLE_BOTTOM;
		}
		if(Direction == CL_ZONE_TOP)
		{
			if(leaderPosition.y > SmallSizeLimit - 1.5f)
				m_nextHandle = CL_HANDLE_LEFT;
		}
		if(Direction == CL_ZONE_BOTTOM)
		{
			if(leaderPosition.y < -SmallSizeLimit + 1.5f)
				m_nextHandle = CL_HANDLE_RIGHT;
		}
	}
}

- (void)CreateLevel
{
	BodyColor = GLKVector3Make(0.9f, 0.95f, 1.0f);
	
	// Leader
	Leader = [m_renderBox NewModelFromFileName:@"quad"];
	Leader.PositionTransitionEffect = VE_TRANSITION_EFFECT_HARD;
	Leader.Color = BodyColor;
	Leader.PositionTransitionSpeed = 3.0f;
	
	// Ghost
	LeaderGhost = [[VE3DObject alloc] init];
	LeaderGhost.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	
	// Food
	Food = [m_renderBox NewModelFromFileName:@"geosphere_medium"];
	Food.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	Food.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	Food.ScaleTransitionTime = 0.2f;
	
	// Random.
	m_random = [[VERandom alloc] init];
	
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
	m_guides.ForcedRenderMode = VE_RENDER_MODE_FRAGMENT_LIGHT;
	
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
	BackWall.Color = SecundaryColor;
	RightWall.Color = SecundaryColor;
	LeftWall.Color = SecundaryColor;
	TopWall.Color = SecundaryColor;
	BottomWall.Color = SecundaryColor;
	
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
	TopLight.Intensity = 1.9f;
	
	BottomLight = [m_renderBox NewLight];
	BottomLight.Position = GLKVector3Make(45.0, -40.0f, -40.0);
	BottomLight.Intensity = 1.8f;
	
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
	
	// Camera.
	FocusedCamera = [m_renderBox NewCamera:VE_CAMERA_TYPE_PERSPECTIVE];
	FocusedCamera.ViewUpTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	FocusedCamera.ViewUpTransitionTime = 1.0f;
	FocusedCamera.LockLookAt = true;
	FocusedCamera.DepthOfField = false;
	FocusedCamera.Far = 60.0f;
	FocusedCamera.Near = 5.0f;
	FocusedCamera.FocusRange = 15.0f;

	// Body and slots
	Body = [[NSMutableArray alloc] init];
	m_slots = [[NSMutableArray alloc] init];
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
		
		m_radious = SmallSizeLimit * 2.3f * 2.0f;
		
		m_cubeSideSize = m_cubeEdgeLimit * 2 + 1;
		
		m_cubeFaceSlotLimit = (SmallSizeLimit * SmallSizeLimit * 4);
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
		
		m_radious = NormalSizeLimit * 2.3f * 2.0f;
		
		m_cubeSideSize = m_cubeEdgeLimit * 2 + 1;
		
		m_cubeFaceSlotLimit = (NormalSizeLimit * NormalSizeLimit * 4);
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
		
		m_radious = BigSizeLimit * 2.3f * 2.0f;
		
		m_cubeSideSize = m_cubeEdgeLimit * 2 + 1;
		
		m_cubeFaceSlotLimit = (BigSizeLimit * BigSizeLimit * 4);
	}
	
	if(Zone == CL_ZONE_FRONT)
	{
		FocusedCamera.Position = GLKVector3Make(0.0f, 0.0f, m_radious);
		FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
	}
	if(Zone == CL_ZONE_BACK)
	{
		FocusedCamera.Position = GLKVector3Make(0.0f, 0.0f, -m_radious);
		FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
	}
	if(Zone == CL_ZONE_RIGHT)
	{
		FocusedCamera.Position = GLKVector3Make(m_radious, 0.0f, 0.0f);
		FocusedCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
	}
	if(Zone == CL_ZONE_LEFT)
	{
		FocusedCamera.Position = GLKVector3Make(-m_radious, 0.0f, 0.0f);
		FocusedCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
	}
	if(Zone == CL_ZONE_TOP)
	{
		FocusedCamera.Position = GLKVector3Make(0.0f, m_radious, 0.0f);
		FocusedCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
	}
	if(Zone == CL_ZONE_BOTTOM)
	{
		FocusedCamera.Position = GLKVector3Make(0.0f, -m_radious, 0.0f);
		FocusedCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
	}
	
	// Collitions
	if(m_facesMap[CL_ZONE_FRONT])free(m_facesMap[CL_ZONE_FRONT]);
	if(m_facesMap[CL_ZONE_BACK])free(m_facesMap[CL_ZONE_BACK]);
	if(m_facesMap[CL_ZONE_RIGHT])free(m_facesMap[CL_ZONE_RIGHT]);
	if(m_facesMap[CL_ZONE_LEFT])free(m_facesMap[CL_ZONE_LEFT]);
	if(m_facesMap[CL_ZONE_TOP])free(m_facesMap[CL_ZONE_TOP]);
	if(m_facesMap[CL_ZONE_BOTTOM])free(m_facesMap[CL_ZONE_BOTTOM]);
	
	int positionsPerFace = m_cubeSideSize;
	positionsPerFace *= positionsPerFace;
	
	m_facesMap[CL_ZONE_FRONT] = calloc(positionsPerFace, sizeof(bool));
	m_facesMap[CL_ZONE_BACK] = calloc(positionsPerFace, sizeof(bool));
	m_facesMap[CL_ZONE_RIGHT] = calloc(positionsPerFace, sizeof(bool));
	m_facesMap[CL_ZONE_LEFT] = calloc(positionsPerFace, sizeof(bool));
	m_facesMap[CL_ZONE_TOP] = calloc(positionsPerFace, sizeof(bool));
	m_facesMap[CL_ZONE_BOTTOM] = calloc(positionsPerFace, sizeof(bool));
	
	
	m_resizing = true;
}

- (void)Restore
{
	FrontWall.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
	BackWall.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
	RightWall.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
	LeftWall.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
	TopWall.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
	BottomWall.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
	
	m_guides.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
	m_guides.TextureCompression = GLKVector3Make(1.0f, 1.0f, 1.0f);
	
	self.Feed = false;
	Leader.Opasity = 0.0f;

	[Body removeAllObjects];
	
	FocusedCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
	
	_Size = 456;
}

- (void)ManageResizing
{
	GLKVector3 leaderPosition = Leader.Position;
	GLKVector3 bodyPosition;
	float size = FrontWall.Scale.z / 2.0f + 0.5f;
	
	if(Zone == CL_ZONE_FRONT)
	{
		leaderPosition.z = size;
	}
	else if(Zone == CL_ZONE_BACK)
	{
		leaderPosition.z = -size;
	}
	else if(Zone == CL_ZONE_RIGHT)
	{
		leaderPosition.x = size;
	}
	else if(Zone == CL_ZONE_LEFT)
	{
		leaderPosition.x = -size;
	}
	else if(Zone == CL_ZONE_TOP)
	{
		leaderPosition.y = size;
	}
	else if(Zone == CL_ZONE_BOTTOM)
	{
		leaderPosition.y = -size;
	}
	
	[Leader ResetPosition:leaderPosition];
	[Leader Frame:0.0f];
	m_preLeaderPosition = leaderPosition;
	
	for(CLBody* body in Body)
	{
		bodyPosition = body.Model.Position;
		if(body.Zone == CL_ZONE_FRONT)
		{
			bodyPosition.z = size;
		}
		else if(body.Zone == CL_ZONE_BACK)
		{
			bodyPosition.z = -size;
		}
		else if(body.Zone == CL_ZONE_RIGHT)
		{
			bodyPosition.x = size;
		}
		else if(body.Zone == CL_ZONE_LEFT)
		{
			bodyPosition.x = -size;
		}
		else if(body.Zone == CL_ZONE_TOP)
		{
			bodyPosition.y = size;
		}
		else if(body.Zone == CL_ZONE_BOTTOM)
		{
			bodyPosition.y = -size;
		}
		[body.Model ResetPosition:bodyPosition];
		[body.Model Frame:0.0f];
	}
	
	m_resizing = FrontWall.ScaleIsActive;
	
	[self Play];
}

- (void)Reset
{
	[self ResetInZone:CL_ZONE_FRONT Up:CL_ZONE_TOP];
}

- (void)ResetInZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up
{
	[self SwitchZoneColor:Zone NewZone:zone];
	Leader.Opasity = 1.0f;
	Zone = zone;
	ZoneUp = up;
	
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
	
	//FocusedCamera.PivotRotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
	
	// Body.
	[Body removeAllObjects];
	[self AddBodyWithSize:3.0f];
	

	// Interactions
	m_toTurn = false;
	m_toNew = false;
	m_eating = false;
	m_toGrow = 0.0f;
	m_stepGrown = 0.0f;
	m_slotControl = 0;
	m_inComplex = false;
	m_taken = 0;
	Points = 0;
	m_bufferTurn = CL_TURN_NONE;

	LeaderGhost.Position = Leader.Position;
	m_preLeaderPosition = Leader.Position;
	
	m_nextHandle = CL_HANDLE_NONE;
	
	// Collitions
	if(m_facesMap[CL_ZONE_FRONT])free(m_facesMap[CL_ZONE_FRONT]);
	if(m_facesMap[CL_ZONE_BACK])free(m_facesMap[CL_ZONE_BACK]);
	if(m_facesMap[CL_ZONE_RIGHT])free(m_facesMap[CL_ZONE_RIGHT]);
	if(m_facesMap[CL_ZONE_LEFT])free(m_facesMap[CL_ZONE_LEFT]);
	if(m_facesMap[CL_ZONE_TOP])free(m_facesMap[CL_ZONE_TOP]);
	if(m_facesMap[CL_ZONE_BOTTOM])free(m_facesMap[CL_ZONE_BOTTOM]);
	
	int positionsPerFace = m_cubeSideSize;
	positionsPerFace *= positionsPerFace;
	
	m_facesMap[CL_ZONE_FRONT] = calloc(positionsPerFace, sizeof(bool));
	m_facesMap[CL_ZONE_BACK] = calloc(positionsPerFace, sizeof(bool));
	m_facesMap[CL_ZONE_RIGHT] = calloc(positionsPerFace, sizeof(bool));
	m_facesMap[CL_ZONE_LEFT] = calloc(positionsPerFace, sizeof(bool));
	m_facesMap[CL_ZONE_TOP] = calloc(positionsPerFace, sizeof(bool));
	m_facesMap[CL_ZONE_BOTTOM] = calloc(positionsPerFace, sizeof(bool));
	
	// Reset occupied.
	m_occupied[CL_ZONE_FRONT] = 4;
	m_occupied[CL_ZONE_BACK] = 0;
	m_occupied[CL_ZONE_RIGHT] = 0;
	m_occupied[CL_ZONE_LEFT] = 0;
	m_occupied[CL_ZONE_TOP] = 0;
	m_occupied[CL_ZONE_BOTTOM] = 0;
	
	// Reset slots
	int limit = (int)[m_slots count];
	for(int i = 0; i < limit; i++)
		[self RemoveFirstSlot];
	
	[m_slots removeAllObjects];
	
	GLKVector3 position = Leader.Position;
	
	[self AddSlot:Zone CoordX:0 CoordY:0 Position:position InZone:true];
	
	[self AddSlot:Zone CoordX:0 CoordY:0 Position:position InZone:true];
	
	[self AddSlot:Zone CoordX:0 CoordY:0 Position:position InZone:true];
	
	[self AddSlot:Zone CoordX:0 CoordY:0 Position:position InZone:true];
}

- (void)ChangeSpeed:(enum CL_SIZE)speed
{
	if(speed == CL_SIZE_SMALL)
	{
		Leader.PositionTransitionSpeed = 3.0f;
	}
	else if(speed == CL_SIZE_NORMAL)
	{
		Leader.PositionTransitionSpeed = 5.0f;
	}
	else if(speed == CL_SIZE_BIG)
	{
		Leader.PositionTransitionSpeed = 7.0f;
	}
	
	GLKVector3 leaderPosition = Leader.Position;
	[Leader ResetPosition:leaderPosition];
	
	[self Play];
	
}

- (void)setSize:(enum CL_SIZE)size
{
	if(_Size == size)return;
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

- (void)setFeed:(bool)feed
{
	Feed = feed;
	if(feed)
		[self RandomFood];
	else
		Food.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
}

- (bool)Feed
{
	return Feed;
}

- (void)setMove:(bool)move
{
	Move = move;
	if(move)
		[self Play];
	else
		[self Stop];
}

- (bool)Move
{
	return Move;
}

- (void)setBodyColor:(GLKVector3)color
{
	BodyColor = color;
	self.Leader.Color = BodyColor;
	for(CLBody* body in Body)
		body.Model.Color = color;
}

- (GLKVector3)BodyColor
{
	return BodyColor;
}

@end