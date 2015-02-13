#import "CLbody.h"

@interface CLBody()
{
	VERenderBox* m_renderBox;
	VEScene* m_scene;
}

- (void)SetUpPosition:(GLKVector3)bornPosition Size:(float)size;

@end

@implementation CLBody

@synthesize Model;
@synthesize Zone;
@synthesize Direction;

- (id)initWithRenderBox:(VERenderBox*)renderbox Scene:(VEScene*)scene Zone:(enum CL_ZONE)zone Direction:(enum CL_ZONE)direction BornPosition:(GLKVector3)bornposition Size:(float)size  Color:(GLKVector3)color
{
    self = [super init];
    
    if(self)
    {
		m_renderBox = renderbox;
		m_scene = scene;
		Model = [m_renderBox NewModelFromFileName:@"quad"];
		Model.Color = color;
		[m_scene addModel:Model];
		
        Zone = zone;
        Direction = direction;
        
        [self SetUpPosition:bornposition Size:size];
    }
    return self;
}

- (void)SetUpPosition:(GLKVector3)bornPosition Size:(float)size
{
    GLKVector3 scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
    

    if(Direction == CL_ZONE_FRONT)
    {
        scale.z = size;
        bornPosition.z -= size / 2.0 + 0.5;
    }
    if(Direction == CL_ZONE_BACK)
    {
        scale.z = size;
        bornPosition.z += size / 2.0 + 0.5;
    }
    if(Direction == CL_ZONE_RIGHT)
    {
        scale.x = size;
        bornPosition.x -= size / 2.0 + 0.5;
    }
    if(Direction == CL_ZONE_LEFT)
    {
        scale.x = size;
        bornPosition.x += size / 2.0 + 0.5;
    }
    if(Direction == CL_ZONE_TOP)
    {
        scale.y = size;
        bornPosition.y -= size / 2.0 + 0.5;
    }
    if(Direction == CL_ZONE_BOTTOM)
    {
        scale.y = size;
        bornPosition.y += size / 2.0 + 0.5;
    }
    
    Model.Scale = scale;
    Model.Position = bornPosition;
    [Model Frame:0.0f];
}

- (float)Grow:(float)delta
{
    GLKVector3 scale = Model.Scale;
    GLKVector3 position = Model.Position;
    float final = 0.0f;
    
    if(Direction == CL_ZONE_FRONT)
    {
        scale.z += delta;
        final = scale.z;
        
        position.z += fabsf(delta / 2.0f);
    }
    if(Direction == CL_ZONE_BACK)
    {
        scale.z += delta;
        final = scale.z;
        
        position.z -= fabsf(delta / 2.0f);
    }
    if(Direction == CL_ZONE_RIGHT)
    {
        scale.x += delta;
        final = scale.x;
        
        position.x += fabsf(delta / 2.0f);
    }
    if(Direction == CL_ZONE_LEFT)
    {
        scale.x += delta;
        final = scale.x;
        
        position.x -= fabsf(delta / 2.0f);
    }
    if(Direction == CL_ZONE_TOP)
    {
        scale.y += delta;
        final = scale.y;
        
        position.y += fabsf(delta / 2.0f);
    }
    if(Direction == CL_ZONE_BOTTOM)
    {
        scale.y += delta;
        final = scale.y;
        
        position.y -= fabsf(delta / 2.0f);
    }
    
    Model.Scale = scale;
    Model.Position = position;
    [Model Frame:0.0f];
    
    return final;
}

- (void)Snap
{
    GLKVector3 scale = Model.Scale;
    if(Direction == CL_ZONE_FRONT || Direction == CL_ZONE_BACK)
    {
        scale.z = round(scale.z);
    }
    if(Direction == CL_ZONE_RIGHT || Direction == CL_ZONE_LEFT)
    {
        scale.x = round(scale.x);
    }
    if(Direction == CL_ZONE_TOP || Direction == CL_ZONE_BOTTOM)
    {
        scale.y = round(scale.y);
    }
    Model.Scale = scale;
    [Model Frame:0.0f];
}

- (void)dealloc
{
	[m_scene ReleaseModel:Model];
	[m_renderBox ReleaseModel:Model];
}

@end