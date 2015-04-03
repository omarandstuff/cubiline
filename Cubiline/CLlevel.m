#import "CLlevel.h"

@implementation Slot
@end

@interface CLLevel()
{
	VERenderBox* m_renderBox;
	VEModel* m_guides;
	
	//Level
	VEModel* m_levelModel;
	VELight* m_topLight;
	VELight* m_buttomLight;
	
	VEText* m_pointsShower;
	VEText* m_specialPoints1Shower;
	VEText* m_specialPoints2Shower;
	VEText* m_specialPoints3Shower;
	VEText* m_specialPoints4Shower;
	VEText* m_specialPoints5Shower;
	
	// Line control
	GLKVector3 m_preLeaderPosition;
	bool m_toNew;
	bool m_playing;
	int m_bodyLegth;
	int m_targetBodyLength;
	
	// Eating control
	bool m_eating;
	float m_stepGrown;
	float m_toGrow;
	int m_grown;
	
	bool m_unEating;
	float m_stepUnGrown;
	float m_toUnGrow;
	int m_unGrown;
	
	bool m_specialFood1Waiting;
	VEWatch* m_specialFood1Watch;
	float m_specialFood1MinTime;
	float m_specialFood1MaxTime;
	float m_specialFood1ShowTime;
	
	bool m_specialFood2Waiting;
	VEWatch* m_specialFood2Watch;
	float m_specialFood2MinTime;
	float m_specialFood2MaxTime;
	float m_specialFood2ShowTime;
	
	bool m_specialFood3Waiting;
	VEWatch* m_specialFood3Watch;
	float m_specialFood3MinTime;
	float m_specialFood3MaxTime;
	float m_specialFood3ShowTime;
	
	bool m_specialFood4Waiting;
	VEWatch* m_specialFood4Watch;
	float m_specialFood4MinTime;
	float m_specialFood4MaxTime;
	float m_specialFood4ShowTime;
	
	bool m_specialFood5Waiting;
	VEWatch* m_specialFood5Watch;
	float m_specialFood5MinTime;
	float m_specialFood5MaxTime;
	float m_specialFood5ShowTime;
	
	// Edge control
	float m_cubeEdgeLimit;
	float m_cubeEdgeLogicalLimit;
	float m_cubeSideSize;
	int m_cubeFaceSlotLimit;
	bool m_noZone;
	bool m_noZoneFase;
	bool m_bufferedInNoZone;
	
	// Camera control
	float m_radious;
	
	// Turn control
	enum CL_TURN m_bufferTurn;
	bool m_justBuffered;
	bool m_rested;
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
	int m_slotControlUnGrow;
	bool* m_facesMap[CL_ZONE_NUMBER];
	int m_occupied[CL_ZONE_NUMBER];
	
	// Feed control.
	VERandom* m_random;
	
	// ghsot
	VEWatch* m_ghostTime;
	bool m_ghostDeapering;
	
	
	bool m_restarted;
	
