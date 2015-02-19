#ifndef VisualEngine_VEmodel_h
#define VisualEngine_VEmodel_h

#import "VErenderableobject.h"
#import "VEmodelbufferdispatcher.h"

@interface VEModel : VERenderableObject

@property VECamera* Camera;
@property NSMutableArray* Lights;
@property VEModelDispatcher* ModelBufferDispatcher;
@property bool DisableLight;
@property bool EnableNoise;
@property bool EnableSpecular;

- (id)initWithFileName:(NSString*)filename;
- (void)Render:(enum VE_RENDER_MODE)rendermode;


@end

#endif
