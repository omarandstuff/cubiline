#import "VEscene.h"

@implementation SceneElement
@end

@interface VEScene()
{

}

@end

@implementation VEScene

@synthesize Models;
@synthesize Elements2D;
@synthesize Lights;
@synthesize Name;

- (id)initWithName:(NSString*)name
{
    self = [super init];
    
    if(self)
    {
		Models = [[NSMutableArray alloc] init];
        Elements2D = [[NSMutableArray alloc] init];
		Lights = [[NSMutableArray alloc] init];
        Name = name;
    }
    
    return self;
}

- (void)Frame:(float)time
{
    
}

- (void)addModel:(VEModel*)model
{
    [Models addObject:model];
}

- (void)addSprite:(VESprite*)sprite
{
	SceneElement* newElement = [[SceneElement alloc] init];
	newElement.Element = sprite;
	newElement.Kind = @"Sp";
	[Elements2D addObject:newElement];
}

- (void)addText:(VEText*)text
{
	SceneElement* newElement = [[SceneElement alloc] init];
	newElement.Element = text;
	newElement.Kind = @"Tx";
	[Elements2D addObject:newElement];
}

- (void)addLight:(VELight*)light
{
	[Lights addObject:light];
}

- (void)ReleaseModel:(VEModel*)model
{
    [Models enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(VEModel* modelA, NSUInteger index, BOOL *stop)
     {
         if (model == modelA)
         {
             [Models removeObjectAtIndex:index];
         }
     }];
}

- (void)ReleaseSprite:(VESprite*)sprite
{
	[Elements2D enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(SceneElement* element, NSUInteger index, BOOL *stop)
	 {
		 if (sprite == element.Element)
		 {
			 [Elements2D removeObjectAtIndex:index];
		 }
	 }];
}

- (void)ReleaseText:(VEText*)text
{
	[Elements2D enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(SceneElement* element, NSUInteger index, BOOL *stop)
	 {
		 if (text == element.Element)
		 {
			 [Elements2D removeObjectAtIndex:index];
		 }
	 }];
}

- (void)ReleaseLight:(VELight*)light
{
    [Lights enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(VELight* lightA, NSUInteger index, BOOL *stop)
     {
         if (light == lightA)
         {
             [Lights removeObjectAtIndex:index];
         }
     }];
}


@end
