#ifndef Cubiline_VEads_h
#define Cubiline_VEads_h

#import <iAd/iAd.h>
#import <UnityAds/UnityAds.h>

@interface VEAds : NSObject<ADBannerViewDelegate, ADInterstitialAdDelegate, UnityAdsDelegate>
@property bool PresentingFullScreen;

+ (instancetype)loadSaredVEAdsWithViewController:(UIViewController*)viewcontroller;
+ (instancetype)sharedVEAds;

- (bool)unityAdsCanShow;
- (void)presentUnityAd;
- (void)setUnityRewardedZone;

- (void)AddunityAdsVideoCompletedObjectResponder:(id)object;


@end

#endif
