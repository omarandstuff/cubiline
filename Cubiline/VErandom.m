#import "VErandom.h"

@implementation VERandom

- (float)NextNormalized
{
    return (float)arc4random() / 4294967295.0;
}

- (float)NextFloatWithMin:(float)min Max:(float)max
{
    return min + (max - min) * [self NextNormalized];
}

- (int)NextIntegerWithMin:(int)min Max:(int)max
{
    return min + arc4random() % (max - min + 1);
}

@end