	enum CL_GRAPHICS m_graphics;
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
- (void)ManageBody;
- (void)SwitchZoneColor:(enum CL_ZONE)prezone NewZone:(enum CL_ZONE)newzone;
- (void)ManageZones;

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
- (void)Finish;
- (void)ManageColloisions;
- (bool)CheckColition:(enum CL_ZONE)zone CoordX:(int)coordx CoordY:(int)coordy;
- (void)AddSlot:(enum CL_ZONE)zone CoordX:(int)coordx CoordY:(int)coordy Position:(GLKVector3)position InZone:(bool)inzone;
- (void)RemoveFirstSlot;

// Feed
- (void)ManageFood;
- (void)RandomFood:(VEModel*)food;
- (void)PositionateTextByPoint:(VEText*)text Position:(GLKVector3)position Offset:(float)offset;

// Camera
- (void)FocusLeaderInCamera;
- (void)FollowWithCamera;
- (GLKVector2)CameraRotationBase:(float)base Horizontal:(float)horizontal Vertical:(float)vertical;
- (void)ManageFollow;

// powers
- (void)OutGhost;
- (void)ManageGhost;

@end

@implementation CLLevel

@synthesize Leader;
@synthesize LeaderGhost;
@synthesize Food;
@synthesize Food1;
@synthesize Food2;
@synthesize SpecialFood1;
@synthesize SpecialFood2;
@synthesize SpecialFood3;
@synthesize SpecialFood4;
@synthesize SpecialFood5;
@synthesize Body;
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
@synthesize Score;
@synthesize HighScore;
@synthesize Grown;
@synthesize Coins;
@synthesize Move;
@synthesize Finished;
@synthesize IsGhost;
@synthesize Special1Active;
@synthesize Special2Active;
@synthesize Special3Active;
@synthesize Special4Active;
@synthesize Special5Active;

- (id)initWithRenderBox:(VERenderBox*)renderbox Graphics:(enum CL_GRAPHICS)graphics
{
	self = [super init];
	
	if(self)
	{
		m_renderBox = renderbox;
		m_graphics = graphics;
		
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
		if(Move)
		{
			if(!Dance)
			{
				[m_specialFood1Watch Frame:time];
				[m_specialFood2Watch Frame:time];
				[m_specialFood3Watch Frame:time];
				[m_specialFood4Watch Frame:time];
				[m_specialFood5Watch Frame:time];
			}
			[m_ghostTime Frame:time];
			
			[self ManageGhost];
			
			[self ManageZones];
			[self ManageHandles];
			[self ManageTurns];
			
			if(!m_toNew)
				[self ManageBody];
			m_toNew = false;
		}
		
		[self ManageFollow];
		
		if(Move)
		{
			if(Feed)
				[self ManageFood];
			
			if(Collide )
				[self ManageColloisions];
		}
	}
	else
	{
		if(m_levelModel.Scale.x >= SmallSizeLimit)
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
	[Body addObject:[[CLBody alloc] initWithRenderBox:m_renderBox Scene:Scene Zone:Zone Direction:Direction BornPosition:Leader.Position Size:size Color:BodyColor Opasity:Leader.Opasity TargetOpasity:IsGhost ? 0.02f : 1.0f]];
}

- (void)ManageBody
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
			m_grown = 0;
		}
	}
	else
	{
		float deltaX = [first Grow:-delta];
		
		if(deltaX <= 0.0f)
		{
			[m_renderBox ReleaseModel:first.Model];
			[Scene ReleaseModel:first.Model];
			[Body removeObjectAtIndex:0];
			[[Body firstObject] Grow:deltaX];
		}
	}
	
	first = [Body firstObject];
	
	if(m_unEating)
	{
		m_stepUnGrown += delta;
		
		if(m_stepUnGrown >= m_toUnGrow)
		{
			delta -= (m_stepUnGrown - m_toUnGrow);
			m_unEating = false;
			m_stepUnGrown = 0.0f;
			m_toUnGrow = 0;
			m_unGrown = 0;
		}
		
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
	//	if(prezone == CL_ZONE_FRONT)
	//		m_guides.Color = SecundaryColor;
	//	if(prezone == CL_ZONE_BACK)
	//		BackWall.Color = SecundaryColor;
	//	if(prezone == CL_ZONE_RIGHT)
	//		RightWall.Color = SecundaryColor;
	//	if(prezone == CL_ZONE_LEFT)
	//		LeftWall.Color = SecundaryColor;
	//	if(prezone == CL_ZONE_TOP)
	//		TopWall.Color = SecundaryColor;
	//	if(prezone == CL_ZONE_BOTTOM)
	//		BottomWall.Color = SecundaryColor;
	
	if(newzone == CL_ZONE_FRONT)
		m_guides.Color = FrontColor;
	if(newzone == CL_ZONE_BACK)
		m_guides.Color = BackColor;
	if(newzone == CL_ZONE_RIGHT)
		m_guides.Color = RightColor;
	if(newzone == CL_ZONE_LEFT)
		m_guides.Color = LeftColor;
	if(newzone == CL_ZONE_TOP)
		m_guides.Color = TopColor;
	if(newzone == CL_ZONE_BOTTOM)
		m_guides.Color = BottomColor;
}

- (void)ManageZones
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(-m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, -m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(-m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, -m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, -m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, -m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, -m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, -m_radious, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, -m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(-m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, -m_radious)];
			FocusedCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[FocusedCamera ResetPosition:GLKVector3Make(-m_radious, 0.0f, 0.0f)];
			FocusedCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			m_rested = true;
			
			[self SwitchZoneColor:CL_ZONE_BOTTOM NewZone:CL_ZONE_LEFT];
			
			return;
		}
	}
}

