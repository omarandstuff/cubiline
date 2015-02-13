#import "VEtext.h"

@implementation Letter
@end

@interface VEText()
{
	VETexture* m_fontTexture;
	NSMutableDictionary* m_lettersInf;
	NSString* m_fontName;
	float m_originalHeight;
	
	GLuint m_vertexBufferId;
	GLuint m_vertexArrayId;
	
	GLKMatrix4 m_mvpMatrix;
	
	float m_realWidth;
	
	GLuint m_numberOfVertex;
}

- (void)LoadFont;
- (void)InitBuffer;
- (void)GenerateByText;

- (void)ReleaseBuffers;

@end

@implementation VEText

@synthesize Text;
@synthesize TextureDispatcher;
@synthesize TextShader;
@synthesize ViewMatrix;
@synthesize ProjectionMatrix;
@synthesize FontSize;
@synthesize Width;
@synthesize Height;

- (id)initWithFontName:(NSString *)font
{
	return [self initWithFontName:font Text:@""];
}

- (id)initWithFontName:(NSString *)font Text:(NSString *)text
{
	self = [super init];
	
	if(self)
	{
		m_fontName = font;
		Text = text;
		
		[self LoadFont];
		[self GenerateByText];
	}
	
	return self;
	
}

- (void)Render
{
	// Get the PVM Matrix.
	m_mvpMatrix = GLKMatrix4Multiply(*ViewMatrix, m_finalMatrix);
	m_mvpMatrix = GLKMatrix4Multiply(*ProjectionMatrix, m_mvpMatrix);
	
	// Set the shader parameters.
	[TextShader Render:&m_mvpMatrix TextureID:m_fontTexture.TextureID Color:m_color.Vector Opasity:m_opasity.Value];
	
	// Bind the vertex array object that stored all the information about the vertex and index buffers.
	glBindVertexArrayOES(m_vertexArrayId);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glDisableVertexAttribArray(GLKVertexAttribNormal);
	
	// Draw call.
	glDrawArrays(GL_TRIANGLES, 0, m_numberOfVertex);
}

- (void)LoadFont
{
	NSString* fileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:m_fontName ofType:@"txt"] encoding:NSUTF8StringEncoding error:NULL];
	int lineNum = 0;
	
	NSString* textureFileName = [NSString stringWithFormat:@"%@.%@", m_fontName, @"png"];
	m_fontTexture = [TextureDispatcher GetTextureByFileName:textureFileName];
	
	m_lettersInf = [[NSMutableDictionary alloc] init];
	
	float textureW = m_fontTexture.Width;
	float textureH = m_fontTexture.Height;
	
	for (NSString* line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]])
	{
		if(lineNum == 0)
		{
			FontSize = [line floatValue];
			m_originalHeight = [line floatValue] / textureH;
			lineNum++;
			continue;
		}
		NSArray *words = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		words = [words filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
		
		if(![words count])
			continue;
		
		Letter* newLeter = [[Letter alloc] init];
		newLeter.CoordX = [[words objectAtIndex:0] floatValue] / textureW;
		newLeter.CoordY = [[words objectAtIndex:1] floatValue] / textureH;
		newLeter.Width = [[words objectAtIndex:2] floatValue] / textureW;
		newLeter.InRenderWith = [[words objectAtIndex:2] floatValue] / FontSize;
		
		NSString* lkey = [NSString stringWithFormat:@"%c" , (char)lineNum + 32];
		[m_lettersInf setObject:newLeter forKey:lkey];
		
		lineNum++;
	}
	
	Letter* newLeter = [[Letter alloc] init];
	newLeter.InRenderWith = 0.0f;
	
	[m_lettersInf setObject:newLeter forKey:@" "];
	
	m_scale.Vector = GLKVector3Make(FontSize, FontSize, 1.0);
	m_recalScale = true;

	[self InitBuffer];
}

- (void)setText:(NSString *)text
{
	Text = text;
	[self GenerateByText];
}

- (NSString*)Text
{
	return Text;
}

- (void)setFontSize:(float)size
{
	FontSize = size;
	Height = size;
	Width = m_realWidth * size;
	self.Scale = GLKVector3Make(FontSize, FontSize, 0.0f);
}

- (void)setWidth:(float)width
{
	[self setFontSize:width / m_realWidth];
}

- (float)Width
{
	return Width;
}

- (float)FontSize
{
	return FontSize;
}

- (void)InitBuffer
{
	GLfloat vertices[256 * 30];
	
	glGenVertexArraysOES(1, &m_vertexArrayId);
	glBindVertexArrayOES(m_vertexArrayId);
	
	glGenBuffers(1, &m_vertexBufferId);
	glBindBuffer(GL_ARRAY_BUFFER, m_vertexBufferId);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 5, 0);
	
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 5, (unsigned char*)NULL + (3 * sizeof(float)));
	
	glBindVertexArrayOES(0);
}

- (void)GenerateByText
{
	int stringSize = (int)[Text length];
	if(!stringSize) return;
	
	int whites = 0;
	
	for(int i = 0; i < stringSize; i++)
	{
		if([Text characterAtIndex:i] == 32)
			whites++;
	}
	
	m_numberOfVertex = (stringSize - whites) * 6;
	GLfloat vertices[(stringSize - whites) * 30];

	NSMutableArray* chars = [[NSMutableArray alloc] init];
	
	m_realWidth = 0.0f;
	
	for(int i = 0; i < stringSize; i++)
	{
		Letter* current = [m_lettersInf objectForKey:[NSString stringWithFormat:@"%c" , [Text characterAtIndex:i]]];
		[chars addObject:current];
		if(current.InRenderWith == 0.0f)
			m_realWidth += 0.15f;
		else
			m_realWidth += current.InRenderWith;
	}
	
	m_realWidth += 0.05f * (stringSize - 1);
	
	Width = m_realWidth * FontSize;
	
	GLfloat* verticesOffset = vertices;
	
	float XPos = -m_realWidth / 2.0f;
	
	for(int i = 0; i < stringSize; i++)
	{
		Letter* current = [chars objectAtIndex:i];
		
		if(current.InRenderWith == 0.0f)
		{
			XPos += 0.15f;
			continue;
		}
		
		GLfloat temp[30] =
		{
			XPos,							-0.5f, 0.0f,	current.CoordX,					current.CoordY + m_originalHeight,
			XPos,							 0.5f, 0.0f,	current.CoordX,					current.CoordY,
			XPos + current.InRenderWith,	-0.5f, 0.0f,	current.CoordX + current.Width, current.CoordY + m_originalHeight,
			XPos,							 0.5f, 0.0f,	current.CoordX,					current.CoordY,
			XPos + current.InRenderWith,	 0.5f, 0.0f,	current.CoordX + current.Width, current.CoordY,
			XPos + current.InRenderWith,	-0.5f, 0.0f,	current.CoordX + current.Width, current.CoordY + m_originalHeight
		};
		
		memcpy(verticesOffset, temp, sizeof(temp));
		verticesOffset += 30;
		
		XPos += current.InRenderWith + 0.05f;
	}
	
	glBindBuffer(GL_ARRAY_BUFFER, m_vertexBufferId);
	glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(vertices), vertices);
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
	[TextureDispatcher ReleaseTexture:m_fontTexture];
	m_fontTexture = nil;
}

- (void)dealloc
{
	[self ReleaseBuffers];
}

@end