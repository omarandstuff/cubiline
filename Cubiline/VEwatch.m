#import "VEwatch.h"

@interface VEWatch()
{
	float m_limit;
	
	float m_totalTimeC;
}

- (NSString*)NumberTime:(unsigned int)number;
- (NSString*)CentnumberTime:(unsigned)number;
@end

@implementation VEWatch

@synthesize Style = Style_;
@synthesize Active;

- (bool)Frame:(float)time
{
	if(!Active)return true;
	
	if(Style_ == VE_WATCH_STYLE_REVERSE)
	{
		m_totalTimeC -= (time * 100.0f);
		
		if(m_totalTimeC <= 0.0f)
		{
			m_totalTimeC = 0.0f;
			Active = false;
			return true;
		}
	}
	else
	{
		m_totalTimeC += (time * 100.0f);
		
		if(Style_ == VE_WATCH_STYLE_LIMITED && m_totalTimeC >= m_limit)
		{
			m_totalTimeC = m_limit;
			Active = false;
			return true;
		}
	}
	return true;
}

- (void)setStyle:(enum VE_WATCH_STYLE)style
{
	Style_ = style;
	Active = true;
}

- (enum VE_WATCH_STYLE)Style

{
	return Style_;
}

- (void)Reset
{
	if(Style_ == VE_WATCH_STYLE_REVERSE)
		m_totalTimeC = m_limit;
	else
		m_totalTimeC = 0.0f;
	
	Active = true;
}

- (void)ResetInCentseconds:(float)centeseconds
{
	m_totalTimeC = centeseconds;
	Active = true;
}

- (void)ResetInSeconds:(float)seconds
{
	m_totalTimeC = seconds * 100.0f;
	Active = true;
}

- (void)ResetInMinutes:(float)minutes
{
	m_totalTimeC = minutes * 6000.0f;
	Active = true;
}

- (void)ResetInHours:(float)hours
{
	m_totalTimeC = hours * 360000.0f;
	Active = true;
}

- (void)SetLimitInCentseconds:(float)centseconds
{
	m_limit = centseconds;
	Active = true;
}

- (void)SetLimitInSeconds:(float)seconds
{
	m_limit = seconds * 100.0f;
	Active = true;
}

- (void)SetLimitInMinutes:(float)minutes
{
	m_limit = minutes * 6000.0f;
	Active = true;
}

- (void)SetLimitInHours:(float)hours
{
	m_limit = hours * 360000.0f;
	Active = true;
}

- (NSString*)GetTimeString:(enum VE_WATCH_STRING_FORMAT)format
{
	float css = fmodf(m_totalTimeC, 360000.0f);
	
	unsigned int hours = m_totalTimeC / 360000.0f;;
	unsigned int minutes = css / 6000.0f;
	
	css = fmodf(css, 6000.0f);
	
	unsigned int seconds = css / 100.0f;
	unsigned int centseconds = fmodf(css, 100.0f);
	
	if(format == VE_WATCH_STRING_FORMAT_CENTSECONDS)
		return [NSString stringWithFormat:@"%@", [self CentnumberTime:centseconds]];
	else if (format == VE_WATCH_STRING_FORMAT_SECONDS)
		return [NSString stringWithFormat:@"%@", [self NumberTime:seconds]];
	else if (format == VE_WATCH_STRING_FORMAT_MINUTES)
		return [NSString stringWithFormat:@"%@", [self NumberTime:minutes]];
	else if (format == VE_WATCH_STRING_FORMAT_HOURS)
		return [NSString stringWithFormat:@"%@", [self NumberTime:hours]];
	else if (format == VE_WATCH_STRING_FORMAT_SECONDS_CENTSECONDS)
		return [NSString stringWithFormat:@"%@:%@", [self NumberTime:seconds], [self CentnumberTime:centseconds]];
	else if (format == VE_WATCH_STRING_FORMAT_MINUTES_SECONDS)
		return [NSString stringWithFormat:@"%@:%@", [self NumberTime:minutes], [self NumberTime:hours]];
	else if (format == VE_WATCH_STRING_FORMAT_MINUTES_SECONDS_CENTSECONDS)
		return [NSString stringWithFormat:@"%@:%@:%@", [self NumberTime:minutes], [self NumberTime:seconds], [self CentnumberTime:centseconds]];
	else if (format == VE_WATCH_STRING_FORMAT_HOURS_MINUTES)
		return [NSString stringWithFormat:@"%@:%@", [self NumberTime:hours], [self NumberTime:minutes]];
	else if (format == VE_WATCH_STRING_FORMAT_HOURS_MINUTES_SECONDS)
		return [NSString stringWithFormat:@"%@:%@:%@", [self NumberTime:hours], [self NumberTime:minutes], [self NumberTime:seconds]];
	else if (format == VE_WATCH_STRING_FORMAT_HOURS_MINUTES_SECONDS_CENTSECONDS)
		return [NSString stringWithFormat:@"%@:%@:%@:%@", [self NumberTime:hours], [self NumberTime:minutes], [self NumberTime:seconds], [self CentnumberTime:centseconds]];
	return nil;
}

- (NSString*)NumberTime:(unsigned int)number
{
	if(number < 10)
		return [NSString stringWithFormat:@"0%d", number];
	else
		return [NSString stringWithFormat:@"%d", number];
}

- (NSString*)CentnumberTime:(unsigned)number
{
	if(number < 10)
		return [NSString stringWithFormat:@"00%d", number];
	else if(number < 100)
		return [NSString stringWithFormat:@"0%d", number];
	else
		return [NSString stringWithFormat:@"%d", number];
}

- (float)GetTotalTimeinCentseconds
{
	return m_totalTimeC;
}

- (float)GetTotalTimeinSeconds
{
	return m_totalTimeC / 100.0f;
}

- (float)GetTotalTimeinMinutes
{
	return m_totalTimeC / 6000.0f;
}

- (float)GetTotalTimeinHours
{
	return m_totalTimeC / 360000.0f;
}

@end