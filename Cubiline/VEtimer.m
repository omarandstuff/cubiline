#import "VEtimer.h"

@implementation VETimer

@synthesize PlaybackSpeed;
@synthesize LastUpdateTime;

- (id)init
{
	self = [super init];
	
	if(self)
	{
		PlaybackSpeed = 1.0f;
	}
	
	return self;
}

- (void)Frame:(float)time
{
	LastUpdateTime = time * PlaybackSpeed;
}


@end