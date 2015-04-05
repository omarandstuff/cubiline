#ifndef Cubiline_CLlanguage_h
#define Cubiline_CLlanguage_h

#import <UIKit/UIKit.h>

@interface CLLAnguage : NSObject
@property (readonly)NSString* Language;
@property (readonly)NSMutableDictionary* GameStrings;

+ (instancetype)sharedCLLanguage;

- (NSString*)stringForKey:(NSString*)key;

@end

#endif
