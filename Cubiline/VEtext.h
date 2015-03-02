#ifndef VisualEngine_VEtext_h
#define VisualEngine_VEtext_h

#import "VErenderableobject.h"
#import "VEtexturedispatcher.h"
#import "VEtextshader.h"

@interface Letter : NSObject
@property float CoordX;
@property float CoordY;
@property float Width;
@property float InRenderWith;
@end

@interface VEText : VERenderableObject

@property VETextureDispatcher* TextureDispatcher;
@property VETextShader* TextShader;
@property GLKMatrix4* ProjectionMatrix;
@property GLKMatrix4* ViewMatrix;
@property NSString* Text;
@property float FontSize;
@property float Width;
@property float Height;

- (void)ResetFontSize:(float)size;

- (id)initWithFontName:(NSString*)font;
- (id)initWithFontName:(NSString*)font Text:(NSString*)text;

- (void)Render;

@end

#endif
