#import "VEmodelbuffer.h"

@implementation BufferMaterial
@end
@implementation Vertex
@end
@implementation Vector
@end
@implementation Buffer
@synthesize Vertices;
- (id)init
{
    self = [super init];
    if(self)
        Vertices = [[NSMutableArray alloc] init];
    return self;
}
@end

@interface VEModelBuffer()
{
    NSMutableDictionary* m_buffers;
    
    float m_top;
    float m_bottom;
    float m_left;
    float m_right;
    float m_front;
    float m_back;
}

- (void)LoadModel:(NSString*)filename;
- (void)LoadMaterial:(NSString*)filename;
- (void)GenerateBuffers;

- (void)ReleaseBuffers;

@end

@implementation VEModelBuffer

@synthesize TextureDispatcher;
@synthesize LightShader;
@synthesize ColorLightSahder;
@synthesize ColorShader;
@synthesize DepthShader;
@synthesize TextureShader;
@synthesize FileName;

- (id)initWithFileName:(NSString*)filename
{
    self = [super init];
    
    if(self)
    {
        m_buffers = [[NSMutableDictionary alloc] init];
        
        FileName = filename;
        
        [self LoadModel:filename];
    }
    
    return self;
}

- (void)Render:(enum VE_RENDER_MODE)rendermode ModelViewProjectionMatrix:(GLKMatrix4*)mvpmatrix ModelMatrix:(GLKMatrix4*)modelmatrix NormalMatrix:(GLKMatrix3*)noramlmatrix CameraPosition:(GLKVector3)position Lights:(NSMutableArray*)lights TextureCompression:(GLKVector3)texturecompression Color:(GLKVector3)color Opasity:(float)opasity
{
    for(id key in m_buffers)
    {
        Buffer* buffer = [m_buffers objectForKey:key];
        
        // Bind the vertex array object that stored all the information about the vertex and index buffers.
        glBindVertexArrayOES(buffer.VertexArrayID);
        
        if(rendermode == VE_RENDER_MODE_DEPTH)
        {
            // Set the shader parameters.
            [DepthShader Render:mvpmatrix];
            
            
            glEnableVertexAttribArray(GLKVertexAttribPosition);
            glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
            glDisableVertexAttribArray(GLKVertexAttribNormal);
        }
        
        if(rendermode == VE_RENDER_MODE_LIGHT)
        {
            // Set the shader parameters.
            if(buffer.Material.DiffuseMap == NULL)
                [ColorLightSahder Render:mvpmatrix ModelMatrix:modelmatrix NormalMatrix:noramlmatrix CameraPosition:position Lights:lights MaterialSpecular:buffer.Material.Shininess MaterialSpecularColor:buffer.Material.Ks MaterialGlossiness:buffer.Material.Glossiness Color:color Opasity:opasity];
            else
                [LightShader Render:mvpmatrix ModelMatrix:modelmatrix NormalMatrix:noramlmatrix CameraPosition:position Lights:lights TextureID:buffer.Material.DiffuseMap.TextureID TextureCompression:texturecompression MaterialSpecular:buffer.Material.Shininess MaterialSpecularColor:buffer.Material.Ks MaterialGlossiness:buffer.Material.Glossiness Opasity:opasity];
            
            glEnableVertexAttribArray(GLKVertexAttribPosition);
            glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
            glEnableVertexAttribArray(GLKVertexAttribNormal);
        }
        
        if(rendermode == VE_RENDER_MODE_TEXTURE)
        {
            // Set the shader parameters.
			if(buffer.Material.DiffuseMap == NULL)
				[ColorShader Render:mvpmatrix Color:color Opasity:opasity];
			else
				[TextureShader Render:mvpmatrix TextureID:buffer.Material.DiffuseMap.TextureID TextureCompression:texturecompression Color:color Opasity:opasity];
            
            glEnableVertexAttribArray(GLKVertexAttribPosition);
            glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
            glDisableVertexAttribArray(GLKVertexAttribNormal);
        }
        
        // Draw call.
        glDrawArrays(GL_TRIANGLES, 0, buffer.VertexCount);
    }
}