- (void)ManageHandles
{
	if(m_nextHandle == CL_HANDLE_NONE || m_inComplex || (m_noZone && !m_noZoneFase))return;
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			if(!m_bufferedInNoZone)
			{
				[self doTurn:m_bufferTurn];
				m_bufferTurn = CL_TURN_NONE;
				m_justBuffered = true;
			}
			else
				m_bufferedInNoZone = false;
			
			if(m_rested)
			{
				m_rested = false;
				[self doTurn:m_bufferTurn];
				m_bufferTurn = CL_TURN_NONE;
			}
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			if(!m_bufferedInNoZone)
			{
				[self doTurn:m_bufferTurn];
				m_bufferTurn = CL_TURN_NONE;
				m_justBuffered = true;
			}
			else
				m_bufferedInNoZone = false;
			
			if(m_rested)
			{
				m_rested = false;
				[self doTurn:m_bufferTurn];
				m_bufferTurn = CL_TURN_NONE;
			}
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			if(!m_bufferedInNoZone)
			{
				[self doTurn:m_bufferTurn];
				m_bufferTurn = CL_TURN_NONE;
				m_justBuffered = true;
			}
			else
				m_bufferedInNoZone = false;
			
			if(m_rested)
			{
				m_rested = false;
				[self doTurn:m_bufferTurn];
				m_bufferTurn = CL_TURN_NONE;
			}
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			if(!m_bufferedInNoZone)
			{
				[self doTurn:m_bufferTurn];
				m_bufferTurn = CL_TURN_NONE;
				m_justBuffered = true;
			}
			else
				m_bufferedInNoZone = false;
			
			if(m_rested)
			{
				m_rested = false;
				[self doTurn:m_bufferTurn];
				m_bufferTurn = CL_TURN_NONE;
			}
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			if(!m_bufferedInNoZone)
			{
				[self doTurn:m_bufferTurn];
				m_bufferTurn = CL_TURN_NONE;
				m_justBuffered = true;
			}
			else
				m_bufferedInNoZone = false;
			
			if(m_rested)
			{
				m_rested = false;
				[self doTurn:m_bufferTurn];
				m_bufferTurn = CL_TURN_NONE;
			}
			
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
			
			[self ManageBody];
			[self AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			if(!m_bufferedInNoZone)
			{
				[self doTurn:m_bufferTurn];
				m_bufferTurn = CL_TURN_NONE;
				m_justBuffered = true;
			}
			else
				m_bufferedInNoZone = false;
			
			if(m_rested)
			{
				m_rested = false;
				[self doTurn:m_bufferTurn];
				m_bufferTurn = CL_TURN_NONE;
			}
			
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
		m_bufferedInNoZone = true;
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
		m_bufferedInNoZone = true;
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
		m_bufferedInNoZone = true;
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
		m_bufferedInNoZone = true;
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
		m_bufferedInNoZone = true;
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
		m_bufferedInNoZone = true;
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
		m_bufferedInNoZone = true;
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
		m_bufferedInNoZone = true;
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

- (void)Finish
{
	Finished = true;
	Leader.Color = GLKVector3Make(1.0f, 0.3f, 0.3f);
	Leader.Scale = GLKVector3Make(1.1f, 1.1f, 1.1f);
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
	
	if (!m_slotControl)
	{
		[self RemoveFirstSlot];
	}
	else
	{
		m_bodyLegth++;
		m_grown++;
		m_slotControl--;
	}
	
	if(m_slotControlUnGrow)
	{
		m_bodyLegth--;
		m_unGrown++;
		m_slotControlUnGrow--;
		[self RemoveFirstSlot];
	}
	
	if([self CheckColition:Zone CoordX:nowX CoordY:nowY] && !m_restarted && !IsGhost)
	{
		[self Finish];
		return;
	}
	else
		m_restarted = false;
	
	[self AddSlot:Zone CoordX:nowX CoordY:nowY Position:p InZone:inNoZone == 0 ? true : false];
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

- (void)ManageFood
{
	float dist = GLKVector3Length(GLKVector3Subtract(Food.Position, Leader.Position));
	float dist1 = GLKVector3Length(GLKVector3Subtract(Food1.Position, Leader.Position));
	float dist2 = GLKVector3Length(GLKVector3Subtract(Food2.Position, Leader.Position));
	
	if(dist < 0.5f)
	{
		m_toGrow += 1.0f;
		m_slotControl += 1;
		
		Score += 1;
		Grown += 1;
		
		HighScore = MAX(HighScore, Score);
		
		m_eating = true;
		
		[self PositionateTextByPoint:m_pointsShower Position:Food.Position Offset:1.5f];
		
		[self RandomFood:Food];
	}
	
	if(dist1 < 0.5f)
	{
		m_toGrow += 1.0f;
		m_slotControl += 1;
		
		Score += 1;
		Grown += 1;
		
		HighScore = MAX(HighScore, Score);
		
		m_eating = true;
		
		[self PositionateTextByPoint:m_pointsShower Position:Food1.Position Offset:1.5f];
		
		[self RandomFood:Food1];
	}
	
	if(dist2 < 0.5f)
	{
		m_toGrow += 1.0f;
		m_slotControl += 1;
		
		Score += 1;
		Grown += 1;
		
		HighScore = MAX(HighScore, Score);
		
		m_eating = true;
		
		[self PositionateTextByPoint:m_pointsShower Position:Food2.Position Offset:1.5f];
		
		[self RandomFood:Food2];
	}
	
	if(m_specialFood1Waiting)
	{
		if(!m_specialFood1Watch.Active)
		{
			if(_Size == CL_SIZE_SMALL)
				[m_specialFood1Watch ResetInSeconds:m_specialFood1ShowTime];
			else if(_Size == CL_SIZE_NORMAL)
				[m_specialFood1Watch ResetInSeconds:m_specialFood1ShowTime + 5.0f];
			else if(_Size == CL_SIZE_BIG)
				[m_specialFood1Watch ResetInSeconds:m_specialFood1ShowTime + 10.0f];
			
			[self RandomFood:SpecialFood1];
			
			m_specialFood1Waiting = false;
		}
	}
	else
	{
		float distspecial = GLKVector3Length(GLKVector3Subtract(SpecialFood1.Position, Leader.Position));
		
		if(distspecial < 0.5f)
		{
			m_toGrow += 10.0f;
			m_slotControl += 10;
			
			Score += 10;
			Grown += 10;
			
			HighScore = MAX(HighScore, Score);
			
			m_eating = true;
			
			[self PositionateTextByPoint:m_specialPoints1Shower Position:SpecialFood1.Position Offset:1.51f];
			
			[m_specialFood1Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood1MinTime Max:m_specialFood1MaxTime]];
			m_specialFood1Waiting = true;
			SpecialFood1.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
		}
		else if(!m_specialFood1Watch.Active)
		{
			[m_specialFood1Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood1MinTime Max:m_specialFood1MaxTime]];
			SpecialFood1.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
			m_specialFood1Waiting = true;
		}
	}
	
	if(m_specialFood2Waiting)
	{
		if(!m_specialFood2Watch.Active)
		{
			if(_Size == CL_SIZE_SMALL)
				[m_specialFood2Watch ResetInSeconds:m_specialFood2ShowTime];
			else if(_Size == CL_SIZE_NORMAL)
				[m_specialFood2Watch ResetInSeconds:m_specialFood2ShowTime + 5.0f];
			else if(_Size == CL_SIZE_BIG)
				[m_specialFood2Watch ResetInSeconds:m_specialFood2ShowTime + 10.0f];
			
			[self RandomFood:SpecialFood2];
			
			m_specialFood2Waiting = false;
		}
	}
	else
	{
		float distspecial = GLKVector3Length(GLKVector3Subtract(SpecialFood2.Position, Leader.Position));
		
		if(distspecial < 0.5f)
		{
			Score += 10;
			HighScore = MAX(HighScore, Score);
			
			[self PositionateTextByPoint:m_specialPoints2Shower Position:SpecialFood2.Position Offset:1.52f];
			
			[m_specialFood2Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood2MinTime Max:m_specialFood2MaxTime]];
			m_specialFood2Waiting = true;
			SpecialFood2.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
		}
		else if(!m_specialFood2Watch.Active)
		{
			[m_specialFood2Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood2MinTime Max:m_specialFood2MaxTime]];
			SpecialFood2.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
			m_specialFood2Waiting = true;
		}
	}
	
	if(m_specialFood3Waiting)
	{
		if(!m_specialFood3Watch.Active)
		{
			if(_Size == CL_SIZE_SMALL)
				[m_specialFood3Watch ResetInSeconds:m_specialFood3ShowTime];
			else if(_Size == CL_SIZE_NORMAL)
				[m_specialFood3Watch ResetInSeconds:m_specialFood3ShowTime + 5.0f];
			else if(_Size == CL_SIZE_BIG)
				[m_specialFood3Watch ResetInSeconds:m_specialFood3ShowTime + 10.0f];
			
			[self RandomFood:SpecialFood3];
			
			m_specialFood3Waiting = false;
		}
	}
	else
	{
		float distspecial = GLKVector3Length(GLKVector3Subtract(SpecialFood3.Position, Leader.Position));
		
		if(distspecial < 0.5f)
		{
			Coins += 400;
			
			[self PositionateTextByPoint:m_specialPoints3Shower Position:SpecialFood3.Position Offset:1.53f];
			
			[m_specialFood3Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood3MinTime Max:m_specialFood3MaxTime]];
			m_specialFood3Waiting = true;
			SpecialFood3.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
		}
		else if(!m_specialFood3Watch.Active)
		{
			[m_specialFood3Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood3MinTime Max:m_specialFood3MaxTime]];
			SpecialFood3.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
			m_specialFood3Waiting = true;
		}
	}
	
	if(m_specialFood4Waiting)
	{
		if(!m_specialFood4Watch.Active)
		{
			if(_Size == CL_SIZE_SMALL)
				[m_specialFood4Watch ResetInSeconds:m_specialFood4ShowTime];
			else if(_Size == CL_SIZE_NORMAL)
				[m_specialFood4Watch ResetInSeconds:m_specialFood4ShowTime + 5.0f];
			else if(_Size == CL_SIZE_BIG)
				[m_specialFood4Watch ResetInSeconds:m_specialFood4ShowTime + 10.0f];
			
			[self RandomFood:SpecialFood4];
			
			m_specialFood4Waiting = false;
		}
	}
	else
	{
		float distspecial = GLKVector3Length(GLKVector3Subtract(SpecialFood4.Position, Leader.Position));
		
		if(distspecial < 0.5f)
		{
			[self Reduction];
			
			[m_specialFood4Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood4MinTime Max:m_specialFood4MaxTime]];
			m_specialFood4Waiting = true;
			SpecialFood4.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
		}
		else if(!m_specialFood4Watch.Active)
		{
			[m_specialFood4Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood4MinTime Max:m_specialFood4MaxTime]];
			SpecialFood4.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
			m_specialFood4Waiting = true;
		}
	}
	
	if(m_specialFood5Waiting)
	{
		if(!m_specialFood5Watch.Active)
		{
			if(_Size == CL_SIZE_SMALL)
				[m_specialFood5Watch ResetInSeconds:m_specialFood5ShowTime];
			else if(_Size == CL_SIZE_NORMAL)
				[m_specialFood5Watch ResetInSeconds:m_specialFood5ShowTime + 5.0f];
			else if(_Size == CL_SIZE_BIG)
				[m_specialFood5Watch ResetInSeconds:m_specialFood5ShowTime + 10.0f];
			
			[self RandomFood:SpecialFood5];
			
			m_specialFood5Waiting = false;
		}
	}
	else
	{
		float distspecial = GLKVector3Length(GLKVector3Subtract(SpecialFood5.Position, Leader.Position));
		
		if(distspecial < 0.5f)
		{
			[self MakeGhost];
			
			[m_specialFood5Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood5MinTime Max:m_specialFood5MaxTime]];
			m_specialFood5Waiting = true;
			SpecialFood5.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
		}
		else if(!m_specialFood5Watch.Active)
		{
			[m_specialFood5Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood5MinTime Max:m_specialFood5MaxTime]];
			SpecialFood5.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
			m_specialFood5Waiting = true;
		}
	}
}

