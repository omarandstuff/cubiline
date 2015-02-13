#ifndef VisualEngine_VEsprite_h
#define VisualEngine_VEsprite_h

#import "VErenderableobject.h"
#import "VEtexturedispatcher.h"
#import "VEtextureshader.h"
#import "VEcolorshader.h"

@interface VESprite : VERenderableObject

@property VETexture* Texture;
@property VETextureShader* TextureShader;
@property VEColorShader* ColorShader;
@property VETextureDispatcher* TextureDispatcher;
@property GLKMatrix4* ProjectionMatrix;
@property GLKMatrix4* ViewMatrix;
@property (readonly) unsigned int TextureWidth;
@property (readonly) unsigned int TextureHeight;
@property float Width;
@property float Height;
@property bool LockAspect;

- (id)initFromTexture:(VETexture*)texture;
- (id)initFromFileName:(NSString*)filename;
- (void)Render;


@end

#endif
