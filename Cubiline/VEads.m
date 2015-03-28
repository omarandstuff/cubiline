#import "VEads.h"

@interface VEAds()
{
	
}

@end

@implementation VEAds
@synthesize PresentingFullScreen;

+ (instancetype)loadSaredVEAdsWithViewController:(UIViewController*)viewcontroller
{
	[[UnityAds sharedInstance] startWithGameId:@"28162" andViewController:viewcontroller];
	[[UnityAds sharedInstance] setDelegate:[VEAds sharedVEAds]];
	
	return [VEAds sharedVEAds];
}

+ (instancetype)sharedVEAds
{
	static VEAds* sharedVEAds;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{sharedVEAds = [[VEAds alloc] init];});

	return sharedVEAds;
}

- (bool)unityAdsCanShow
{
	return [[UnityAds sharedInstance] canShow] && [[UnityAds sharedInstance] canShowAds];
}

- (void)presentUnityAd
{
	if ([[UnityAds sharedInstance] canShow] && [[UnityAds sharedInstance] canShowAds])
		[[UnityAds sharedInstance] show];
}

- (void)unityAdsDidHide
{
	
}

- (void)unityAdsDidShow
{
	
}

- (void)unityAdsFetchCompleted
{
	
}

- (void)unityAdsFetchFailed
{
	
}

- (void)unityAdsVideoCompleted:(NSString *)rewardItemKey skipped:(BOOL)skipped
{
	
}

- (void)unityAdsVideoStarted
{
	
}

- (void)unityAdsWillHide
{
	PresentingFullScreen = false;
}

- (void)unityAdsWillLeaveApplication
{
	
}

- (void)unityAdsWillShow
{
	PresentingFullScreen = true;
}

- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd
{
	
}

- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
	
}

- (void)interstitialAdWillLoad:(ADInterstitialAd *)interstitialAd
{
	
}

- (void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd\
{
	
}

- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
	
}

- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
	
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	
}

@end