#ifndef Cubiline_VEinapppurchase_h
#define Cubiline_VEinapppurchase_h

#import <StoreKit/StoreKit.h>

@interface VEIAPurchase : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (readonly)NSMutableDictionary* Products;

+ (instancetype)sharedVEIAPurchase;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)buyProduct:(SKProduct *)product;


@end

#endif
