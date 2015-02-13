#import "CLcubilinegame.h"

@implementation Slot
@end

@interface CLCubilineGame()
{
	VERenderBox* m_renderBox;

	VE3DObject* m_leaderGhost;
	
	VERandom* m_random;
	
	float m_levelSize;
	float m_levelLimit;
	int   m_levelSideSize;
	float m_radious;
	float m_levelLogicalLimit;
	int m_faceLimit;
	
	enum CL_ZONE m_zone;
	enum CL_ZONE m_zoneUp;
	enum CL_ZONE m_direction;
	
	enum CL_HANDLE m_handle;
	enum CL_HANDLE m_nextHandle;
	enum CL_TURN m_bufferTurn;
	
	bool m_justBuffered;
	
	GLKVector3 m_toTurnPosition;
	bool m_toTurn;
	bool m_inComplex;
	
	enum CL_ZONE m_nextDirection;
	GLKVector3 m_nextDirectionPosition;
	
	bool m_toNew;
	GLKVector3 m_prePosition;
	
	bool m_eating;
	float m_toGrow;
	float m_stepGrown;
	
	bool m_noZone;
	bool m_noZoneFase;
	
	NSMutableArray* m_slots;
	int m_leaderFaceX;
	int m_leaderFaceY;
	enum CL_ZONE m_leaderFaceZone;
	int m_slotControl;
	bool* m_facesMap[CL_ZONE_NUMBER];
	int m_occupied[CL_ZONE_NUMBER];
	
	VEView* m_cubeView;
	VECamera* m_cubeCamera;
	VESprite* m_cubeImage;
	
	unsigned int m_taken;
	VEEffect1* m_pointsEffect;
	VEText* m_points;
	
	enum CL_MODE
	{
		CL_MODE_PLAYING,
		CL_MODE_PAUSE,
		CL_MODE_NEW,
		CL_MODE_VIEWING
	};
	
	enum CL_MODE m_mode;
	
	VEEffect1* m_playerRate;
	
	GLKVector3 m_preViewRotation;
	
	GLKVector3 m_InViewPreRotation;
}

- (void)ResizeWorld;
- (void)CreateWorld;

- (void)AdjustCamera;
- (GLKVector2)CameraRotationBase:(float)base Horizontal:(float)horizontal Vertical:(float)vertical;

- (void)ManageZones;
- (void)ManageHandles;
- (void)ManageTurns;

- (enum CL_ZONE)GetUpOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;
- (enum CL_ZONE)GetDownOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;
- (enum CL_ZONE)GetRightOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;
- (enum CL_ZONE)GetLeftOfZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;

- (enum CL_HANDLE)GetHandleForDirection:(enum CL_ZONE)direction;
- (enum CL_HANDLE)GetComplexHandleForDirection:(enum CL_ZONE)direction SecundaryDirection:(enum CL_ZONE)secundarydirection;

- (void)doTurn:(enum CL_TURN)turn;

- (void)ManageBody;

- (void)ManageFood;
- (void)RandomFood;

- (void)SwitchZoneColor:(enum CL_ZONE)prezone NewZone:(enum CL_ZONE)newzone;
- (void)FocusSnake;

- (void)ResetGame;

- (void)ManageColloisions;
- (bool)CheckColition:(enum CL_ZONE)zone CoordX:(int)coordx CoordY:(int)coordy;
- (void)AddSlot:(enum CL_ZONE)zone CoordX:(int)coordx CoordY:(int)coordy Position:(GLKVector3)position InZone:(bool)inzone;
- (void)RemoveFirstSlot;

- (void)TurnUpRight;
- (void)TurnUpLeft;
- (void)TurnDownRight;
- (void)TurnDownLeft;
- (void)TurnRightUp;
- (void)TurnRightDown;
- (void)TurnLeftUp;
- (void)TurnLeftDown;

- (void)ManageText:(float)time;

- (void)Play;
- (void)Pause;

@end

@implementation CLCubilineGame

@synthesize Level;
@synthesize Scene;

- (id)initWithRenderBox:(VERenderBox*)renderbox
{
	self = [super init];
	
	if(self)
	{
		m_renderBox = renderbox;
		
		m_zone = CL_ZONE_FRONT;
		m_direction = CL_ZONE_RIGHT;
		m_zoneUp = CL_ZONE_TOP;
		
		[self CreateWorld];
	}
	
	return self;
}

- (void)Frame:(float)time
{
	// Check zones
	[self ManageZones];
	
	// Check for turns.
	[self ManageHandles];
	[self ManageTurns];
	
	// Check Body
	if(!m_toNew)
		[self ManageBody];
	m_toNew = false;
	
	// Check food.
	[self ManageFood];
	
	// Check collisions.
	[self ManageColloisions];
	
	// Camera target.
	[m_leaderGhost Frame:time];
	m_leaderGhost.Position = Level.Leader.Position;
	
	// Follow the leader.
	[self AdjustCamera];
	
	// Focus leader.
	[self FocusSnake];
	
	// Text
	[self ManageText:time];
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
	
	float spriteSize = width > height ? height : width;
	
	[m_cubeView ResizeWithWidth:spriteSize Height:spriteSize];
	m_cubeImage.Scale = GLKVector3Make(spriteSize, -spriteSize, 0.0f);
	
	m_points.FontSize = width > height ? height / 10 : width / 10;
	m_points.Position = GLKVector3Make(m_renderBox.ScreenWidth / 2 - m_points.Width, m_renderBox.ScreenHeight / 2 - m_points.Height, 0.0f);
}

- (void)Begin
{
	[self ResetGame];
	m_points.Opasity = 1.0f;
	[self Play];
}

- (void)ManageText:(float)time
{
	bool active = m_pointsEffect.IsActive;
	[m_pointsEffect Frame:time];
	
	if(active)
	{
		m_points.Text = [NSString stringWithFormat:@"%d", (int)m_pointsEffect.Value];
		m_points.Position = GLKVector3Make(m_renderBox.ScreenWidth / 2 - m_points.Width / 2 - m_points.Height / 2, m_renderBox.ScreenHeight / 2 - m_points.Height, 0.0f);
	}
}

