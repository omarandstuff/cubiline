#import "VEeffect1.h"

@interface VEEffect1()
{
	float m_originValue;
	float m_targetValue;
	int m_direction;
	
	bool m_translationByTime;
	
	float m_transTargTime;
	float m_transTime;
	float m_currentTime;
	float m_transSpeed;
	
	float m_transDist;
	float m_transF;
	float m_transTime1;
	float m_transTime2;
	float m_transDist1;
	
	float m_transoffset;
}

- (void)CalculateEase:(bool)bytime Length:(float)length Speed:(float)speed Ease:(float)ease Distance:(float)distance TargetTimeOut:(float*)tagettimeout SpeedOut:(float*)speedout FactorOut:(float*)fout time1Out:(float*)time1out Time2Out:(float*)time2out Distance1Out:(float*)dist1out;
- (void)CalculateEndEase:(bool)bytime Length:(float)length Speed:(float)speed Ease:(float)ease Distance:(float)distance TargetTimeOut:(float*)tagettimeout SpeedOut:(float*)speedout FactorOut:(float*)fout time1Out:(float*)time1out Time2Out:(float*)time2out Distance1Out:(float*)dist1out;
- (void)CalculateBeginEase:(bool)bytime Length:(float)length Speed:(float)speed Ease:(float)ease Distance:(float)distance TargetTimeOut:(float*)tagettimeout SpeedOut:(float*)speedout FactorOut:(float*)fout time1Out:(float*)time1out Time2Out:(float*)time2out Distance1Out:(float*)dist1out;
@end

@implementation VEEffect1

@synthesize TransitionEffect;
@synthesize Value;
@synthesize TransitionTime;
@synthesize TransitionSpeed;
@synthesize Ease;
@synthesize IsActive;

- (id)init
{
	self = [super init];
	
	if(self)
	{
		TransitionEffect = VE_TRANSITION_EFFECT_NONE;
		
		Value = 0.0f;
		m_originValue = 0.0f;
		m_targetValue = 0.0f;
		
		IsActive = false;
		m_translationByTime = true;
		TransitionTime = 0.1f;
		TransitionSpeed = 10.0;
		Ease = 0.5f;
		return self;
	}
	
	return nil;
}

- (void)Frame:(float)time
{
	if (IsActive) // It's translating let's get down to business.
	{
		m_currentTime += time;
		if (TransitionEffect == VE_TRANSITION_EFFECT_END_SUPER_SMOOTH) time *= (1.00001f - m_transoffset / m_transDist);
		m_transTime += time;
		
		if (TransitionEffect == VE_TRANSITION_EFFECT_HARD || TransitionEffect == VE_TRANSITION_EFFECT_END_SUPER_SMOOTH) // Just evaluate the offset by the speed.
		{
			if (m_transTime >= m_transTargTime)
			{
				Value = m_targetValue;
				m_originValue = Value;
				m_currentTime = 0.0f;
				IsActive = false;
				return;
			}
			m_transoffset = m_transSpeed * m_transTime;
		}
		if (TransitionEffect == VE_TRANSITION_EFFECT_EASE || TransitionEffect == VE_TRANSITION_EFFECT_END_EASE || TransitionEffect == VE_TRANSITION_EFFECT_BEGIN_EASE) // Evaluate in the 3 stages or 1 if it is the case.
		{
			if (m_transTime < m_transTime1) // First Parabole from 0 to the fisrt point.
			{
				m_transoffset = m_transF * pow(m_transTime, 2);
			}
			else if (m_transTime >= m_transTargTime) // Finalize and set at the target position.
			{
				Value = m_targetValue;
				m_originValue = Value;
				m_currentTime = 0.0f;
				IsActive = false;
				return;
			}
			else if (m_transTime >= m_transTime2) // Second parabole from the second point to target time.
			{
				m_transoffset = m_transDist - m_transF * pow(m_transTime - m_transTargTime, 2);
			}
			else // If it is the case just evaluate by the speed.
			{
				m_transoffset = m_transSpeed * m_transTime - m_transDist1;
			}
		}
		Value = m_originValue + m_transoffset * m_direction;
	}
}

