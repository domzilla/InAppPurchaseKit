# InAppPurchaseKit
### Leverage StoreKit2 APIs in your Objective-C codebase.

InAppPurchaseKit is a Swift wrapper around the StoreKit2 APIs with full Obj-C support.

# Usage

Setup the transaction observer as early as possible after app launch:

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	[[IAPTransactionObserver shared] startObservingUpdates];
	
	return YES;
}
```

Load your products:

```objc
[IAPProduct productsFor:@[@"net.domzilla.iaptest.consumable.product1",
					      @"net.domzilla.iaptestsubscriptions.subscription1.yearly"]
	completionHandler:^(NSArray<IAPProduct *> * _Nullable products, NSError * _Nullable error) {
	
	if (!error)
		self.products = products;
	else
		NSLog(@"Error: %@", error);
}];
```

Purchase:

```objc
IAPProduct *product = [self.products objectAtIndex:i];
[product purchaseWithCompletionHandler:^(IAPTransaction * _Nullable transaction, IAPPurchaseResult result, NSError * _Nullable error) {
	
	if (result == IAPPurchaseResultSuccess)
		NSLog(@"Purchased Product: %@ \n\nTransaction: %@", product.displayName, transaction.description);
	else if (result == IAPPurchaseResultPending)
		NSLog(@"Purchase of %@ is Pending", product.displayName);
	else if (result == IAPPurchaseResultUserCancelled)
		NSLog(@"Purchase of %@ has been caceled by user", product.displayName);
	else
		NSLog(@"Error: %@", error);
}];
```
Check for current entitlements:

```objc
[IAPTransaction currentEntitlementsWithCompletionHandler:^(NSArray<IAPTransaction *> *transactions) {

	NSLog(@"Current Entitlements:");
	for (IAPTransaction *transaction in transactions)
	{
		NSLog(@"%@", [transaction description]);
	}
}];
```

Also have a look at the example project!