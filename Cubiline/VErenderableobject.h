#ifndef VisualEngine_VErenderableobject_h
#define VisualEngine_VErenderableobject_h

#import "VE3Dobject.h"

@interface VERenderableObject : VE3DObject
{
	VEEffect3* m_color;
	VEEffect3* m_textureCompression;
	VEEffect1* m_opasity;
}

/// Color
@property GLKVector3 Color;
@property enum VE_TRANSITION_EFFECT ColorTransitionEffect;
@property float ColorTransitionTime;
@property float ColorTransitionSpeed;
@property float ColorEase;
@property (readonly) bool ColorIsActive;

- (void)ResetColor;
- (void)ResetColor:(GLKVector3)state;

/// Texture compresion
@property GLKVector3 TextureCompression;
@property enum VE_TRANSITION_EFFECT TextureCompressionTransitionEffect;
@property float TextureCompressionTransitionTime;
@property float TextureCompressionTransitionSpeed;
@property float TextureCompressionEase;
@property (readonly) bool TextureCompressionIsActive;

- (void)ResetTextureCompression;
- (void)ResetTextureCompression:(GLKVector3)state;

/// Opsity
@property float Opasity;
@property enum VE_TRANSITION_EFFECT OpasityTransitionEffect;
@property float OpasityTransitionTime;
@property float OpasityTransitionSpeed;
@property float OpasityEase;
@property (readonly) bool OpasityIsActive;

- (void)ResetOpasity;
- (void)ResetOpasity:(float)state;

- (void)Frame:(float)time;

@end

#endif