- (void)CalculateEase:(bool)bytime Length:(float)length Speed:(float)speed Ease:(float)ease Distance:(float)distance TargetTimeOut:(float*)tagettimeout SpeedOut:(float*)speedout FactorOut:(float*)fout time1Out:(float*)time1out Time2Out:(float*)time2out Distance1Out:(float*)dist1out
{
	if (bytime) // Set by if it is by time or speed.
	{
		*tagettimeout = length;
	}
	else
	{
		*speedout = speed;
		*tagettimeout = distance / *speedout;
	}
	
	if (ease == 0.5f) // Just set the F for the parabole equations.
	{
		float factorDT = distance / *tagettimeout;
		*fout = (2.0f / *tagettimeout) * factorDT;
		*time1out = *tagettimeout * 0.5f;
		*time2out = *time1out;
	}
	else // All that stuff.
	{
		float factor = 1.0f / ease;
		float factorDT = distance / *tagettimeout;
		*fout = (factor / *tagettimeout) * factorDT;
		
		float Ftime2 = 2.0f * *fout * *tagettimeout;
		*time1out = (Ftime2 - sqrt(pow(Ftime2, 2) - (8.0f * *fout * distance))) / (4.0f * *fout);
		*time2out = tagettimeout - time1out;
		
		*dist1out = *fout * pow(*time1out, 2);
		*speedout = (distance - *dist1out * 2.0f) / (*tagettimeout - *time1out * 2.0f);
	}
}

- (void)CalculateEndEase:(bool)bytime Length:(float)length Speed:(float)speed Ease:(float)ease Distance:(float)distance TargetTimeOut:(float*)tagettimeout SpeedOut:(float*)speedout FactorOut:(float*)fout time1Out:(float*)time1out Time2Out:(float*)time2out Distance1Out:(float*)dist1out
{
	if (bytime) // Set by if it is by time or speed.
	{
		*tagettimeout = length;
	}
	else
	{
		*speedout = speed;
		*tagettimeout = distance / *speedout;
	}
	
	if (ease == 1.0f) // Just set the F for the final parabole equation.
	{
		float factorDT = distance / *tagettimeout;
		*fout = (1.0 / *tagettimeout) * factorDT;
		*time1out = 0.0;
		*time2out = 0.0;
	}
	else // All that stuff.
	{
		float factor = 1.0f / ease;
		float factorDT = distance / *tagettimeout;
		*fout = (factor / *tagettimeout) * factorDT;
		
		*time1out = 0.0f;
		*time2out = sqrt(((*fout * pow(*tagettimeout, 2)) - distance) / *fout);;
		
		*dist1out = 0.0f;
		
		float dist = distance - *fout * pow(*time2out - *tagettimeout, 2);
		*speedout = dist / *time2out;
	}
}

- (void)CalculateBeginEase:(bool)bytime Length:(float)length Speed:(float)speed Ease:(float)ease Distance:(float)distance TargetTimeOut:(float*)tagettimeout SpeedOut:(float*)speedout FactorOut:(float*)fout time1Out:(float*)time1out Time2Out:(float*)time2out Distance1Out:(float*)dist1out
{
	if (bytime) // Set by if it is by time or speed.
	{
		*tagettimeout = length;
	}
	else
	{
		*speedout = speed;
		*tagettimeout = distance / *speedout;
	}
	
	if (ease == 1.0f) // Just set the F for the begin parabole equation.
	{
		float factorDT = distance / *tagettimeout;
		*fout = (1.0f / *tagettimeout) * factorDT;
		*time1out = *tagettimeout;
		*time2out = *tagettimeout;
	}
	else // All that stuff.
	{
		float factor = 1.0f / ease;
		float factorDT = distance / *tagettimeout;
		*fout = (factor / *tagettimeout) * factorDT;
		
		*time1out = *tagettimeout - sqrt(((*fout * pow(*tagettimeout, 2)) - distance) / *fout);
		*time2out = *tagettimeout;
		
		*dist1out = *fout * pow(*time1out, 2);
		*speedout = (distance - *dist1out) / (*tagettimeout - *time1out);
		
	}
}

