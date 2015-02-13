#import "VEtexturedispatcher.h"

@implementation TextureHolder
@end

@interface VETextureDispatcher()
{
	NSMutableDictionary* m_textures;
}
@end

@implementation VETextureDispatcher

- (id)init
{
	self = [super init];
	
	if(self)
	{
		m_textures = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}
- (VETexture*)GetTextureByFileName:(NSString*)filename
{
	TextureHolder* currentTexture = [m_textures objectForKey:filename];
	if(currentTexture)
	{
		currentTexture.Active++;
		return currentTexture.Texture;
	}
	
	currentTexture = [[TextureHolder alloc] init];
	currentTexture.Active = 1;
	currentTexture.Texture = [[VETexture alloc] initFromFile:filename];
	
	[m_textures setObject:currentTexture forKey:filename];
	
	return currentTexture.Texture;
}

- (void)ReleaseTexture:(VETexture*)texture
{
	TextureHolder* currentTexture = [m_textures objectForKey:texture.FileName];
	
	if(currentTexture)
	{
		if(currentTexture.Active == 1)
			[m_textures removeObjectForKey:currentTexture.Texture.FileName];
		else
			currentTexture.Active--;
	}
}

@end
