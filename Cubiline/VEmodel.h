#ifndef VisualEngine_VEmodel_h
#define VisualEngine_VEmodel_h

#import "VErenderableobject.h"
#import "VEmodelbufferdispatcher.h"

@interface VEModel : VERenderableObject

@property VECamera* Camera;
@property NSMutableArray* Lights;
@property VEModelDispatcher* ModelBufferDispatcher;
@property enum VE_RENDER_MODE ForcedRenderMode;

- (id)initWithFileName:(NSString*)filename;
- (void)Render:(enum VE_RENDER_MODE)rendermode;


@end

#endif