- (void)RandomFood:(VEModel*)food
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
		if(randomthreshold > 10)
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
	
	food.Position = position;
	[food ResetScale:GLKVector3Make(0.0f, 0.0f, 0.0f)];
	food.Scale = GLKVector3Make(0.9f, 0.9f, 0.9f);
}

- (void)PositionateTextByPoint:(VEText*)text Position:(GLKVector3)position Offset:(float)offset
{
	GLKVector3 rotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
	float toUp = 3.0f;
	
	if(Zone == CL_ZONE_FRONT)
	{
		position.z += offset;
		[text ResetPosition:position];
		
		text.RotationStyle = VE_ROTATION_STYLE_ZYX;
		if(ZoneUp == CL_ZONE_RIGHT)
		{
			rotation.z = -90.0f;
			position.x += toUp;
		}
		else if(ZoneUp == CL_ZONE_LEFT)
		{
			rotation.z = 90.0f;
			position.x -= toUp;
		}
		else if(ZoneUp == CL_ZONE_TOP)
		{
			rotation.z = 0.0f;
			position.y += toUp;
		}
		else if(ZoneUp == CL_ZONE_BOTTOM)
		{
			rotation.z = 180.0f;
			position.y -= toUp;
		}
		
		[text ResetRotation:rotation];
	}
	else if(Zone == CL_ZONE_BACK)
	{
		position.z -= offset;
		[text ResetPosition:position];
		
		rotation.y = 180.0f;
		text.RotationStyle = VE_ROTATION_STYLE_ZYX;
		if(ZoneUp == CL_ZONE_RIGHT)
		{
			rotation.z = -90.0f;
			position.x += toUp;
		}
		else if(ZoneUp == CL_ZONE_LEFT)
		{
			rotation.z = 90.0f;
			position.x -= toUp;
		}
		else if(ZoneUp == CL_ZONE_TOP)
		{
			rotation.z = 0.0f;
			position.y += toUp;
		}
		else if(ZoneUp == CL_ZONE_BOTTOM)
		{
			rotation.z = 180.0f;
			position.y -= toUp;
		}
		
		[text ResetRotation:rotation];
	}
	else if(Zone == CL_ZONE_RIGHT)
	{
		position.x += offset;
		[text ResetPosition:position];
		
		rotation.y = 90.0f;
		text.RotationStyle = VE_ROTATION_STYLE_XYZ;
		if(ZoneUp == CL_ZONE_FRONT)
		{
			rotation.x = 90.0f;
			position.z += toUp;
		}
		else if(ZoneUp == CL_ZONE_BACK)
		{
			rotation.x = -90.0f;
			position.z -= toUp;
		}
		else if(ZoneUp == CL_ZONE_TOP)
		{
			rotation.x = 0.0f;
			position.y += toUp;
		}
		else if(ZoneUp == CL_ZONE_BOTTOM)
		{
			rotation.x = 180.0f;
			position.y -= toUp;
		}
		
		[text ResetRotation:rotation];
	}
	else if(Zone == CL_ZONE_LEFT)
	{
		position.x -= offset;
		[text ResetPosition:position];
		
		rotation.y = -90.0f;
		text.RotationStyle = VE_ROTATION_STYLE_XYZ;
		if(ZoneUp == CL_ZONE_FRONT)
		{
			rotation.x = 90.0f;
			position.z += toUp;
		}
		else if(ZoneUp == CL_ZONE_BACK)
		{
			rotation.x = -90.0f;
			position.z -= toUp;
		}
		else if(ZoneUp == CL_ZONE_TOP)
		{
			rotation.x = 0.0f;
			position.y += toUp;
		}
		else if(ZoneUp == CL_ZONE_BOTTOM)
		{
			rotation.x = 180.0f;
			position.y -= toUp;
		}
		
		[text ResetRotation:rotation];
	}
	else if(Zone == CL_ZONE_TOP)
	{
		position.y += offset;
		[text ResetPosition:position];
		
		rotation.x = -90.0f;
		text.RotationStyle = VE_ROTATION_STYLE_YXZ;
		if(ZoneUp == CL_ZONE_FRONT)
		{
			rotation.y = 180.0f;
			position.z += toUp;
		}
		else if(ZoneUp == CL_ZONE_BACK)
		{
			rotation.y = 0.0f;
			position.z -= toUp;
		}
		else if(ZoneUp == CL_ZONE_RIGHT)
		{
			rotation.y = -90.0f;
			position.x += toUp;
		}
		else if(ZoneUp == CL_ZONE_LEFT)
		{
			rotation.y = 90.0f;
			position.x -= toUp;
		}
		
		[text ResetRotation:rotation];
	}
	else if(Zone == CL_ZONE_BOTTOM)
	{
		position.y -= offset;
		[text ResetPosition:position];
		
		rotation.x = 90.0f;
		text.RotationStyle = VE_ROTATION_STYLE_YXZ;
		if(ZoneUp == CL_ZONE_FRONT)
		{
			rotation.y = 0.0f;
			position.z += toUp;
		}
		else if(ZoneUp == CL_ZONE_BACK)
		{
			rotation.y = 180.0f;
			position.z -= toUp;
		}
		else if(ZoneUp == CL_ZONE_RIGHT)
		{
			rotation.y = 90.0f;
			position.x += toUp;
		}
		else if(ZoneUp == CL_ZONE_LEFT)
		{
			rotation.y = -90.0f;
			position.x -= toUp;
		}
		
		[text ResetRotation:rotation];
	}
	
	[text ResetFontSize:0.0f];
	[text ResetOpasity:1.0f];
	
	[text Frame:0.0f];
	
	text.Position = position;
	if(_Size == CL_SIZE_SMALL)
		text.FontSize = 2.0f;
	else if(_Size == CL_SIZE_NORMAL)
		text.FontSize = 3.0f;
	else
		text.FontSize = 4.0f;
	text.Opasity = 0.0f;
	
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

- (void)Reduction
{
	int togrow = (m_bodyLegth + (m_toGrow - m_grown) - (m_toUnGrow - m_unGrown)) > 14 ? 10 : (m_bodyLegth + (m_toGrow - m_grown) - (m_toUnGrow - m_unGrown) - 4);
	
	if(togrow > 0)
	{
		m_toUnGrow += (float)togrow;
		m_slotControlUnGrow += togrow;
		
		m_unEating = true;
		
		[self PositionateTextByPoint:m_specialPoints4Shower Position:Leader.Position Offset:1.54f];
	}
}

- (void)MakeGhost
{
	for(CLBody* body in Body)
	{
		body.Model.Opasity = 0.02f;
	}
	Leader.Opasity = 0.5f;
	IsGhost = true;
	[m_ghostTime SetLimitInSeconds:[m_ghostTime GetTotalTimeinSeconds] + 10.0f];
	[m_ghostTime Reset];
	
	m_ghostDeapering = false;
	
	[self PositionateTextByPoint:m_specialPoints5Shower Position:Leader.Position Offset:1.54f];
}

- (void)OutGhost
{
	for(CLBody* body in Body)
	{
		body.Model.Opasity = 1.0f;
	}
	Leader.Opasity = 1.0f;
	IsGhost = false;
}

- (void)ManageGhost
{
	if(!IsGhost)return;
	
	static float reachFlash;
	
 	if([m_ghostTime GetTotalTimeinSeconds] <= 5.0f && !m_ghostDeapering)
	{
		m_ghostDeapering = true;
		reachFlash = 5.0f;
	}
	
	if(!m_ghostTime.Active && IsGhost)
	{
		[self OutGhost];
		return;
	}
	
	Leader.Opasity = 0.5f;
	
	if([m_ghostTime GetTotalTimeinSeconds] <= reachFlash && [m_ghostTime GetTotalTimeinSeconds] > 0.2f)
	{
		for(CLBody* body in Body)
		{
			[body.Model ResetOpasity:1.0f];
			body.Model.Opasity = 0.02f;
		}
		[Leader ResetOpasity:1.0f];
		reachFlash /= 2.0f;
	}

}

- (void)CreateLevel
{
	BodyColor = GLKVector3Make(0.9f, 0.95f, 1.0f);
	
	// Leader
	Leader = [m_renderBox NewModelFromFileName:@"quad"];
	Leader.Color = BodyColor;
	Leader.PositionTransitionEffect = VE_TRANSITION_EFFECT_HARD;
	Leader.ColorTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	Leader.ColorTransitionTime = 0.3f;
	Leader.PositionTransitionSpeed = 3.0f;
	
	// Ghost
	LeaderGhost = [[VE3DObject alloc] init];
	LeaderGhost.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	
	// Food
	Food = [m_renderBox NewModelFromFileName:@"quad"];
	Food.Color = FrontColor;
	Food.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	Food.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	Food.ScaleTransitionTime = 0.2f;
	
	Food1 = [m_renderBox NewModelFromFileName:@"quad"];
	Food1.Color = FrontColor;
	Food1.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	Food1.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	Food1.ScaleTransitionTime = 0.2f;
	
	Food2 = [m_renderBox NewModelFromFileName:@"quad"];
	Food2.Color = FrontColor;
	Food2.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	Food2.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	Food2.ScaleTransitionTime = 0.2f;
	
	SpecialFood1 = [m_renderBox NewModelFromFileName:@"quad"];
	SpecialFood1.Color = RightColor;
	SpecialFood1.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	SpecialFood1.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	SpecialFood1.ScaleTransitionTime = 0.2f;
	m_specialFood1Watch = [[VEWatch alloc] init];
	m_specialFood1Watch.Style = VE_WATCH_STYLE_REVERSE;
	m_specialFood1MinTime = 45.0f;
	m_specialFood1MaxTime = 240.0f;
	m_specialFood1ShowTime = 8.0f;
	
	SpecialFood2 = [m_renderBox NewModelFromFileName:@"quad"];
	SpecialFood2.Color = BottomColor;
	SpecialFood2.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	SpecialFood2.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	SpecialFood2.ScaleTransitionTime = 0.2f;
	m_specialFood2Watch = [[VEWatch alloc] init];
	m_specialFood2Watch.Style = VE_WATCH_STYLE_REVERSE;
	m_specialFood2MinTime = 45.0f;
	m_specialFood2MaxTime = 240.0f;
	m_specialFood2ShowTime = 8.0f;
	
	SpecialFood3 = [m_renderBox NewModelFromFileName:@"quad"];
	SpecialFood3.Color = TopColor;
	SpecialFood3.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	SpecialFood3.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	SpecialFood3.ScaleTransitionTime = 0.2f;
	m_specialFood3Watch = [[VEWatch alloc] init];
	m_specialFood3Watch.Style = VE_WATCH_STYLE_REVERSE;
	m_specialFood3MinTime = 45.0f;
	m_specialFood3MaxTime = 240.0f;
	m_specialFood3ShowTime = 8.0f;
	
	SpecialFood4 = [m_renderBox NewModelFromFileName:@"quad"];
	SpecialFood4.Color = PrimaryColor;
	SpecialFood4.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	SpecialFood4.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	SpecialFood4.ScaleTransitionTime = 0.2f;
	m_specialFood4Watch = [[VEWatch alloc] init];
	m_specialFood4Watch.Style = VE_WATCH_STYLE_REVERSE;
	m_specialFood4MinTime = 120.0f;
	m_specialFood4MaxTime = 460.0f;
	m_specialFood4ShowTime = 8.0f;
	
	SpecialFood5 = [m_renderBox NewModelFromFileName:@"quad"];
	SpecialFood5.Color = ColorWhite;
	SpecialFood5.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	SpecialFood5.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	SpecialFood5.ScaleTransitionTime = 0.2f;
	m_specialFood5Watch = [[VEWatch alloc] init];
	m_specialFood5Watch.Style = VE_WATCH_STYLE_REVERSE;
	m_specialFood5MinTime = 45.0f;
	m_specialFood5MaxTime = 240.0f;
	m_specialFood5ShowTime = 8.0f;
	
	// Text
	m_pointsShower = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"1+"];
	m_pointsShower.FontSize = 0.0f;
	m_pointsShower.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_pointsShower.ScaleTransitionTime = 0.4f;
	m_pointsShower.Color = FrontColor;
	m_pointsShower.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_pointsShower.PositionTransitionTime = 0.3f;
	m_pointsShower.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_EASE;
	m_pointsShower.OpasityEase = 0.05f;
	m_pointsShower.OpasityTransitionTime = 2.2f;
	
	m_specialPoints1Shower = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"10+"];
	m_specialPoints1Shower.FontSize = 0.0f;
	m_specialPoints1Shower.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_specialPoints1Shower.ScaleTransitionTime = 0.4f;
	m_specialPoints1Shower.Color = RightColor;
	m_specialPoints1Shower.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_specialPoints1Shower.PositionTransitionTime = 0.3f;
	m_specialPoints1Shower.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_EASE;
	m_specialPoints1Shower.OpasityEase = 0.05f;
	m_specialPoints1Shower.OpasityTransitionTime = 2.2f;
	
	m_specialPoints2Shower = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"[10+]"];
	m_specialPoints2Shower.FontSize = 0.0f;
	m_specialPoints2Shower.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_specialPoints2Shower.ScaleTransitionTime = 0.4f;
	m_specialPoints2Shower.Color = BottomColor;
	m_specialPoints2Shower.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_specialPoints2Shower.PositionTransitionTime = 0.3f;
	m_specialPoints2Shower.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_EASE;
	m_specialPoints2Shower.OpasityEase = 0.05f;
	m_specialPoints2Shower.OpasityTransitionTime = 2.2f;
	
	m_specialPoints3Shower = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Coins"];
	m_specialPoints3Shower.FontSize = 0.0f;
	m_specialPoints3Shower.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_specialPoints3Shower.ScaleTransitionTime = 0.4f;
	m_specialPoints3Shower.Color = TopColor;
	m_specialPoints3Shower.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_specialPoints3Shower.PositionTransitionTime = 0.3f;
	m_specialPoints3Shower.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_EASE;
	m_specialPoints3Shower.OpasityEase = 0.05f;
	m_specialPoints3Shower.OpasityTransitionTime = 2.2f;
	
	m_specialPoints4Shower = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@">10<"];
	m_specialPoints4Shower.FontSize = 0.0f;
	m_specialPoints4Shower.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_specialPoints4Shower.ScaleTransitionTime = 0.4f;
	m_specialPoints4Shower.Color = PrimaryColor;
	m_specialPoints4Shower.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_specialPoints4Shower.PositionTransitionTime = 0.3f;
	m_specialPoints4Shower.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_EASE;
	m_specialPoints4Shower.OpasityEase = 0.05f;
	m_specialPoints4Shower.OpasityTransitionTime = 2.2f;
	
	m_specialPoints5Shower = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"Ghost"];
	m_specialPoints5Shower.FontSize = 0.0f;
	m_specialPoints5Shower.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_specialPoints5Shower.ScaleTransitionTime = 0.4f;
	m_specialPoints5Shower.Color = ColorWhite;
	m_specialPoints5Shower.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_specialPoints5Shower.PositionTransitionTime = 0.3f;
	m_specialPoints5Shower.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_EASE;
	m_specialPoints5Shower.OpasityEase = 0.05f;
	m_specialPoints5Shower.OpasityTransitionTime = 2.2f;
	
	// ghost
	m_ghostTime = [[VEWatch alloc] init];
	m_ghostTime.Style = VE_WATCH_STYLE_REVERSE;
	
	// Random.
	m_random = [[VERandom alloc] init];
	
	// Create Walls
	m_levelModel = [m_renderBox NewModelFromFileName:@"white_cube"];
	m_levelModel.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_levelModel.ScaleTransitionTime = 0.2f;
	
	m_guides = [m_renderBox NewModelFromFileName:@"single_guides_low"];
	m_guides.TextureCompressionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_guides.TextureCompressionTransitionTime = 0.3f;
	m_guides.ColorTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_guides.ColorTransitionTime = 0.3f;
	m_guides.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_guides.ScaleTransitionTime = 0.2f;
	m_guides.Opasity = 1.0f;
	m_guides.ForcedRenderMode = VE_RENDER_MODE_VERTEX_LIGHT;
	
	// Lights
	m_topLight = [m_renderBox NewLight];
	m_topLight.Position = GLKVector3Make(-45.0, 45.0f, 45.0f);
	m_topLight.Intensity = 1.75f;
	
	m_buttomLight = [m_renderBox NewLight];
	m_buttomLight.Position = GLKVector3Make(45.0, -45.0f, -45.0);
	m_buttomLight.Intensity = 1.8f;
	
	// Scene
	Scene = [m_renderBox NewSceneWithName:@"LevelScene"];
	
	// Add models to scene
	[Scene addModel:m_levelModel];
	[Scene addModel:m_guides];
	[Scene addModel:Food];
	[Scene addModel:Food1];
	[Scene addModel:Food2];
	[Scene addModel:SpecialFood1];
	[Scene addModel:SpecialFood2];
	[Scene addModel:SpecialFood3];
	[Scene addModel:SpecialFood4];
	[Scene addModel:SpecialFood5];
	[Scene addModel:Leader];
	[Scene addText3D:m_pointsShower];
	[Scene addText3D:m_specialPoints1Shower];
	[Scene addText3D:m_specialPoints2Shower];
	[Scene addText3D:m_specialPoints3Shower];
	[Scene addText3D:m_specialPoints4Shower];
	[Scene addText3D:m_specialPoints5Shower];
	
	
	[Scene addLight:m_topLight];
	[Scene addLight:m_buttomLight];
	
	// Camera.
	FocusedCamera = [m_renderBox NewCamera:VE_CAMERA_TYPE_PERSPECTIVE];
	FocusedCamera.ViewUpTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	FocusedCamera.ViewUpTransitionTime = 1.0f;
	FocusedCamera.LockLookAt = true;
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
		m_levelModel.Scale = SmallSizeVector;
		
		m_cubeEdgeLimit = 5.0f;
		m_cubeEdgeLogicalLimit = 4.0f;
		
		m_radious = SmallSizeLimit * 2.3f * 2.0f;
		
		m_cubeSideSize = m_cubeEdgeLimit * 2 + 1;
		
		m_guides.Scale = GuidesSmallSizeVector;
		m_guides.TextureCompression = SmallSizeVector;
		
		m_cubeFaceSlotLimit = (SmallSizeLimit * SmallSizeLimit * 4);
	}
	else if(size == CL_SIZE_NORMAL)
	{
		m_levelModel.Scale = NormalSizeVector;
		
		m_cubeEdgeLimit = 8.0f;
		m_cubeEdgeLogicalLimit = 7.0f;
		
		m_radious = NormalSizeLimit * 2.3f * 2.0f;
		
		m_cubeSideSize = m_cubeEdgeLimit * 2 + 1;
		
		m_guides.Scale = GuidesNormalSizeVector;
		m_guides.TextureCompression = NormalSizeVector;
		
		m_cubeFaceSlotLimit = (NormalSizeLimit * NormalSizeLimit * 4);
	}
	else if(size == CL_SIZE_BIG)
	{
		m_levelModel.Scale = BigSizeVector;
		
		m_cubeEdgeLimit = 11.0f;
		m_cubeEdgeLogicalLimit = 10.0f;
		
		m_radious = BigSizeLimit * 2.3f * 2.0f;
		
		m_cubeSideSize = m_cubeEdgeLimit * 2 + 1;
		
		m_guides.Scale = GuidesBigSizeVector;
		m_guides.TextureCompression = BigSizeVector;
		
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
	m_levelModel.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
	
	m_guides.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
	m_guides.TextureCompression = GLKVector3Make(1.0f, 1.0f, 1.0f);
	
	Food.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	SpecialFood1.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	SpecialFood2.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	SpecialFood3.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	
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
	float size = m_levelModel.Scale.z / 2.0f + 0.5f;
	
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
	
	m_resizing = m_levelModel.ScaleIsActive;
	
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
	[Leader ResetColor:PrimaryColor];
	Leader.Scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
	Leader.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	Leader.OpasityTransitionTime = 0.2f;
	[Leader ResetOpasity:1.0f];
	Zone = zone;
	ZoneUp = up;
	
	// If ghost
	[self OutGhost];
	
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
	
	
	// Interactions
	m_toTurn = false;
	m_toNew = false;
	m_eating = false;
	m_toGrow = 0.0f;
	m_stepGrown = 0.0f;
	m_slotControl = 0;
	m_inComplex = false;
	Score = 0;
	m_bufferTurn = CL_TURN_NONE;
	m_justBuffered = false;
	m_rested = false;
	Finished = false;
	m_restarted = true;
	m_bodyLegth = 4;
	m_toUnGrow = 0.0f;
	m_grown = 0;
	m_unGrown = 0;
	m_unEating = false;
	m_stepUnGrown = 0.0f;
	
	m_specialFood1Waiting = true;
	[m_specialFood1Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood1MinTime Max:m_specialFood1MaxTime]];
	SpecialFood1.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	
	m_specialFood2Waiting = true;
	[m_specialFood2Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood2MinTime Max:m_specialFood2MaxTime]];
	SpecialFood2.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	
	m_specialFood3Waiting = true;
	[m_specialFood3Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood3MinTime Max:m_specialFood3MaxTime]];
	SpecialFood3.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	
	m_specialFood4Waiting = true;
	[m_specialFood4Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood4MinTime Max:m_specialFood4MaxTime]];
	SpecialFood4.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	
	m_specialFood5Waiting = true;
	[m_specialFood5Watch ResetInSeconds:[m_random NextFloatWithMin:m_specialFood5MinTime Max:m_specialFood5MaxTime]];
	SpecialFood5.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	
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
	{
		[self RandomFood:Food];
		[self RandomFood:Food1];
		[self RandomFood:Food2];
	}
	else
	{
		Food.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
		Food1.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
		Food2.Scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
	}
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

- (bool)Special1Active
{
	return !m_specialFood1Waiting;
}

- (bool)Special2Active
{
	return !m_specialFood2Waiting;
}

- (bool)Special3Active
{
	return !m_specialFood3Waiting;
}

- (bool)Special4Active
{
	return !m_specialFood4Waiting;
}

- (bool)Special5Active
{
	return !m_specialFood5Waiting;
}

@end