- (void)LoadModel:(NSString*)filename
{
    
    NSMutableArray* vertices = [[NSMutableArray alloc] init];
    NSMutableArray* normals = [[NSMutableArray alloc] init];
    NSMutableArray* UVWs = [[NSMutableArray alloc] init];
    
    Buffer* currentBuffer;
    
    NSString *fileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"obj"] encoding:NSUTF8StringEncoding error:NULL];
    
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]])
    {
        NSArray *words = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        words = [words filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
        
        if(![words count])
            continue;
        
        if([[words objectAtIndex:0] isEqual:@"#"])
            continue;
        
        if([[words objectAtIndex:0] isEqual:@"mtllib"])
        {
            for (int i = 1; i < [words count]; i++)
                [self LoadMaterial:[[[words objectAtIndex:i] lastPathComponent] stringByDeletingPathExtension]];
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"usemtl"])
        {
            currentBuffer = [m_buffers objectForKey:[words objectAtIndex:1]];
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"v"])
        {
            Vector* newVertex = [[Vector alloc] init];
            newVertex.x = [[words objectAtIndex:1] floatValue];
            newVertex.y = [[words objectAtIndex:2] floatValue];
            newVertex.z = [[words objectAtIndex:3] floatValue];
            [vertices addObject:newVertex];
            if([vertices count] == 1)
            {
                m_right = m_left = newVertex.x;
                m_top = m_bottom = newVertex.y;
                m_front = m_back = newVertex.z;
            }
            if (m_right < newVertex.x)
                m_right = newVertex.x;
            
            if (m_left > newVertex.x)
                m_left = newVertex.x;
            
            if (m_top < newVertex.y)
                m_top = newVertex.y;
            
            if (m_bottom > newVertex.y)
                m_bottom = newVertex.y;
            
            if (m_back < newVertex.z)
                m_back = newVertex.z;
            
            if (m_front > newVertex.z)
                m_front = newVertex.z;
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"vt"])
        {
            Vector* newUVW = [[Vector alloc] init];
            newUVW.x = [[words objectAtIndex:1] floatValue];
            newUVW.y = 1.0f - [[words objectAtIndex:2] floatValue];
            newUVW.z = [[words objectAtIndex:3] floatValue];
            [UVWs addObject:newUVW];
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"vn"])
        {
            Vector* newnormal = [[Vector alloc] init];
            newnormal.x = [[words objectAtIndex:1] floatValue];
            newnormal.y = [[words objectAtIndex:2] floatValue];
            newnormal.z = [[words objectAtIndex:3] floatValue];
            [normals addObject:newnormal];
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"f"])
        {
            NSArray* temp;
            for (int i = 3; i >= 1; i--)
            {
                temp = [[words objectAtIndex:i] componentsSeparatedByString:@"/"];
                Vertex* newVertex = [[Vertex alloc] init];
                
                Vector* vectemp = [vertices objectAtIndex:[[temp objectAtIndex:0] integerValue] - 1];
                newVertex.x = vectemp.x;
                newVertex.y = vectemp.y;
                newVertex.z = vectemp.z;
                
                vectemp = [UVWs objectAtIndex:[[temp objectAtIndex:1] integerValue] - 1];
                newVertex.tu = vectemp.x;
                newVertex.tv = vectemp.y;
                
                vectemp = [normals objectAtIndex:[[temp objectAtIndex:2] integerValue] - 1];
                newVertex.nx = vectemp.x;
                newVertex.ny = vectemp.y;
                newVertex.nz = vectemp.z;
                
                [currentBuffer.Vertices addObject:newVertex];
            }
            continue;
        }
    }
    
    [self GenerateBuffers];
}