- (void)ManageColloisions
{
	GLKVector3 position = Level.Leader.Position;
	GLKVector3 p;
	int nowX = 0;
	int nowY = 0;
	
	if(m_zone == CL_ZONE_FRONT || m_zone == CL_ZONE_BACK)
	{
		nowX = roundf(position.x);
		nowY = roundf(position.y);
		p = GLKVector3Make(nowX, nowY, position.z);
	}
	if(m_zone == CL_ZONE_RIGHT || m_zone == CL_ZONE_LEFT)
	{
		nowX = roundf(position.z);
		nowY = roundf(position.y);
		p = GLKVector3Make(position.x, nowY, nowX);
	}
	if(m_zone == CL_ZONE_TOP || m_zone == CL_ZONE_BOTTOM)
	{
		nowX = roundf(position.x);
		nowY = roundf(position.z);
		p = GLKVector3Make(nowX, position.y, nowY);
	}
	
	if(nowX == m_leaderFaceX && nowY == m_leaderFaceY) return;
	
	m_leaderFaceX = nowX;
	m_leaderFaceY = nowY;
	m_leaderFaceZone = m_zone;
	
	static bool inNoZone;
	static int inNoZoneReleased;
	if(m_leaderFaceX == -m_levelLimit || m_leaderFaceY == -m_levelLimit || m_leaderFaceX == m_levelLimit || m_leaderFaceY == m_levelLimit)
		inNoZone = true;
	
	if(inNoZone)
		inNoZoneReleased++;
	else
		inNoZoneReleased = 0;
	
	inNoZone = false;
	
	if(inNoZoneReleased > 1) return;
	
	if([self CheckColition:m_zone CoordX:nowX CoordY:nowY])
	{
		[self ResetGame];
		return;
	}
	
	[self AddSlot:m_zone CoordX:nowX CoordY:nowY Position:p InZone:inNoZone == 0 ? true : false];
	
	
	if (!m_slotControl)
	{
		[self RemoveFirstSlot];
	}
	else
		m_slotControl--;
}

- (bool)CheckColition:(enum CL_ZONE)zone CoordX:(int)coordx CoordY:(int)coordy
{
	int slotPos = (coordy + m_levelLimit) * m_levelSideSize + (coordx + m_levelLimit);
	
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
	
	if(m_occupied[zone] == m_faceLimit)
		NSLog(@"Full");
	
	
	int slotPos = (coordy + m_levelLimit) * m_levelSideSize + (coordx + m_levelLimit);
	m_facesMap[zone][slotPos] = true;
	
	[m_slots addObject:newSlot];
}

- (void)RemoveFirstSlot
{
	Slot* first = [m_slots firstObject];
	int slotPos = (first.CoordY + m_levelLimit) * m_levelSideSize + (first.CoordX + m_levelLimit);
	m_facesMap[first.Zone][slotPos] = false;
	
	if(first.inZone)
		m_occupied[first.Zone]--;
	
	[m_slots removeObjectAtIndex:0];
}

- (void)ManageBody
{
	float delta = GLKVector3Length(GLKVector3Subtract(m_prePosition, Level.Leader.Position));
	[[Level.Body lastObject] Grow:delta];
	
	
	CLBody* first = [Level.Body firstObject];
	
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
			[Level.Scene ReleaseModel:first.Model];
			[Level.Body removeObjectAtIndex:0];
			[[Level.Body firstObject] Grow:delta];
		}
	}
	
	m_prePosition = Level.Leader.Position;
}

