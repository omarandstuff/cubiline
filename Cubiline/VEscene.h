#ifndef VisualEngine_VEscene_h
#define VisualEngine_VEscene_h

#import "VEsprite.h"
#import "VEmodel.h"
#import "VEtext.h"
#import "VElight.h"
#import "VEwatch.h"

@interface SceneElement : NSObject
@property id Element;
@property NSString* Kind;
@end

@interface VEScene : NSObject

@property (readonly)NSMutableArray* Models;
@property (readonly)NSMutableArray* Texts3D;
@property (readonly)NSMutableArray* Elements2D;
@property (readonly)NSMutableArray* Lights;
@property NSString* Name;

- (id)initWithName:(NSString*)name;
- (void)Frame:(float)time;

- (void)addModel:(VEModel*)model;
- (void)addSprite:(VESprite*)sprite;
- (void)addText:(VEText*)text;
- (void)addText3D:(VEText*)text;
- (void)addLight:(VELight*)light;

- (void)ReleaseModel:(VEModel*)model;
- (void)ReleaseSprite:(VESprite*)sprite;
- (void)ReleaseText:(VEText*)text;
- (void)ReleaseText3D:(VEText*)text;
- (void)ReleaseLight:(VELight*)light;

@end

#endif
