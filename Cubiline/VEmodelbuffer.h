#ifndef VisualEngine_VEmodelbuffer_h
#define VisualEngine_VEmodelbuffer_h

#import "VEtexturedispatcher.h"
#import "VElightshader.h"
#import "VEcolorlightshader.h"
#import "VEcolorshader.h"
#import "VEdepthShader.h"
#import "VEtextureshader.h"
#import "VEcommon.h"

//// Material //////
@interface BufferMaterial : NSObject
@property GLKVector3 Ka;
@property GLKVector3 Kd;
@property GLKVector3 Ks;
@property GLKVector3 Ke;
@property float Shininess;
@property float Alpha;
@property float Illumination;
@property float Glossiness;
@property VETexture* AmbientMap;
@property VETexture* DiffuseMap;
@property VETexture* SpecularMap;
@property VETexture* EmissionMap;
@property VETexture* ShininessMap;
@property VETexture* TransparencyMap;
@property VETexture* BumpMap;

@property NSString* Name;
@end

///// Vertex //////
@interface Vertex : NSObject
@property float x;
@property float y;
@property float z;
@property float tu;
@property float tv;
@property float nx;
@property float ny;
@property float nz;
@end

///// Vector ////
@interface Vector : NSObject
@property float x;
@property float y;
@property float z;
@end

/////// Buffer ////////

@interface Buffer : NSObject
@property NSMutableArray* Vertices;
@property unsigned int VertexCount;
@property GLuint VertexArrayID;
@property GLuint VertexBufferID;
@property BufferMaterial* Material;
@end

//////////////////////

@interface VEModelBuffer : NSObject

@property VETextureDispatcher* TextureDispatcher;
@property VEDepthShader* DepthShader;
@property VELightShader* LightShader;
@property VEColorLightShader* ColorLightSahder;
@property VEColorShader* ColorShader;
@property VETextureShader* TextureShader;
@property NSString* FileName;

- (id)initWithFileName:(NSString*)filename;
- (void)Render:(enum VE_RENDER_MODE)rendermode ModelViewProjectionMatrix:(GLKMatrix4*)mvpmatrix ModelMatrix:(GLKMatrix4*)modelmatrix NormalMatrix:(GLKMatrix3*)noramlmatrix CameraPosition:(GLKVector3)position Lights:(NSMutableArray*)lights EnableSpecular:(bool)enablespecular EnableNoise:(bool)enablenoise TextureCompression:(GLKVector3)texturecompression Color:(GLKVector3)color Opasity:(float)opasity;

@end

#endif