- (void)ManageFood
{
	float dist = GLKVector3Length(GLKVector3Subtract(Level.Food.Position, Level.Leader.Position));
	
	if(dist < 0.5f)
	{
		m_toGrow += 1.0f;
		m_slotControl += 1;
		m_taken += 1;
		
		[m_pointsEffect Reset:m_taken];
		m_points.Text = [NSString stringWithFormat:@"%d", m_taken];
		m_points.Position = GLKVector3Make(m_renderBox.ScreenWidth / 2 - m_points.Width / 2 - m_points.Height / 2, m_renderBox.ScreenHeight / 2 - m_points.Height, 0.0f);
		
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
				if(m_occupied[i] < m_faceLimit)
				{
					face = i;
					break;
				}
				
			}
		}
	}
	while(m_occupied[face] >= m_faceLimit);
	
	randomthreshold = 0;
	
	bool done = false;
	do
	{
		nowX = [m_random NextIntegerWithMin:-m_levelLogicalLimit Max:m_levelLogicalLimit];
		nowY = [m_random NextIntegerWithMin:-m_levelLogicalLimit Max:m_levelLogicalLimit];
		realX = nowX + m_levelLimit;
		realY = nowY + m_levelLimit;
		randomthreshold++;
		if(randomthreshold > 50)
		{
			for(int i = 1; i < m_levelSideSize - 1; i++)
			{
				for(int o = 1; o < m_levelSideSize - 1; o++)
				{
					if(!m_facesMap[face][i * m_levelSideSize + o])
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
	while(m_facesMap[face][realY * m_levelSideSize + realX]);
	
	if(face == CL_ZONE_FRONT)
	{
		position.x = nowX;
		position.y = nowY;
		position.z = m_levelLimit;
	}
	if(face == CL_ZONE_BACK)
	{
		position.x = nowX;
		position.y = nowY;
		position.z = -m_levelLimit;
	}
	if(face == CL_ZONE_RIGHT)
	{
		position.x = m_levelLimit;
		position.y = nowY;
		position.z = nowX;
	}
	if(face == CL_ZONE_LEFT)
	{
		position.x = -m_levelLimit;
		position.y = nowY;
		position.z = nowX;
	}
	if(face == CL_ZONE_TOP)
	{
		position.x = nowX;
		position.y = m_levelLimit;;
		position.z = nowY;
	}
	if(face == CL_ZONE_BOTTOM)
	{
		position.x = nowX;
		position.y = -m_levelLimit;;
		position.z = nowY;
	}
	
	Level.Food.Position = position;
	[Level.Food ResetScale:GLKVector3Make(0.0f, 0.0f, 0.0f)];
	Level.Food.Scale = GLKVector3Make(0.9f, 0.9f, 0.9f);
}

- (void)FocusSnake
{
	float focusDistance = GLKVector3Length(GLKVector3Subtract(Level.Leader.Position, m_cubeCamera.Position));
	m_cubeCamera.FocusDistance = focusDistance;
}

- (void)ManageZones
{
	GLKVector3 leaderPosition = Level.Leader.Position;
	float limitZone = m_levelLimit - 1.0f;
	if(m_zone == CL_ZONE_FRONT)
	{
		if(leaderPosition.x <= limitZone && leaderPosition.x >= -limitZone && leaderPosition.y <= limitZone && leaderPosition.y >= -limitZone)
		{
			m_noZone = false;
			m_noZoneFase = false;
			return;
		}
		m_noZone = true;
		if(leaderPosition.x == m_levelLimit)
		{
			m_zone = CL_ZONE_RIGHT;
			m_direction = CL_ZONE_BACK;
			if(m_zoneUp == CL_ZONE_RIGHT)
			{
				m_zoneUp = CL_ZONE_BACK;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			if(m_zoneUp == CL_ZONE_LEFT)
			{
				m_zoneUp = CL_ZONE_FRONT;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			leaderPosition.z = -m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(m_radious, 0.0f, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_FRONT NewZone:CL_ZONE_RIGHT];
			
			return;
		}
		if(leaderPosition.x == -m_levelLimit)
		{
			m_zone = CL_ZONE_LEFT;
			m_direction = CL_ZONE_BACK;
			if(m_zoneUp == CL_ZONE_RIGHT)
			{
				m_zoneUp = CL_ZONE_FRONT;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			if(m_zoneUp == CL_ZONE_LEFT)
			{
				m_zoneUp = CL_ZONE_BACK;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			leaderPosition.z = -m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(-m_radious, 0.0f, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_FRONT NewZone:CL_ZONE_LEFT];
			
			return;
		}
		if(leaderPosition.y == m_levelLimit)
		{
			m_zone = CL_ZONE_TOP;
			m_direction = CL_ZONE_BACK;
			if(m_zoneUp == CL_ZONE_TOP)
			{
				m_zoneUp = CL_ZONE_BACK;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			if(m_zoneUp == CL_ZONE_BOTTOM)
			{
				m_zoneUp = CL_ZONE_FRONT;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			leaderPosition.z = -m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, m_radious, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_FRONT NewZone:CL_ZONE_TOP];
			
			return;
		}
		if(leaderPosition.y == -m_levelLimit)
		{
			m_zone = CL_ZONE_BOTTOM;
			m_direction = CL_ZONE_BACK;
			if(m_zoneUp == CL_ZONE_TOP)
			{
				m_zoneUp = CL_ZONE_FRONT;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			if(m_zoneUp == CL_ZONE_BOTTOM)
			{
				m_zoneUp = CL_ZONE_BACK;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			leaderPosition.z = -m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, -m_radious, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_FRONT NewZone:CL_ZONE_BOTTOM];
			
			return;
		}
	}
	if(m_zone == CL_ZONE_BACK)
	{
		if(leaderPosition.x <= limitZone && leaderPosition.x >= -limitZone && leaderPosition.y <= limitZone && leaderPosition.y >= -limitZone)
		{
			m_noZone = false;
			m_noZoneFase = false;
			return;
		}
		m_noZone = true;
		if(leaderPosition.x == -m_levelLimit)
		{
			m_zone = CL_ZONE_LEFT;
			m_direction = CL_ZONE_FRONT;
			if(m_zoneUp == CL_ZONE_RIGHT)
			{
				m_zoneUp = CL_ZONE_BACK;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			if(m_zoneUp == CL_ZONE_LEFT)
			{
				m_zoneUp = CL_ZONE_FRONT;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			leaderPosition.z = m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(-m_radious, 0.0f, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BACK NewZone:CL_ZONE_LEFT];
			
			return;
		}
		if(leaderPosition.x == m_levelLimit)
		{
			m_zone = CL_ZONE_RIGHT;
			m_direction = CL_ZONE_FRONT;
			if(m_zoneUp == CL_ZONE_RIGHT)
			{
				m_zoneUp = CL_ZONE_FRONT;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			if(m_zoneUp == CL_ZONE_LEFT)
			{
				m_zoneUp = CL_ZONE_BACK;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			leaderPosition.z = m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(m_radious, 0.0f, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BACK NewZone:CL_ZONE_RIGHT];
			
			return;
		}
		if(leaderPosition.y == m_levelLimit)
		{
			m_zone = CL_ZONE_TOP;
			m_direction = CL_ZONE_FRONT;
			if(m_zoneUp == CL_ZONE_TOP)
			{
				m_zoneUp = CL_ZONE_FRONT;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			if(m_zoneUp == CL_ZONE_BOTTOM)
			{
				m_zoneUp = CL_ZONE_BACK;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			leaderPosition.z = m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, m_radious, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BACK NewZone:CL_ZONE_TOP];
			
			return;
		}
		if(leaderPosition.y == -m_levelLimit)
		{
			m_zone = CL_ZONE_BOTTOM;
			m_direction = CL_ZONE_FRONT;
			if(m_zoneUp == CL_ZONE_TOP)
			{
				m_zoneUp = CL_ZONE_BACK;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, -1.0f);
			}
			if(m_zoneUp == CL_ZONE_BOTTOM)
			{
				m_zoneUp = CL_ZONE_FRONT;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 0.0f, 1.0f);
			}
			leaderPosition.z = m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, -m_radious, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BACK NewZone:CL_ZONE_BOTTOM];
			
			return;
		}
	}
	if(m_zone == CL_ZONE_RIGHT)
	{
		if(leaderPosition.z <= limitZone && leaderPosition.z >= -limitZone && leaderPosition.y <= limitZone && leaderPosition.y >= -limitZone)
		{
			m_noZone = false;
			m_noZoneFase = false;
			return;
		}
		m_noZone = true;
		if(leaderPosition.z == -m_levelLimit)
		{
			m_zone = CL_ZONE_BACK;
			m_direction = CL_ZONE_LEFT;
			if(m_zoneUp == CL_ZONE_FRONT)
			{
				m_zoneUp = CL_ZONE_RIGHT;
				m_cubeCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_BACK)
			{
				m_zoneUp = CL_ZONE_LEFT;
				m_cubeCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = -m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, -m_radious)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_RIGHT NewZone:CL_ZONE_BACK];
			
			return;
		}
		if(leaderPosition.z == m_levelLimit)
		{
			m_zone = CL_ZONE_FRONT;
			m_direction = CL_ZONE_LEFT;
			if(m_zoneUp == CL_ZONE_FRONT)
			{
				m_zoneUp = CL_ZONE_LEFT;
				m_cubeCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_BACK)
			{
				m_zoneUp = CL_ZONE_RIGHT;
				m_cubeCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = -m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, m_radious)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_RIGHT NewZone:CL_ZONE_FRONT];
			
			return;
		}
		if(leaderPosition.y == m_levelLimit)
		{
			m_zone = CL_ZONE_TOP;
			m_direction = CL_ZONE_LEFT;
			if(m_zoneUp == CL_ZONE_TOP)
			{
				m_zoneUp = CL_ZONE_LEFT;
				m_cubeCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_BOTTOM)
			{
				m_zoneUp = CL_ZONE_RIGHT;
				m_cubeCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = -m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, m_radious, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_RIGHT NewZone:CL_ZONE_TOP];
			
			return;
		}
		if(leaderPosition.y == -m_levelLimit)
		{
			m_zone = CL_ZONE_BOTTOM;
			m_direction = CL_ZONE_LEFT;
			if(m_zoneUp == CL_ZONE_TOP)
			{
				m_zoneUp = CL_ZONE_RIGHT;
				m_cubeCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_BOTTOM)
			{
				m_zoneUp = CL_ZONE_LEFT;
				m_cubeCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = -m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, -m_radious, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_RIGHT NewZone:CL_ZONE_BOTTOM];
			
			return;
		}
	}
	if(m_zone == CL_ZONE_LEFT)
	{
		if(leaderPosition.z <= limitZone && leaderPosition.z >= -limitZone && leaderPosition.y <= limitZone && leaderPosition.y >= -limitZone)
		{
			m_noZone = false;
			m_noZoneFase = false;
			return;
		}
		m_noZone = true;
		if(leaderPosition.z == m_levelLimit)
		{
			m_zone = CL_ZONE_FRONT;
			m_direction = CL_ZONE_RIGHT;
			if(m_zoneUp == CL_ZONE_FRONT)
			{
				m_zoneUp = CL_ZONE_RIGHT;
				m_cubeCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_BACK)
			{
				m_zoneUp = CL_ZONE_LEFT;
				m_cubeCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, m_radious)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_LEFT NewZone:CL_ZONE_FRONT];
			
			return;
		}
		if(leaderPosition.z == -m_levelLimit)
		{
			m_zone = CL_ZONE_BACK;
			m_direction = CL_ZONE_RIGHT;
			if(m_zoneUp == CL_ZONE_FRONT)
			{
				m_zoneUp = CL_ZONE_LEFT;
				m_cubeCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_BACK)
			{
				m_zoneUp = CL_ZONE_RIGHT;
				m_cubeCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, -m_radious)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_LEFT NewZone:CL_ZONE_BACK];
			
			return;
		}
		if(leaderPosition.y == m_levelLimit)
		{
			m_zone = CL_ZONE_TOP;
			m_direction = CL_ZONE_RIGHT;
			if(m_zoneUp == CL_ZONE_TOP)
			{
				m_zoneUp = CL_ZONE_RIGHT;
				m_cubeCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_BOTTOM)
			{
				m_zoneUp = CL_ZONE_LEFT;
				m_cubeCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, m_radious, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_LEFT NewZone:CL_ZONE_TOP];
			
			return;
		}
		if(leaderPosition.y == -m_levelLimit)
		{
			m_zone = CL_ZONE_BOTTOM;
			m_direction = CL_ZONE_RIGHT;
			if(m_zoneUp == CL_ZONE_TOP)
			{
				m_zoneUp = CL_ZONE_LEFT;
				m_cubeCamera.ViewUp = GLKVector3Make(-1.0f, 0.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_BOTTOM)
			{
				m_zoneUp = CL_ZONE_RIGHT;
				m_cubeCamera.ViewUp = GLKVector3Make(1.0f, 0.0f, 0.0f);
			}
			leaderPosition.x = m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, -m_radious, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_LEFT NewZone:CL_ZONE_BOTTOM];
			
			return;
		}
	}
	if(m_zone == CL_ZONE_TOP)
	{
		if(leaderPosition.x <= limitZone && leaderPosition.x >= -limitZone && leaderPosition.z <= limitZone && leaderPosition.z >= -limitZone)
		{
			m_noZone = false;
			m_noZoneFase = false;
			return;
		}
		m_noZone = true;
		if(leaderPosition.z == m_levelLimit)
		{
			m_zone = CL_ZONE_FRONT;
			m_direction = CL_ZONE_BOTTOM;
			if(m_zoneUp == CL_ZONE_FRONT)
			{
				m_zoneUp = CL_ZONE_BOTTOM;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_BACK)
			{
				m_zoneUp = CL_ZONE_TOP;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			leaderPosition.y = -m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, m_radious)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_TOP NewZone:CL_ZONE_FRONT];
			
			return;
		}
		if(leaderPosition.z == -m_levelLimit)
		{
			m_zone = CL_ZONE_BACK;
			m_direction = CL_ZONE_BOTTOM;
			if(m_zoneUp == CL_ZONE_FRONT)
			{
				m_zoneUp = CL_ZONE_TOP;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_BACK)
			{
				m_zoneUp = CL_ZONE_BOTTOM;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			leaderPosition.y = -m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, -m_radious)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_TOP NewZone:CL_ZONE_BACK];
			
			return;
		}
		if(leaderPosition.x == m_levelLimit)
		{
			m_zone = CL_ZONE_RIGHT;
			m_direction = CL_ZONE_BOTTOM;
			if(m_zoneUp == CL_ZONE_LEFT)
			{
				m_zoneUp = CL_ZONE_TOP;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_RIGHT)
			{
				m_zoneUp = CL_ZONE_BOTTOM;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			leaderPosition.y = -m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(m_radious, 0.0f, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_TOP NewZone:CL_ZONE_RIGHT];
			
			return;
		}
		if(leaderPosition.x == -m_levelLimit)
		{
			m_zone = CL_ZONE_LEFT;
			m_direction = CL_ZONE_BOTTOM;
			if(m_zoneUp == CL_ZONE_RIGHT)
			{
				m_zoneUp = CL_ZONE_TOP;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_LEFT)
			{
				m_zoneUp = CL_ZONE_BOTTOM;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			leaderPosition.y = -m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(-m_radious, 0.0f, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_TOP NewZone:CL_ZONE_LEFT];
			
			return;
		}
	}
	if(m_zone == CL_ZONE_BOTTOM)
	{
		if(leaderPosition.x <= limitZone && leaderPosition.x >= -limitZone && leaderPosition.z <= limitZone && leaderPosition.z >= -limitZone)
		{
			m_noZone = false;
			m_noZoneFase = false;
			return;
		}
		m_noZone = true;
		if(leaderPosition.z == m_levelLimit)
		{
			m_zone = CL_ZONE_FRONT;
			m_direction = CL_ZONE_TOP;
			if(m_zoneUp == CL_ZONE_FRONT)
			{
				m_zoneUp = CL_ZONE_TOP;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_BACK)
			{
				m_zoneUp = CL_ZONE_BOTTOM;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			leaderPosition.y = m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, m_radious)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BOTTOM NewZone:CL_ZONE_FRONT];
			
			return;
		}
		if(leaderPosition.z == -m_levelLimit)
		{
			m_zone = CL_ZONE_BACK;
			m_direction = CL_ZONE_TOP;
			if(m_zoneUp == CL_ZONE_FRONT)
			{
				m_zoneUp = CL_ZONE_BOTTOM;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_BACK)
			{
				m_zoneUp = CL_ZONE_TOP;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			leaderPosition.y = m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(0.0f, 0.0f, -m_radious)];
			m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BOTTOM NewZone:CL_ZONE_BACK];
			
			return;
		}
		if(leaderPosition.x == m_levelLimit)
		{
			m_zone = CL_ZONE_RIGHT;
			m_direction = CL_ZONE_TOP;
			if(m_zoneUp == CL_ZONE_RIGHT)
			{
				m_zoneUp = CL_ZONE_TOP;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_LEFT)
			{
				m_zoneUp = CL_ZONE_BOTTOM;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			leaderPosition.y = m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(m_radious, 0.0f, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BOTTOM NewZone:CL_ZONE_RIGHT];
			
			return;
		}
		if(leaderPosition.x == -m_levelLimit)
		{
			m_zone = CL_ZONE_LEFT;
			m_direction = CL_ZONE_TOP;
			if(m_zoneUp == CL_ZONE_RIGHT)
			{
				m_zoneUp = CL_ZONE_BOTTOM;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, -1.0f, 0.0f);
			}
			if(m_zoneUp == CL_ZONE_LEFT)
			{
				m_zoneUp = CL_ZONE_TOP;
				m_cubeCamera.ViewUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
			}
			leaderPosition.y = m_levelLimit;
			Level.Leader.Position = leaderPosition;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			[m_cubeCamera ResetPosition:GLKVector3Make(-m_radious, 0.0f, 0.0f)];
			m_cubeCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
			m_noZoneFase = true;
			
			[self doTurn:m_bufferTurn];
			m_bufferTurn = CL_TURN_NONE;
			m_justBuffered = true;
			
			[self SwitchZoneColor:CL_ZONE_BOTTOM NewZone:CL_ZONE_LEFT];
			
			return;
		}
	}
}

- (void)AdjustCamera
{
	GLKVector3 leaderGhostPosition = m_leaderGhost.Position;
	GLKVector2 newRotations;
	if(m_zone == CL_ZONE_FRONT)
	{
		newRotations = [self CameraRotationBase:leaderGhostPosition.z Horizontal:leaderGhostPosition.x Vertical:-leaderGhostPosition.y];
		m_cubeCamera.PivotRotation = GLKVector3Make(newRotations.x, newRotations.y, 0.0f);
	}
	if(m_zone == CL_ZONE_BACK)
	{
		newRotations = [self CameraRotationBase:leaderGhostPosition.z Horizontal:leaderGhostPosition.x Vertical:leaderGhostPosition.y];
		m_cubeCamera.PivotRotation = GLKVector3Make(newRotations.x, newRotations.y, 0.0f);
	}
	if(m_zone == CL_ZONE_RIGHT)
	{
		newRotations = [self CameraRotationBase:leaderGhostPosition.x Horizontal:leaderGhostPosition.y Vertical:-leaderGhostPosition.z];
		m_cubeCamera.PivotRotation = GLKVector3Make(0.0f, newRotations.x, newRotations.y);
	}
	if(m_zone == CL_ZONE_LEFT)
	{
		newRotations = [self CameraRotationBase:leaderGhostPosition.x Horizontal:leaderGhostPosition.y Vertical:leaderGhostPosition.z];
		m_cubeCamera.PivotRotation = GLKVector3Make(0.0f, newRotations.x, newRotations.y);
	}
	if(m_zone == CL_ZONE_TOP)
	{
		newRotations = [self CameraRotationBase:leaderGhostPosition.y Horizontal:-leaderGhostPosition.x Vertical:leaderGhostPosition.z];
		m_cubeCamera.PivotRotation = GLKVector3Make(newRotations.x, 0.0f, newRotations.y);
	}
	if(m_zone == CL_ZONE_BOTTOM)
	{
		newRotations = [self CameraRotationBase:leaderGhostPosition.y Horizontal:-leaderGhostPosition.x Vertical:-leaderGhostPosition.z];
		m_cubeCamera.PivotRotation = GLKVector3Make(newRotations.x, 0.0f, newRotations.y);
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

- (void)ManageHandles
{
	if(m_nextHandle == CL_HANDLE_NONE || m_inComplex || (m_noZone && !m_noZoneFase)) return;
	if(m_justBuffered)
	{
		m_justBuffered = false;
		return;
	}
	
	m_toTurnPosition = Level.Leader.Position;
	
	if(m_direction == CL_ZONE_FRONT)
	{
		if(m_toTurnPosition.z != (int)m_toTurnPosition.z)
		{
			m_toTurnPosition.z += m_levelLimit;
			m_toTurnPosition.z = (int)m_toTurnPosition.z + 1;
			m_toTurnPosition.z -= m_levelLimit;
		}
	}
	if(m_direction == CL_ZONE_BACK)
	{
		if(m_toTurnPosition.z != (int)m_toTurnPosition.z)
		{
			m_toTurnPosition.z -= m_levelLimit;
			m_toTurnPosition.z = (int)m_toTurnPosition.z - 1;
			m_toTurnPosition.z += m_levelLimit;
		}
	}
	if(m_direction == CL_ZONE_RIGHT)
	{
		if(m_toTurnPosition.x != (int)m_toTurnPosition.x)
		{
			m_toTurnPosition.x += m_levelLimit;
			m_toTurnPosition.x = (int)m_toTurnPosition.x + 1;
			m_toTurnPosition.x -= m_levelLimit;
		}
	}
	if(m_direction == CL_ZONE_LEFT)
	{
		if(m_toTurnPosition.x != (int)m_toTurnPosition.x)
		{
			m_toTurnPosition.x -= m_levelLimit;
			m_toTurnPosition.x = (int)m_toTurnPosition.x - 1;
			m_toTurnPosition.x += m_levelLimit;
		}
	}
	if(m_direction == CL_ZONE_TOP)
	{
		if(m_toTurnPosition.y != (int)m_toTurnPosition.y)
		{
			m_toTurnPosition.y += m_levelLimit;
			m_toTurnPosition.y = (int)m_toTurnPosition.y + 1;
			m_toTurnPosition.y -= m_levelLimit;
		}
	}
	if(m_direction == CL_ZONE_BOTTOM)
	{
		if(m_toTurnPosition.y != (int)m_toTurnPosition.y)
		{
			m_toTurnPosition.y -= m_levelLimit;
			m_toTurnPosition.y = (int)m_toTurnPosition.y - 1;
			m_toTurnPosition.y += m_levelLimit;
		}
	}
	
	m_toTurn = true;
	m_nextDirectionPosition = m_toTurnPosition;
	
	if(m_nextHandle == CL_HANDLE_FRONT)
	{
		m_nextDirectionPosition.z = m_levelLimit;
		m_nextDirection = CL_ZONE_FRONT;
		
		m_nextHandle = CL_HANDLE_NONE;
		return;
	}
	if(m_nextHandle == CL_HANDLE_BACK)
	{
		m_nextDirectionPosition.z = -m_levelLimit;
		m_nextDirection = CL_ZONE_BACK;
		
		m_nextHandle = CL_HANDLE_NONE;
		return;
	}
	if(m_nextHandle == CL_HANDLE_RIGHT)
	{
		m_nextDirectionPosition.x = m_levelLimit;
		m_nextDirection = CL_ZONE_RIGHT;
		
		m_nextHandle = CL_HANDLE_NONE;
		return;
	}
	if(m_nextHandle == CL_HANDLE_LEFT)
	{
		m_nextDirectionPosition.x = -m_levelLimit;
		m_nextDirection = CL_ZONE_LEFT;
		
		m_nextHandle = CL_HANDLE_NONE;
		return;
	}
	if(m_nextHandle == CL_HANDLE_TOP)
	{
		m_nextDirectionPosition.y = m_levelLimit;
		m_nextDirection = CL_ZONE_TOP;
		
		m_nextHandle = CL_HANDLE_NONE;
		return;
	}
	if(m_nextHandle == CL_HANDLE_BOTTOM)
	{
		m_nextDirectionPosition.y = -m_levelLimit;
		m_nextDirection = CL_ZONE_BOTTOM;
		
		m_nextHandle = CL_HANDLE_NONE;
		return;
	}
	
	if(m_nextHandle == CL_HANDLE_FRONT_RIGHT || m_nextHandle == CL_HANDLE_BACK_RIGHT)
	{
		m_nextDirectionPosition.x = m_levelLimit;
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
		m_nextDirectionPosition.x = -m_levelLimit;
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
		m_nextDirectionPosition.y = m_levelLimit;
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
		m_nextDirectionPosition.y = -m_levelLimit;
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
		m_nextDirectionPosition.z = m_levelLimit;
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
		m_nextDirectionPosition.z = -m_levelLimit;
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
		m_nextDirectionPosition.y = m_levelLimit;
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
		m_nextDirectionPosition.y = -m_levelLimit;
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
		m_nextDirectionPosition.z = m_levelLimit;
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
		m_nextDirectionPosition.z = -m_levelLimit;
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
		m_nextDirectionPosition.x = m_levelLimit;
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
		m_nextDirectionPosition.x = -m_levelLimit;
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
	
	GLKVector3 leaderPosition = Level.Leader.Position;
	if(m_direction == CL_ZONE_FRONT)
	{
		if(leaderPosition.z >= m_toTurnPosition.z)
		{
			[Level.Leader ResetPosition:m_toTurnPosition];
			[Level.Leader Frame:0.0f];
			Level.Leader.Position = m_nextDirectionPosition;
			
			m_direction = m_nextDirection;
			m_toTurn = false;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			return;
		}
	}
	if(m_direction == CL_ZONE_BACK)
	{
		if(leaderPosition.z <= m_toTurnPosition.z)
		{
			[Level.Leader ResetPosition:m_toTurnPosition];
			[Level.Leader Frame:0.0f];
			Level.Leader.Position = m_nextDirectionPosition;
			
			m_direction = m_nextDirection;
			m_toTurn = false;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			return;
		}
	}
	if(m_direction == CL_ZONE_RIGHT)
	{
		if(leaderPosition.x >= m_toTurnPosition.x)
		{
			[Level.Leader ResetPosition:m_toTurnPosition];
			[Level.Leader Frame:0.0f];
			Level.Leader.Position = m_nextDirectionPosition;
			
			m_direction = m_nextDirection;
			m_toTurn = false;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			return;
		}
	}
	if(m_direction == CL_ZONE_LEFT)
	{
		if(leaderPosition.x <= m_toTurnPosition.x)
		{
			[Level.Leader ResetPosition:m_toTurnPosition];
			[Level.Leader Frame:0.0f];
			Level.Leader.Position = m_nextDirectionPosition;
			
			m_direction = m_nextDirection;
			m_toTurn = false;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			return;
		}
	}
	if(m_direction == CL_ZONE_TOP)
	{
		if(leaderPosition.y >= m_toTurnPosition.y)
		{
			[Level.Leader ResetPosition:m_toTurnPosition];
			[Level.Leader Frame:0.0f];
			Level.Leader.Position = m_nextDirectionPosition;
			
			m_direction = m_nextDirection;
			m_toTurn = false;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
			m_toNew = true;
			
			m_inComplex = false;
			
			return;
		}
	}
	if(m_direction == CL_ZONE_BOTTOM)
	{
		if(leaderPosition.y <= m_toTurnPosition.y)
		{
			[Level.Leader ResetPosition:m_toTurnPosition];
			[Level.Leader Frame:0.0f];
			Level.Leader.Position = m_nextDirectionPosition;
			
			m_direction = m_nextDirection;
			m_toTurn = false;
			
			[self ManageBody];
			[Level AddBodyWithSize:0.0f];
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
	
	enum CL_ZONE up = [self GetUpOfZone:m_zone Up:m_zoneUp];
	if(m_direction == up)return;
	
	enum CL_ZONE right = [self GetRightOfZone:m_zone Up:m_zoneUp];
	
	if(m_direction == [self GetDownOfZone:m_zone Up:m_zoneUp])
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
	
	enum CL_ZONE up = [self GetUpOfZone:m_zone Up:m_zoneUp];
	if(m_direction == up)return;
	
	enum CL_ZONE left = [self GetLeftOfZone:m_zone Up:m_zoneUp];
	
	if(m_direction == [self GetDownOfZone:m_zone Up:m_zoneUp])
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
	
	enum CL_ZONE down = [self GetDownOfZone:m_zone Up:m_zoneUp];
	if(m_direction == down)return;
	
	enum CL_ZONE right = [self GetRightOfZone:m_zone Up:m_zoneUp];
	
	if(m_direction == [self GetUpOfZone:m_zone Up:m_zoneUp])
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
	
	enum CL_ZONE down = [self GetDownOfZone:m_zone Up:m_zoneUp];
	if(m_direction == down)return;
	
	enum CL_ZONE left = [self GetLeftOfZone:m_zone Up:m_zoneUp];
	
	if(m_direction == [self GetUpOfZone:m_zone Up:m_zoneUp])
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
	
	enum CL_ZONE right = [self GetRightOfZone:m_zone Up:m_zoneUp];
	if(m_direction == right)return;
	
	enum CL_ZONE up = [self GetUpOfZone:m_zone Up:m_zoneUp];
	
	if(m_direction == [self GetLeftOfZone:m_zone Up:m_zoneUp])
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
	
	enum CL_ZONE right = [self GetRightOfZone:m_zone Up:m_zoneUp];
	if(m_direction == right)return;
	
	enum CL_ZONE down = [self GetDownOfZone:m_zone Up:m_zoneUp];
	
	if(m_direction == [self GetLeftOfZone:m_zone Up:m_zoneUp])
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
	
	enum CL_ZONE left = [self GetLeftOfZone:m_zone Up:m_zoneUp];
	if(m_direction == left)return;
	
	enum CL_ZONE up = [self GetUpOfZone:m_zone Up:m_zoneUp];
	
	if(m_direction == [self GetRightOfZone:m_zone Up:m_zoneUp])
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
	
	enum CL_ZONE left = [self GetLeftOfZone:m_zone Up:m_zoneUp];
	if(m_direction == left)return;
	
	enum CL_ZONE down = [self GetDownOfZone:m_zone Up:m_zoneUp];
	
	if(m_direction == [self GetRightOfZone:m_zone Up:m_zoneUp])
		m_nextHandle = [self GetComplexHandleForDirection:left SecundaryDirection:down];
	else
		m_nextHandle = [self GetHandleForDirection:left];
}

- (void)TouchPanBegan:(float)x Y:(float)y Fingers:(int)fingers
{

}

- (void)TouchPanChange:(float)x Y:(float)y Fingers:(int)fingers
{

}

- (void)TouchPanEnd:(float)x Y:(float)y Fingers:(int)fingers
{
	if(m_mode == CL_MODE_PLAYING)
	{
		if(fabsf(x) > fabsf(y))
		{
			if(x > 0)
			{
				if(y > 0)
					[self TurnRightDown];
				else
					[self TurnRightUp];
			}
			else
			{
				if(y > 0)
					[self TurnLeftDown];
				else
					[self TurnLeftUp];
			}
		}
		else
		{
			if(y > 0)
			{
				if(x > 0)
					[self TurnDownRight];
				else
					[self TurnDownLeft];
			}
			else
			{
				if(x > 0)
					[self TurnUpRight];
				else
					[self TurnUpLeft];
			}
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

- (void)SwitchZoneColor:(enum CL_ZONE)prezone NewZone:(enum CL_ZONE)newzone
{
	if(prezone == CL_ZONE_FRONT)
		Level.FrontWall.Color = GLKVector3Make(0.3f, 0.35f, 0.4f);
	if(prezone == CL_ZONE_BACK)
		Level.BackWall.Color = GLKVector3Make(0.3f, 0.35f, 0.4f);
	if(prezone == CL_ZONE_RIGHT)
		Level.RightWall.Color = GLKVector3Make(0.3f, 0.35f, 0.4f);
	if(prezone == CL_ZONE_LEFT)
		Level.LeftWall.Color = GLKVector3Make(0.3f, 0.35f, 0.4f);
	if(prezone == CL_ZONE_TOP)
		Level.TopWall.Color = GLKVector3Make(0.3f, 0.35f, 0.4f);
	if(prezone == CL_ZONE_BOTTOM)
		Level.BottomWall.Color = GLKVector3Make(0.3f, 0.35f, 0.4f);
	
	if(newzone == CL_ZONE_FRONT)
		Level.FrontWall.Color = GLKVector3Make(0.25f, 1.0f, 0.95f);
	if(newzone == CL_ZONE_BACK)
		Level.BackWall.Color = GLKVector3Make(0.89f, 0.22f, 1.0f);
	if(newzone == CL_ZONE_RIGHT)
		Level.RightWall.Color = GLKVector3Make(0.95f, 1.0f, 0.05f);
	if(newzone == CL_ZONE_LEFT)
		Level.LeftWall.Color = GLKVector3Make(0.43f, 1.0f, 0.2f);
	if(newzone == CL_ZONE_TOP)
		Level.TopWall.Color = GLKVector3Make(1.0f, 0.25f, 0.16f);
	if(newzone == CL_ZONE_BOTTOM)
		Level.BottomWall.Color = GLKVector3Make(0.2f, 0.2f, 0.2f);
}

- (void)Play
{
	GLKVector3 position = Level.Leader.Position;
	if(m_direction == CL_ZONE_FRONT)
		position.z = m_levelLimit;
	if(m_direction == CL_ZONE_BACK)
		position.z = -m_levelLimit;
	if(m_direction == CL_ZONE_RIGHT)
		position.x = m_levelLimit;
	if(m_direction == CL_ZONE_LEFT)
		position.x = -m_levelLimit;
	if(m_direction == CL_ZONE_TOP)
		position.y = m_levelLimit;
	if(m_direction == CL_ZONE_BOTTOM)
		position.y = -m_levelLimit;
	
	Level.Leader.Position = position;
	m_mode = CL_MODE_PLAYING;
	
	m_playerRate.Value = 1.0f;
	
	m_points.Opasity = 1.0f;
	
	m_leaderGhost.PositionTransitionTime = 0.2f;
}

- (void)Pause
{
	[Level.Leader ResetPosition:Level.Leader.Position];
	m_mode = CL_MODE_PAUSE;
	
	m_playerRate.Value = 0.3;
	
	m_points.Opasity = 0.0f;
	
	m_preViewRotation = m_cubeCamera.PivotRotation;
}

- (void)ResetGame
{
	m_toTurn = false;
	m_toNew = false;
	m_eating = false;
	m_toGrow = 0.0f;
	m_stepGrown = 0.0f;
	m_slotControl = 0;
	m_inComplex = false;
	m_taken = 0;
	
	m_pointsEffect.Value = 0;
	
	m_leaderGhost.Position = Level.Leader.Position;
	
	m_handle = CL_HANDLE_NONE;
	m_nextHandle = CL_HANDLE_NONE;
	
	// Reset map.
	if(m_facesMap[CL_ZONE_FRONT])free(m_facesMap[CL_ZONE_FRONT]);
	if(m_facesMap[CL_ZONE_BACK])free(m_facesMap[CL_ZONE_BACK]);
	if(m_facesMap[CL_ZONE_RIGHT])free(m_facesMap[CL_ZONE_RIGHT]);
	if(m_facesMap[CL_ZONE_LEFT])free(m_facesMap[CL_ZONE_LEFT]);
	if(m_facesMap[CL_ZONE_TOP])free(m_facesMap[CL_ZONE_TOP]);
	if(m_facesMap[CL_ZONE_BOTTOM])free(m_facesMap[CL_ZONE_BOTTOM]);
	m_facesMap[CL_ZONE_FRONT] = calloc(m_levelSideSize * m_levelSideSize, sizeof(bool));
	m_facesMap[CL_ZONE_BACK] = calloc(m_levelSideSize * m_levelSideSize, sizeof(bool));
	m_facesMap[CL_ZONE_RIGHT] = calloc(m_levelSideSize * m_levelSideSize, sizeof(bool));
	m_facesMap[CL_ZONE_LEFT] = calloc(m_levelSideSize * m_levelSideSize, sizeof(bool));
	m_facesMap[CL_ZONE_TOP] = calloc(m_levelSideSize * m_levelSideSize, sizeof(bool));
	m_facesMap[CL_ZONE_BOTTOM] = calloc(m_levelSideSize * m_levelSideSize, sizeof(bool));
	
	// Reset occupied.
	m_occupied[CL_ZONE_FRONT] = 4;
	m_occupied[CL_ZONE_BACK] = 0;
	m_occupied[CL_ZONE_RIGHT] = 0;
	m_occupied[CL_ZONE_LEFT] = 0;
	m_occupied[CL_ZONE_TOP] = 0;
	m_occupied[CL_ZONE_BOTTOM] = 0;
	
	// Resed slots
	int limit = (int)[m_slots count];
	for(int i = 0; i < limit; i++)
		[self RemoveFirstSlot];
	
	[m_slots removeAllObjects];
	
	GLKVector3 position = Level.Leader.Position;
	
	[self AddSlot:m_zone CoordX:0 CoordY:0 Position:position InZone:true];
	
	[self AddSlot:m_zone CoordX:0 CoordY:0 Position:position InZone:true];
	
	[self AddSlot:m_zone CoordX:0 CoordY:0 Position:position InZone:true];
	
	[self AddSlot:m_zone CoordX:0 CoordY:0 Position:position InZone:true];
	
	[Level.Body removeAllObjects];
	
	[Level AddBodyWithSize:3.0f];
	
	// Food.
	[self RandomFood];
	
	m_points.Opasity = 0.0f;
	
	m_mode = CL_MODE_NEW;
}

- (void)ResizeWorld
{

}

- (void)CreateWorld
{
	// Cretae level.
	m_leaderGhost = [[VE3DObject alloc] init];
	m_leaderGhost.Position = GLKVector3Make(-20.0f, 20.0f, 5.0f);
	m_leaderGhost.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_leaderGhost.PositionTransitionTime = 1.0f;

	// Scene.
	Scene = [m_renderBox NewSceneWithName:@"CubilineGame"];
	
	// Collitions.
	m_slots = [[NSMutableArray alloc] init];
	
	// Random.
	m_random = [[VERandom alloc] init];
	
	// Camera.
	m_cubeCamera = [m_renderBox NewCamera:VE_CAMERA_TYPE_PERSPECTIVE];
	m_cubeCamera.LockLookAt = true;
	m_cubeCamera.DepthOfField = false;
	m_cubeCamera.ViewUpTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_cubeCamera.ViewUpTransitionTime = 1.0f;
	m_cubeCamera.PivotTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_cubeCamera.PivotTransitionTime = 0.3f;
	m_cubeCamera.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_cubeCamera.PositionTransitionTime = 0.3f;
	
	m_cubeCamera.Near = 1.0f;
	m_cubeCamera.Far = 100.0f;
	m_cubeCamera.FocusRange = 20.0f;
	
	m_cubeView = [m_renderBox NewViewAs:VE_VIEW_TYPE_TEXTURE Width:100 Height:100];
	m_cubeImage = [m_renderBox NewSpriteFromTexture:m_cubeView.Color];
	
	m_cubeView.Scene = Level.Scene;
	m_cubeView.Camera = m_cubeCamera;
	m_cubeView.EnableLight = false;
	m_cubeView.ClearColor = GLKVector4Make(0.95f, 0.95f, 1.0f, 1.0f);
	
	[Scene addSprite:m_cubeImage];
	
	m_points = [m_renderBox NewTextWithFontName:@"Gau Font Cube Medium" Text:@"0"];
	[Scene addText:m_points];
	
	m_points.Color = GrayColor;
	m_points.Opasity = 0.0f;
	m_points.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_points.OpasityTransitionTime = 0.3f;
	m_points.PositionTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH;
	m_points.PositionTransitionTime = 0.7f;
	
	m_pointsEffect = [[VEEffect1 alloc] init];
	m_pointsEffect.TransitionEffect = VE_TRANSITION_EFFECT_HARD;
	m_pointsEffect.TransitionTime = 0.5f;
	
	m_playerRate = [[VEEffect1 alloc] init];
	m_playerRate.Value = 1.0f;
	m_playerRate.TransitionEffect = VE_TRANSITION_EFFECT_HARD;
	m_playerRate.TransitionTime = 1.0f;
}

- (void)setLevel:(CLLevel *)level
{
	Level = level;
	m_cubeView.Scene = Level.Scene;
	
	float ls = 0.0f;
	
	if(Level.Size == CL_SIZE_SMALL)
		ls = 9.0f;
	else if(Level.Size == CL_SIZE_NORMAL)
		ls = 15.0f;
	else if(Level.Size == CL_SIZE_BIG)
		ls = 21.0f;

	m_radious = ls * 2.3;
	
	m_levelSize = ls / 2.0;
	m_levelLimit = m_levelSize + 0.5f;
	m_levelLogicalLimit = m_levelSize - 0.5;
	m_levelSideSize = (m_levelLimit * 2) + 1;
	m_faceLimit = ls * ls;
	
	if(m_zone == CL_ZONE_FRONT)
	{
		m_cubeCamera.Position = GLKVector3Make(0.0f, 0.0f, m_radious);
		m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, -m_radious);
	}
	if(m_zone == CL_ZONE_BACK)
	{
		m_cubeCamera.Position = GLKVector3Make(0.0f, 0.0f, -m_radious);
		m_cubeCamera.Pivot = GLKVector3Make(0.0f, 0.0f, m_radious);
	}
	if(m_zone == CL_ZONE_RIGHT)
	{
		m_cubeCamera.Position = GLKVector3Make(m_radious, 0.0f, 0.0f);
		m_cubeCamera.Pivot = GLKVector3Make(-m_radious, 0.0f, 0.0f);
	}
	if(m_zone == CL_ZONE_LEFT)
	{
		m_cubeCamera.Position = GLKVector3Make(-m_radious, 0.0f, 0.0f);
		m_cubeCamera.Pivot = GLKVector3Make(m_radious, 0.0f, 0.0f);
	}
	if(m_zone == CL_ZONE_TOP)
	{
		m_cubeCamera.Position = GLKVector3Make(0.0f, m_radious, 0.0f);
		m_cubeCamera.Pivot = GLKVector3Make(0.0f, -m_radious, 0.0f);
	}
	if(m_zone == CL_ZONE_BOTTOM)
	{
		m_cubeCamera.Position = GLKVector3Make(0.0f, -m_radious, 0.0f);
		m_cubeCamera.Pivot = GLKVector3Make(0.0f, m_radious, 0.0f);
	}
}

- (CLLevel*)Level
{
	return Level;
}

@end
