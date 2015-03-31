#import "VEads.h"

@interface VEAds()
{
	NSMutableArray* m_unityAdsVideoCompletedSelector;
}

@end

@implementation VEAds
@synthesize PresentingFullScreen;

- (id)init
{
	self = [super init];
	
	if(self)
	{
		m_unityAdsVideoCompletedSelector = [[NSMutableArray alloc] init];
	}
	
	return self;
}

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

- (void)setUnityRewardedZone
{
	[[UnityAds sharedInstance] setZone:@"rewardedVideoZone"];
}

- (void)AddunityAdsVideoCompletedObjectResponder:(id)object
{
	[m_unityAdsVideoCompletedSelector addObject:object];
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
	for(id object in m_unityAdsVideoCompletedSelector)
	{
		SEL selector = @selector(unityAdsVideoCompleted:skipped:);
		IMP imp = [object methodForSelector:selector];
		void (*func)(id, SEL, NSString*, BOOL) = (void *)imp;
		func(object, selector, rewardItemKey, skipped);
	}
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