- (void)setValue:(float)value
{
    // If is the same value do nothing.
    if (m_targetValue == value) return;
    
    // Get the target value
    m_targetValue = value;
    
    // The current value is now the origin value.
    m_originValue = Value;
    
    if (TransitionEffect == VE_TRANSITION_EFFECT_NONE) // Just translate in one step.
    {
        Value = value;
        m_originValue = Value;
        m_targetValue = Value;
        return;
    }
    else
    {
        // It is translading now!!!.
        IsActive = true;
        
        // Time 0 to translation.
        m_transTime = 0.0f;
        m_transoffset = 0.0f;
        
        // Calculate the direction of the translation.
        m_transDist = m_targetValue - m_originValue;
        m_direction = m_transDist < 0 ? -1 : 1;
        m_transDist = fabsf(m_transDist);
        
        if (TransitionEffect == VE_TRANSITION_EFFECT_HARD || TransitionEffect == VE_TRANSITION_EFFECT_END_SUPER_SMOOTH)// Set the speed and time for the translation.
        {
            // Set by if it is by time or speed.
            if (m_translationByTime)
            {
                m_transTargTime = TransitionTime;
                m_transSpeed = m_transDist / m_transTargTime;
            }
            else
            {
                m_transSpeed = TransitionSpeed;
                m_transTargTime = m_transDist / m_transSpeed;
            }
        }
        else if (TransitionEffect == VE_TRANSITION_EFFECT_EASE) // Set the parabole factors and find the tangent points.
        {
            [self CalculateEase:m_translationByTime Length:TransitionTime Speed:TransitionSpeed Ease:Ease Distance:m_transDist TargetTimeOut:&m_transTargTime SpeedOut:&m_transSpeed FactorOut:&m_transF time1Out:&m_transTime1 Time2Out:&m_transTime2 Distance1Out:&m_transDist1];
        }
        else if (TransitionEffect == VE_TRANSITION_EFFECT_END_EASE) // Evaluate in the point to tangent.
        {
            [self CalculateEndEase:m_translationByTime Length:TransitionTime Speed:TransitionSpeed Ease:Ease Distance:m_transDist TargetTimeOut:&m_transTargTime SpeedOut:&m_transSpeed FactorOut:&m_transF time1Out:&m_transTime1 Time2Out:&m_transTime2 Distance1Out:&m_transDist1];
        }
        else if (TransitionEffect == VE_TRANSITION_EFFECT_BEGIN_EASE) // Evaluate in the tangent to point.
        {
            [self CalculateBeginEase:m_translationByTime Length:TransitionTime Speed:TransitionSpeed Ease:Ease Distance:m_transDist TargetTimeOut:&m_transTargTime SpeedOut:&m_transSpeed FactorOut:&m_transF time1Out:&m_transTime1 Time2Out:&m_transTime2 Distance1Out:&m_transDist1];
        }
    }
}

- (float)Value
{
    return Value;
}

- (void)setTransitionTime:(float)time
{
	m_translationByTime = true;
	TransitionTime = time;
}

- (float)TransitionTime
{
	return TransitionTime;
}

- (void)setTransitionSpeed:(float)speed
{
	m_translationByTime = false;
	TransitionSpeed = speed;
}

- (float)TransitionSpeed
{
	return TransitionSpeed;
}

- (void)Reset
{
	IsActive = false;
	m_originValue = 0.0f;
	m_targetValue = m_originValue;
	Value = m_originValue;
	m_transTargTime = 0.0f;
}

- (void)Reset:(float)state
{
	IsActive = false;
	m_originValue = state;
	m_targetValue = state;
	Value = state;
	m_transTargTime = 0.0f;
}

@end
