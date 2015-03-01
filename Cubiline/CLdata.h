#ifndef Cubiline_CLdata_h
#define Cubiline_CLdata_h

#import "VEgamecenter.h"

@interface CLData : NSObject <NSCoding>

@property unsigned int HighScore;
@property unsigned int Grown;

@property VEGameCenter* GameCenter;

- (id)initWithGameCenter:(VEGameCenter*)gamecenter;

- (void)Frame;

+ (NSString*)filePath;
+ (id)loadInstanceWithGameCenter:(VEGameCenter*)gamecenter;

-(void)save;

@end

#endif
