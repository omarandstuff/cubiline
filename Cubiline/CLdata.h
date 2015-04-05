#ifndef Cubiline_CLdata_h
#define Cubiline_CLdata_h

#import "VEgamecenter.h"

@interface CLData : NSObject <NSCoding>

@property unsigned int HighScore;
@property unsigned int Grown;
@property unsigned int Coins;
@property bool Mute;
@property unsigned int Size;
@property unsigned int Speed;
@property bool New;

@property VEGameCenter* GameCenter;

- (id)initWithGameCenter:(VEGameCenter*)gamecenter;

- (void)Frame;

+ (NSString*)filePath;
+ (id)loadInstanceWithGameCenter:(VEGameCenter*)gamecenter;

-(void)save;

@end

#endif
