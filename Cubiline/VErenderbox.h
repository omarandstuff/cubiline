#ifndef VisualEngine_VErenderbox_h
#define VisualEngine_VErenderbox_h

#import "VEview.h"
#import "VErandom.h"
#import "VEtimer.h"

@interface VERenderBox : NSObject

@property (readonly) VEView* MainView;
@property int ScreenWidth;
@property int ScreenHeight;
@property (readonly) VETimer* Timer;

- (id)initWithContext:(EAGLContext *)context GLKView:(GLKView*)glkview Timer:(VETimer*)timer Width:(int)width Height:(int)height;
- (void)Frame:(float)time;
- (void)Render;
- (void)Resize;

- (void)Pause;
- (void)Play;

- (VESprite*)NewSpriteFromFileName:(NSString*)filename;
- (VESprite*)NewSpriteFromTexture:(VETexture*)texture;
- (VESprite*)NewSolidSpriteWithColor:(GLKVector3)color;
- (VEModel*)NewModelFromFileName:(NSString*)filename;
- (VEScene*)NewSceneWithName:(NSString*)name;
- (VEView*)NewViewAs:(enum VE_VIEW_TYPE)viewtype Width:(GLint)width Height:(GLint)height;
- (VECamera*)NewCamera:(enum VE_CAMERA_TYPE)cameratype;
- (VELight*)NewLight;
- (VEText*)NewTextWithFontName:(NSString*)fontname Text:(NSString*)text;
- (VEWatch*)NewWatchWithStyle:(enum VE_WATCH_STYLE)style;

- (void)ReleaseModel:(VEModel*)model;
- (void)ReleaseSprite:(VESprite*)sprite;
- (void)ReleaseScene:(VEScene*)scene;
- (void)ReleaseCamera:(VECamera*)camera;
- (void)ReleaseLight:(VELight*)light;
- (void)ReleaseText:(VEText*)text;
- (void)ReleaseWatch:(VEWatch*)watch;

@end

#endif
