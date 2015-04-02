#import "VEinapppurchase.h"

@interface VEIAPurchase()
{
	SKProductsRequest* m_productsRequest;
}

- (void)requestProducts:(NSSet*)productIdentifiers;

@end

@implementation VEIAPurchase

@synthesize Products;

+ (instancetype)sharedVEIAPurchase
{
	static VEIAPurchase* sharedVEIAPurchase;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{sharedVEIAPurchase = [[VEIAPurchase alloc] initWithProductIdentifiers:[NSSet setWithObjects:@"cubiline_10000_coins", nil]];});
	
	return sharedVEIAPurchase;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
	self = [super init];
	
	if (self)
	{
		Products = [[NSMutableDictionary alloc] init];
		
		[self requestProducts:productIdentifiers];
		
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	return self;
	
}

- (void)requestProducts:(NSSet*)productIdentifiers
{
	m_productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
	m_productsRequest.delegate = self;
	[m_productsRequest start];
}

- (void)buyProduct:(SKProduct *)product
{
	SKPayment * payment = [SKPayment paymentWithProduct:product];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	m_productsRequest = nil;
	
	for (SKProduct * product in response.products)
	{
		[Products setObject:product forKey:product.productIdentifier];
	}
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction * transaction in transactions)
	{
		SKPaymentTransactionState st = transaction.transactionState;
		NSLog(@"%@", transaction.error);
		switch (st)
		{
			case SKPaymentTransactionStatePurchased:
				break;
			case SKPaymentTransactionStateFailed:
				break;
			case SKPaymentTransactionStateRestored:
			default:
				break;
		}
	};
}

@end