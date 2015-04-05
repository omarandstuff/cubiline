#ifndef Cubiline_CLLevel_h
#define Cubiline_CLLevel_h

#import "CLbody.h"

@interface Slot : NSObject
@property enum CL_ZONE Zone;
@property int CoordX;
@property int CoordY;
@property bool inZone;
@property VEModel* Model;
@end

@interface CLLevel : NSObject

@property VEModel* Leader;
@property VE3DObject* LeaderGhost;
@property VEModel* Food;
@property VEModel* Food1;
@property VEModel* Food2;
@property VEModel* SpecialFood1;
@property VEModel* SpecialFood2;
@property VEModel* SpecialFood3;
@property VEModel* SpecialFood4;
@property VEModel* SpecialFood5;
@property NSMutableArray* Body;
@property VEScene* Scene;

@property enum CL_SIZE Size;
@property enum CL_SIZE Speed;
@property (readonly)enum CL_ZONE Zone;
@property (readonly)enum CL_ZONE Direction;
@property (readonly)enum CL_ZONE ZoneUp;

@property GLKVector3 BodyColor;

@property (readonly)VECamera* FocusedCamera;

@property bool Move;
@property bool Dance;
@property bool Follow;
@property bool Collide;
@property bool Feed;

@property (readonly)unsigned int Score;
@property unsigned int HighScore;
@property unsigned int Grown;
@property unsigned int Coins;

@property bool Finished;

@property (readonly)bool IsGhost;
@property (readonly)float GhostLeft;

@property (readonly)bool Special1Active;
@property (readonly)bool Special2Active;
@property (readonly)bool Special3Active;
@property (readonly)bool Special4Active;
@property (readonly)bool Special5Active;

- (id)initWithRenderBox:(VERenderBox*)renderbox Graphics:(enum CL_GRAPHICS)graphics;
- (void)Frame:(float)time;
- (void)Reset;
- (void)ResetInZone:(enum CL_ZONE)zone Up:(enum CL_ZONE)up;

- (bool)Reduction;
- (void)MakeGhost;

- (void)doTurn:(enum CL_TURN)turn;

- (void)Restore;

@end

#endif
