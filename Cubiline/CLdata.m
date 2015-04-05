#import "CLdata.h"

@interface CLData()
{
	bool m_highScoreLoaded;
	bool m_highScoreRequested;
	bool m_grownLoaded;
	bool m_grownRequested;
}

@end

@implementation CLData

@synthesize HighScore;
@synthesize Grown;
@synthesize Coins;
@synthesize GameCenter;
@synthesize Mute;
@synthesize Speed;
@synthesize Size = Size_;
@synthesize New;

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [self init];
	
	if (self)
	{
		HighScore = [decoder decodeIntForKey:@"HighScore"];
		Grown = [decoder decodeIntForKey:@"Grown"];
		Coins = [decoder decodeIntForKey:@"Coins"];
		Mute = [decoder decodeBoolForKey:@"Mute"];
		Speed = [decoder decodeIntForKey:@"Speed"];
		Size_ = [decoder decodeIntForKey:@"Size"];
		New = [decoder decodeBoolForKey:@"New"];
	}
	
	return self;
}

- (id)initWithGameCenter:(VEGameCenter*)gamecenter
{
	self  = [super init];
	
	if(self)
	{
		GameCenter = gamecenter;
	}
	
	return self;
}

- (void)Frame
{
	if(!GameCenter.PlayerAuthenticated)
	{
		m_highScoreLoaded = false;
		m_highScoreRequested = false;
		m_grownLoaded = false;
		m_grownRequested = false;
		return;
	}
	if([GameCenter.LoadedScores objectForKey:@"cubiline_high_score"] && !m_highScoreLoaded)
	{
		m_highScoreLoaded = true;
		int highscore = [[GameCenter.LoadedScores objectForKeyedSubscript:@"cubiline_high_score"] intValue];
		if(highscore < HighScore)
		{
			[GameCenter submitScore:HighScore category:@"cubiline_high_score"];
			[self save];
		}
		else
		{
			HighScore = highscore;
			[self save];
		}
	}
	else if(!m_highScoreRequested)
	{
		[GameCenter loadScoreOfCategory:@"cubiline_high_score"];
		m_highScoreRequested = true;
	}
	if([GameCenter.LoadedScores objectForKey:@"cubiline_total_eaten"] && !m_grownLoaded)
	{
		m_grownLoaded = true;
		int grown = [[GameCenter.LoadedScores objectForKeyedSubscript:@"cubiline_total_eaten"] intValue];
		if(grown < Grown)
		{
			[GameCenter submitScore:Grown category:@"cubiline_total_eaten"];
			[self save];
		}
		else
		{
			Grown = grown;
			[self save];
		}
	}
	else if(!m_grownRequested)
	{
		[GameCenter loadScoreOfCategory:@"cubiline_total_eaten"];
		m_grownRequested = true;
	}
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeInt:self.HighScore forKey:@"HighScore"];
	[encoder encodeInt:self.Grown forKey:@"Grown"];
	[encoder encodeInt:self.Coins forKey:@"Coins"];
	[encoder encodeBool:self.Mute forKey:@"Mute"];
	[encoder encodeInt:self.Speed forKey:@"Speed"];
	[encoder encodeInt:self.Size forKey:@"Size"];
	[encoder encodeBool:self.New forKey:@"New"];
}

+ (NSString*)filePath
{
	static NSString* filePath = nil;
	
	if (!filePath)
	{
		filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"gamedata"];
	}
	return filePath;
}

+ (id)loadInstanceWithGameCenter:(VEGameCenter*)gamecenter;
{
	NSData* decodedData = [NSData dataWithContentsOfFile: [CLData filePath]];
	if (decodedData)
	{
		CLData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
		gameData.GameCenter = gamecenter;
		return gameData;
	}
 
	return [[CLData alloc] initWithGameCenter:gamecenter];
}

-(void)save
{
	NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
	[encodedData writeToFile:[CLData filePath] atomically:YES];
}

- (void)setHighScore:(unsigned int)highscore
{
	if(highscore < HighScore) return;
	HighScore = highscore;
	[GameCenter submitScore:HighScore category:@"cubiline_high_score"];
	[self save];
}

- (unsigned int)HighScore
{
	return HighScore;
}

- (void)setGrown:(unsigned int)grown
{
	if(grown < Grown) return;
	Grown = grown;
	[GameCenter submitScore:Grown category:@"cubiline_total_eaten"];
	[self save];
}

- (unsigned int)Grown
{
	return Grown;
}

- (void)setCoins:(unsigned int)coins
{
	Coins = coins;
	[self save];
}

- (unsigned int)Coins
{
	return Coins;
}

- (void)setMute:(bool)mute
{
	Mute = mute;
	[self save];
}

- (bool)Mute
{
	return Mute;
}

- (void)setSize:(unsigned int)size
{
	Size_ = size;
	[self save];
}

- (unsigned int)Size
{
	return Size_;
}

- (void)setSpeed:(unsigned int)speed
{
	Speed = speed;
	[self save];
}

- (unsigned int)Speed
{
	return Speed;
}

- (void)setNew:(bool)new
{
	New = new;
	[self save];
}

- (bool)New
{
	return New;
}

@end
