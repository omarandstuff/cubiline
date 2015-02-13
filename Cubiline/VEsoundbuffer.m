#import "VEsoundbuffer.h"

@interface VESoundBuffer ()
{
    void *m_rawAudioData;
}

- (void)LoadSound;
- (void)GenerateAudioBuffer:(UInt32)audiosize SampleRate:(UInt32)samplerate Format:(ALenum)format;
- (void)ReleaseBuffer;

@end

@implementation VESoundBuffer

@synthesize SoundBufferID;
@synthesize FileName;

- (id)initWithFileName:(NSString*)filename
{
    self  = [super init];
    
    if(self)
    {
        FileName = filename;
        [self LoadSound];
    }
    
    return self;
}

- (void)LoadSound
{
    NSString* partFileName = [FileName substringToIndex:[FileName length] - 4];
    NSString* partFileNameType = [FileName substringFromIndex:[partFileName length] + 1];
    NSURL *audioFileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:partFileName ofType:partFileNameType]];
    
    AudioFileID afid;
    OSStatus openAudioFileResult = AudioFileOpenURL((__bridge CFURLRef)audioFileURL, kAudioFileReadPermission, 0, &afid);

    if (openAudioFileResult != 0)
        NSLog(@"An error occurred when attempting to open the audio file %@: %d", FileName, (int)openAudioFileResult);
    
    UInt64 property = 0;
    UInt32 propertySize = sizeof(UInt64);
    
    OSStatus getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propertySize, &property);
    
    if (0 != getSizeResult)
        NSLog(@"An error occurred when attempting to determine the size of audio file.");
    
    UInt32 audioFileSizeInBytes = (UInt32)property;
    
    m_rawAudioData = malloc(audioFileSizeInBytes);
    
    OSStatus readBytesResult = AudioFileReadBytes(afid, false, 0, &audioFileSizeInBytes, m_rawAudioData);
    
    if (0 != readBytesResult)
        NSLog(@"An error occurred when attempting to read data from audio file %@: %d", FileName, (int)readBytesResult);
    
    AudioStreamBasicDescription audioFormat;
    UInt32 audioFormatSize = sizeof(audioFormat);
    
    OSStatus getSampleResult = AudioFileGetProperty(afid, kAudioFilePropertyDataFormat, &audioFormatSize, &audioFormat);
    
    if (0 != getSampleResult)
        NSLog(@"An error occurred when attempting to read sample rate from audio file %@: %d", FileName, (int)readBytesResult);
    
    AudioFileClose(afid);
    
    ALenum format;
    if(audioFormat.mChannelsPerFrame == 1)
    {
        if(audioFormat.mBitsPerChannel == 8)
            format = AL_FORMAT_MONO8;
        else
            format = AL_FORMAT_MONO16;
    }
    else
    {
        if(audioFormat.mBitsPerChannel == 8)
            format = AL_FORMAT_STEREO8;
        else
            format = AL_FORMAT_STEREO16;
    }
    
    [self GenerateAudioBuffer:audioFileSizeInBytes SampleRate:audioFormat.mSampleRate Format:format];
}

- (void)GenerateAudioBuffer:(UInt32)audiosize SampleRate:(UInt32)samplerate Format:(ALenum)format
{
    alGenBuffers(1, &SoundBufferID);
    
    // Copy the audio data into the output buffer.
    alBufferData(SoundBufferID, format, m_rawAudioData, audiosize, samplerate);
    
    if (m_rawAudioData)
    {
        free(m_rawAudioData);
        m_rawAudioData = NULL;
    }
}

- (void)ReleaseBuffer
{
    if(SoundBufferID)
        alDeleteBuffers(1, &SoundBufferID);
}

- (void)dealloc
{
    [self ReleaseBuffer];
}

@end