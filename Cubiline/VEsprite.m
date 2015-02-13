#import "VEsprite.h"

@interface VESprite()
{
	GLuint m_vertexBufferId;
	GLuint m_vertexArrayId;
    
    GLKMatrix4 m_mvpMatrix;
	
	float m_widthAspect;
	float m_heightAspect;
}

- (void)CreateBuffers:(float)cx CutY:(float)cy CutWidth:(float)cw CutHeight:(float)ch SourceWidth:(float)width SourceHeight:(float)height;
- (void)ReleaseBuffers;

@end

@implementation VESprite

@synthesize Texture;
@synthesize TextureShader;
@synthesize ColorShader;
@synthesize TextureDispatcher;
@synthesize ProjectionMatrix;
@synthesize ViewMatrix;
@synthesize TextureWidth;
@synthesize TextureHeight;
@synthesize Width;
@synthesize Height;
@synthesize LockAspect;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        m_vertexBufferId = 0;
        m_vertexArrayId = 0;
		
        TextureWidth = 1;
        TextureHeight = 1;
        
        [self CreateBuffers:0.0f CutY:0.0f CutWidth:1.0f CutHeight:1.0f SourceWidth:1.0f SourceHeight:1.0f];
    }
    
    return self;
}

- (id)initFromTexture:(VETexture*)texture
{
    self = [super init];
    
    if (self)
    {
        m_vertexBufferId = 0;
        m_vertexArrayId = 0;
        
        Texture = texture;
        [self CreateBuffers:0.0f CutY:0.0f CutWidth:Texture.Width CutHeight:Texture.Height SourceWidth:Texture.Width SourceHeight:Texture.Height];
    }
    
    return self;
}

- (id)initFromFileName:(NSString*)filename;
{
	return [self initFromTexture:[TextureDispatcher GetTextureByFileName:filename]];
}

- (void)Render
{
    // Get the PVM Matrix.
    m_mvpMatrix = GLKMatrix4Multiply(*ViewMatrix, m_finalMatrix);
    m_mvpMatrix = GLKMatrix4Multiply(*ProjectionMatrix, m_mvpMatrix);
    
	// Set the shader parameters.
	if(Texture)
		[TextureShader Render:&m_mvpMatrix TextureID:Texture.TextureID TextureCompression:m_textureCompression.Vector Color:m_color.Vector Opasity:m_opasity.Value];
	else
		[ColorShader Render:&m_mvpMatrix Color:m_color.Vector Opasity:m_opasity.Value];
    
    // Bind the vertex array object that stored all the information about the vertex and index buffers.
	glBindVertexArrayOES(m_vertexArrayId);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glDisableVertexAttribArray(GLKVertexAttribNormal);

	// Draw call.
	glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void)setWidth:(float)width
{
	Width = width;
	if(LockAspect)
		Height = m_heightAspect * Width;
	self.Scale = GLKVector3Make(Width, Height, 0.0f);
}

- (float)Width
{
	return Width;
}

- (void)setHeight:(float)height
{
	Height = height;
	if(LockAspect)
		Width = m_widthAspect * Height;
	self.Scale = GLKVector3Make(Width, Height, 0.0f);
}

- (float)Height
{
	return Height;
}

- (void)CreateBuffers:(float)cx CutY:(float)cy CutWidth:(float)cw CutHeight:(float)ch SourceWidth:(float)width SourceHeight:(float)height
{
	GLfloat vertices[30] =
	{
		-0.5f, -0.5f, 0.0f,		cx / width, ch / height + cy / height,
		-0.5f, 0.5f, 0.0f,		cx / width, cy / height,
		0.5f, -0.5f, 0.0f,		cw / width + cx / width, ch / height + cy / height,
		-0.5f, 0.5f, 0.0f,		cx / width, cy / height,
		0.5f, 0.5f, 0.0f,		cw / width + cx / width, cy / height,
		0.5f, -0.5f, 0.0f,		cw / width + cx / width, ch / height + cy / height
	};
	
	// Set size
	Width = cw;
	Height = ch;
	
	TextureWidth = width;
	TextureHeight = Height;
	
	m_widthAspect = Width / Height;
	m_heightAspect = Height / Width;
	
	m_scale.Vector = GLKVector3Make(Width, Height, 1.0);
    m_recalScale = true;
	
	glGenVertexArraysOES(1, &m_vertexArrayId);
	glBindVertexArrayOES(m_vertexArrayId);
	
	glGenBuffers(1, &m_vertexBufferId);
	glBindBuffer(GL_ARRAY_BUFFER, m_vertexBufferId);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 5, 0);
	
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 5, (unsigned char*)NULL + (3 * sizeof(float)));
	
	glBindVertexArrayOES(0);
}

- (void)ReleaseBuffers
{
	// Release the vertex buffer.
	if (m_vertexBufferId)
	{
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glDeleteBuffers(1, &m_vertexBufferId);
	}
	
	// Release the VertexArray.
	if(m_vertexArrayId)
	{
		glBindVertexArrayOES(0);
		glDeleteVertexArraysOES(1, &m_vertexArrayId);
	}
	
	m_vertexArrayId = 0;
	m_vertexBufferId = 0;
	
	// Release texture.
	[TextureDispatcher ReleaseTexture:Texture];
	Texture = nil;
}

- (void)dealloc
{
	[self ReleaseBuffers];
}

@end
