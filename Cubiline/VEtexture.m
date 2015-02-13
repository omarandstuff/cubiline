#import "VEtexture.h"

@interface VETexture()
{
	unsigned char* m_rawPixels;
	bool m_repeat;
}

- (void)CreateFromFile:(NSString*)filename;
- (void)GenerateForBufferType:(GLenum)buffertype;
- (void)GenerateTexture;
- (void)ReleaseTexture;

@end

@implementation VETexture

@synthesize TextureID;
@synthesize Width;
@synthesize Height;
@synthesize FileName;

- (id)initForBufferType:(GLenum)buffertype Width:(GLint)width Height:(GLint)height
{
    self = [super init];
    
    if(self)
    {
        TextureID = 0;
        m_rawPixels = 0;
        Width = width;
        Height = height;
		if(Width == Height) m_repeat = true;
        [self GenerateForBufferType:buffertype];
    }
    
    return self;
}

-(id)initFromFile:(NSString*)filename
{
	self = [super init];
	
	if(self)
	{
		TextureID = 0;
		Width = 0;
		Height = 0;
		m_rawPixels = 0;
		[self CreateFromFile:filename];
	}
	
	return self;
}

- (void)CreateFromFile:(NSString*)filename
{
	// Load the image.
	CGImageRef spriteImage = [UIImage imageNamed:filename].CGImage;
	if (!spriteImage)
	{
		NSLog(@"Failed to load image %@", filename);
		FileName = nil;
		exit(1);
	}
	
	FileName = filename;
 
	// Set the size
	Width = (unsigned int)CGImageGetWidth(spriteImage);
	Height = (unsigned int)CGImageGetHeight(spriteImage);
	
	if(Width == Height) m_repeat = true;
 
	m_rawPixels = (GLubyte *) calloc(Width * Height * 4, sizeof(GLubyte));
 
	CGContextRef spriteContext = CGBitmapContextCreate(m_rawPixels, Width, Height, 8, Width * 4, CGImageGetColorSpace(spriteImage), (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
 
	CGContextDrawImage(spriteContext, CGRectMake(0, 0, Width, Height), spriteImage);
	CGContextRelease(spriteContext);
	
	[self GenerateTexture];
	
	if(m_rawPixels) free(m_rawPixels);
	m_rawPixels = 0;
}

- (void)GenerateForBufferType:(GLenum)buffertype
{
    // Generate an ID for the texture.
    glGenTextures(1, &TextureID);
    
    // Bind the texture as a 2D texture.
    glBindTexture(GL_TEXTURE_2D, TextureID);
    
    // Use linear filetring
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    // Clamp
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);


    // Allocate the data for the texture.
    if(buffertype == GL_DEPTH_ATTACHMENT)
        glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT,  Width, Height, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_INT, NULL);
    else
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,  Width, Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
}

- (void)GenerateTexture
{
	// Generate an ID for the texture.
	glGenTextures(1, &TextureID);
	
	// Bind the texture as a 2D texture.
	glBindTexture(GL_TEXTURE_2D, TextureID);
	
	// Load the image data into the texture unit.
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, Width, Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, m_rawPixels);
	
	// Use linear filetring
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
	// Repeat?
	if(m_repeat)
	{
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	}
	else
	{
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	}

	// Generate mipmaps for the texture.
	glGenerateMipmap(GL_TEXTURE_2D);
}

- (void)ReleaseTexture
{
	if(TextureID)
		glDeleteTextures(1, &TextureID);
	
	Width = 0;
	Height = 0;
	TextureID = 0;
}

- (void)dealloc
{
	[self ReleaseTexture];
}


@end