- (void)LoadMaterial:(NSString*)filename
{
    NSString *fileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"mtl"] encoding:NSUTF8StringEncoding error:NULL];
    
    BufferMaterial* material;
    
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]])
    {
        NSArray *words = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        words = [words filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
        
        if(![words count])
            continue;
        
        if([[words objectAtIndex:0] isEqual:@"#"])
            continue;
        
        if([[words objectAtIndex:0] isEqual:@"newmtl"])
        {
            material = [[BufferMaterial alloc] init];
            material.Name = [words objectAtIndex:1];
            Buffer* newBuffer = [[Buffer alloc] init];
            newBuffer.material = material;
            [m_buffers setObject:newBuffer forKey:material.Name];
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"illum"])
        {
            material.Illumination = [[words objectAtIndex:1] floatValue];
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"Ka"])
        {
            material.Ka = GLKVector3Make([[words objectAtIndex:1] floatValue], [[words objectAtIndex:2] floatValue], [[words objectAtIndex:3] floatValue]);
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"Kd"])
        {
            material.Kd = GLKVector3Make([[words objectAtIndex:1] floatValue], [[words objectAtIndex:2] floatValue], [[words objectAtIndex:3] floatValue]);
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"Ks"])
        {
            material.Ks = GLKVector3Make([[words objectAtIndex:1] floatValue], [[words objectAtIndex:2] floatValue], [[words objectAtIndex:3] floatValue]);
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"Ke"])
        {
            material.Ke = GLKVector3Make([[words objectAtIndex:1] floatValue], [[words objectAtIndex:2] floatValue], [[words objectAtIndex:3] floatValue]);
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"Ns"])
        {
            material.Shininess = [[words objectAtIndex:1] floatValue];
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"Ni"])
        {
            material.Glossiness = [[words objectAtIndex:1] floatValue];
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"d"] || [[words objectAtIndex:0] isEqual:@"Tr"])
        {
            material.Alpha = [[words objectAtIndex:1] floatValue];
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"Tf"])
        {
            material.Alpha = ([[words objectAtIndex:1] floatValue] + [[words objectAtIndex:2] floatValue] + [[words objectAtIndex:3] floatValue]) /3.0f ;
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"map_Ka"])
        {
            VETexture* newTexture = [TextureDispatcher GetTextureByFileName:[[[words objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent]];
            material.AmbientMap = newTexture;
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"map_Kd"])
        {
            VETexture* newTexture = [TextureDispatcher GetTextureByFileName:[[[words objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent]];
            material.DiffuseMap = newTexture;
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"map_Ks"])
        {
            VETexture* newTexture = [TextureDispatcher GetTextureByFileName:[[[words objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent]];
            material.SpecularMap = newTexture;
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"map_Ke"])
        {
            VETexture* newTexture = [TextureDispatcher GetTextureByFileName:[[[words objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent]];
            material.EmissionMap = newTexture;
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"map_Ns"])
        {
            VETexture* newTexture = [TextureDispatcher GetTextureByFileName:[[[words objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent]];
            material.ShininessMap = newTexture;
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"map_d"])
        {
            VETexture* newTexture = [TextureDispatcher GetTextureByFileName:[[[words objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent]];
            material.TransparencyMap = newTexture;
            continue;
        }
        if([[words objectAtIndex:0] isEqual:@"map_Bump"])
        {
            VETexture* newTexture = [TextureDispatcher GetTextureByFileName:[[[words objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent]];
            material.BumpMap = newTexture;
            continue;
        }
    }
}

- (void)GenerateBuffers
{
    for(id key in m_buffers)
    {
        Buffer* buffer = [m_buffers objectForKey:key];
        float* modelData = (float*)calloc([buffer.Vertices count] * 8, sizeof(float));
        
        for(int i = 0; i < [buffer.Vertices count]; i++)
        {
            Vertex* currentVertex = [buffer.Vertices objectAtIndex:i];
            modelData[i * 8] = currentVertex.x;
            modelData[i * 8 + 1] = currentVertex.y;
            modelData[i * 8 + 2] = currentVertex.z;
            modelData[i * 8 + 3] = currentVertex.tu;
            modelData[i * 8 + 4] = currentVertex.tv;
            modelData[i * 8 + 5] = currentVertex.nx;
            modelData[i * 8 + 6] = currentVertex.ny;
            modelData[i * 8 + 7] = currentVertex.nz;
        }
        
        buffer.VertexCount = (unsigned int)buffer.Vertices.count;
        [buffer.Vertices removeAllObjects];
        
        GLuint ID;
        
        glGenVertexArraysOES(1, &ID);
        glBindVertexArrayOES(ID);
        
        buffer.VertexArrayID = ID;
        
        glGenBuffers(1, &ID);
        glBindBuffer(GL_ARRAY_BUFFER, ID);
        glBufferData(GL_ARRAY_BUFFER, sizeof(float) * buffer.VertexCount * 8, modelData, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 8, 0);
        
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 8, (unsigned char*)NULL + (3 * sizeof(float)));
        
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 8, (unsigned char*)NULL + (5 * sizeof(float)));
        
        buffer.VertexBufferID = ID;
        
        
        free(modelData);
    }
}

- (void)ReleaseBuffers
{
    for(id key in m_buffers)
    {
        Buffer* buffer = [m_buffers objectForKey:key];
        
        GLuint ID;
        
        // Release the vertex buffer.
        if (buffer.VertexBufferID)
        {
            ID = buffer.VertexArrayID;
            glBindBuffer(GL_ARRAY_BUFFER, 0);
            glDeleteBuffers(1, &ID);
        }
        
        // Release the VertexArray.
        if(buffer.VertexArrayID)
        {
            ID = buffer.VertexArrayID;
            glBindVertexArrayOES(0);
            glDeleteVertexArraysOES(1, &ID);
        }
        
        if(buffer.Material.AmbientMap)
            [TextureDispatcher ReleaseTexture:buffer.Material.AmbientMap];
        if(buffer.Material.DiffuseMap)
            [TextureDispatcher ReleaseTexture:buffer.Material.DiffuseMap];
        if(buffer.Material.SpecularMap)
            [TextureDispatcher ReleaseTexture:buffer.Material.SpecularMap];
        if(buffer.Material.EmissionMap)
            [TextureDispatcher ReleaseTexture:buffer.Material.EmissionMap];
        if(buffer.Material.ShininessMap)
            [TextureDispatcher ReleaseTexture:buffer.Material.ShininessMap];
        if(buffer.Material.TransparencyMap)
            [TextureDispatcher ReleaseTexture:buffer.Material.TransparencyMap];
        if(buffer.Material.BumpMap)
            [TextureDispatcher ReleaseTexture:buffer.Material.BumpMap];
        
    }
}

- (void)dealloc
{
    [self ReleaseBuffers];
}

@end
