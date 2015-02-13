#import "VErenderableobject.h"

@implementation VERenderableObject

/// Color
@synthesize Color;
@synthesize ColorTransitionEffect;
@synthesize ColorTransitionTime;
@synthesize ColorTransitionSpeed;
@synthesize ColorEase;
@synthesize ColorIsActive;

/// Texture compression
@synthesize TextureCompression;
@synthesize TextureCompressionTransitionEffect;
@synthesize TextureCompressionTransitionTime;
@synthesize TextureCompressionTransitionSpeed;
@synthesize TextureCompressionEase;
@synthesize TextureCompressionIsActive;

/// Opsity
@synthesize Opasity;
@synthesize OpasityTransitionEffect;
@synthesize OpasityTransitionTime;
@synthesize OpasityTransitionSpeed;
@synthesize OpasityEase;
@synthesize OpasityIsActive;

- (id)init
{
	self = [super init];
	
	if(self)
	{
		m_color = [[VEEffect3 alloc] init];
		m_opasity = [[VEEffect1 alloc] init];
		m_textureCompression = [[VEEffect3 alloc] init];
		
		m_color.Vector = GLKVector3Make(1.0f, 1.0f, 1.0f);
		m_textureCompression.Vector = GLKVector3Make(1.0f, 1.0f, 1.0f);
		m_opasity.Value = 1.0f;
	}
	
	return self;
}

- (void)Frame:(float)time
{
	[super Frame:time];
	
	[m_color Frame:time];
	[m_opasity Frame:time];
	[m_textureCompression Frame:time];
}

////////// Color /////////////////
- (void)setColor:(GLKVector3)color
{
	m_color.Vector = color;
}

- (GLKVector3)Color
{
	return m_color.Vector;
}

- (void)setColorTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
	m_color.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)ColorTransitionEffect
{
	return m_color.TransitionEffect;
}

- (void)setColorTransitionTime:(float)transitiontime
{
	m_color.TransitionTime = transitiontime;
}

- (float)ColorTransitionTime
{
	return m_color.TransitionTime;
}

- (void)setColorTransitionSpeed:(float)transitionspeed
{
	m_color.TransitionSpeed = transitionspeed;
}

- (float)ColorTransitionSpeed
{
	return m_color.TransitionSpeed;
}

- (void)setColorEase:(float)ease
{
	m_color.Ease = ease;
}

- (float)ColorEase
{
	return m_color.Ease;
}

- (bool)ColorIsActive
{
	return m_color.IsActive;
}

////////// Texture compression /////////////////
- (void)setTextureCompression:(GLKVector3)textureCompression
{
	m_textureCompression.Vector = textureCompression;
}

- (GLKVector3)TextureCompression
{
	return m_textureCompression.Vector;
}

- (void)setTextureCompressionTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
	m_textureCompression.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)TextureCompressionTransitionEffect
{
	return m_textureCompression.TransitionEffect;
}

- (void)setTextureCompressionTransitionTime:(float)transitiontime
{
	m_textureCompression.TransitionTime = transitiontime;
}

- (float)TextureCompressionTransitionTime
{
	return m_textureCompression.TransitionTime;
}

- (void)setTextureCompressionTransitionSpeed:(float)transitionspeed
{
	m_textureCompression.TransitionSpeed = transitionspeed;
}

- (float)TextureCompressionTransitionSpeed
{
	return m_textureCompression.TransitionSpeed;
}

- (void)setTextureCompressionEase:(float)ease
{
	m_textureCompression.Ease = ease;
}

- (float)TextureCompressionEase
{
	return m_textureCompression.Ease;
}

- (bool)TextureCompressionIsActive
{
	return m_textureCompression.IsActive;
}

////////// Opasity /////////////////
- (void)setOpasity:(float)opasity
{
	m_opasity.Value = opasity;
}

- (float)Opasity
{
	return m_opasity.Value;
}

- (void)setOpasityTransitionEffect:(enum VE_TRANSITION_EFFECT)transitioneffect
{
	m_opasity.TransitionEffect = transitioneffect;
}

- (enum VE_TRANSITION_EFFECT)OpasityTransitionEffect
{
	return m_opasity.TransitionEffect;
}

- (void)setOpasityTransitionTime:(float)transitiontime
{
	m_opasity.TransitionTime = transitiontime;
}

- (float)OpasityTransitionTime
{
	return m_opasity.TransitionTime;
}

- (void)setOpasityTransitionSpeed:(float)transitionspeed
{
	m_opasity.TransitionSpeed = transitionspeed;
}

- (float)OpasityTransitionSpeed
{
	return m_opasity.TransitionSpeed;
}

- (void)setOpasityEase:(float)ease
{
	m_opasity.Ease = ease;
}

- (float)OpasityEase
{
	return m_opasity.Ease;
}

- (bool)OpasityIsActive
{
	return m_opasity.IsActive;
}

@end
