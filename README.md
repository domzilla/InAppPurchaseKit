# InAppPurchaseKit

**A Swift wrapper around StoreKit2 with full Objective-C support.**

InAppPurchaseKit bridges the gap between Apple's Swift-first StoreKit2 APIs and Objective-C codebases. Every class is `@objc`-annotated, giving you type-safe access to products, subscriptions, transactions, and entitlements from Objective-C.

| Platform | Minimum Version |
|----------|----------------|
| iOS      | 15.6+          |
| macOS    | 12.4+          |

## Features

- Load and display in-app purchase products
- Purchase consumables, non-consumables, and auto-renewable subscriptions
- Observe transaction updates in real time
- Query current entitlements and transaction history
- Manage subscriptions (renewal state, grace period, expiration reason)
- Introductory and promotional offer support
- Refund request handling (iOS)
- App Store environment detection (sandbox, production, Xcode)
- Privacy manifest included (`PrivacyInfo.xcprivacy`)

## Installation

InAppPurchaseKit is distributed as an Xcode project reference. Add `src/InAppPurchaseKit.xcodeproj` to your workspace and link `InAppPurchaseKit.framework` in your target's build phases.

```objc
#import <InAppPurchaseKit/InAppPurchaseKit.h>
```

## Usage

### Start Observing Transactions

Set up the transaction observer as early as possible after app launch:

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[IAPTransactionObserver shared] startObservingUpdates];
    return YES;
}
```

### Load Products

```objc
NSArray *identifiers = @[@"com.example.consumable", @"com.example.subscription.yearly"];

[IAPProduct productsFor:identifiers completionHandler:^(NSArray<IAPProduct *> *products, NSError *error) {
    if (!error) {
        self.products = products;

        for (IAPProduct *product in products) {
            NSLog(@"%@ — %@", product.displayName, product.displayPrice);
        }
    }
}];
```

### Purchase a Product

```objc
IAPProduct *product = self.products[indexPath.row];

[product purchaseWithCompletionHandler:^(IAPTransaction *transaction, IAPPurchaseResult result, NSError *error) {
    switch (result) {
        case IAPPurchaseResultSuccess:
            NSLog(@"Purchased: %@", product.displayName);
            break;
        case IAPPurchaseResultPending:
            NSLog(@"Purchase pending approval");
            break;
        case IAPPurchaseResultUserCancelled:
            NSLog(@"User cancelled");
            break;
        default:
            NSLog(@"Error: %@", error);
            break;
    }
}];
```

### Check Entitlements

```objc
[IAPTransaction currentEntitlementsWithCompletionHandler:^(NSArray<IAPTransaction *> *transactions) {
    for (IAPTransaction *transaction in transactions) {
        NSLog(@"Entitled: %@ (expires: %@)", transaction.productID, transaction.expirationDate);
    }
}];
```

### Subscription Status

```objc
[IAPSubscriptionInfo statusForGroupID:@"your_group_id" completionHandler:^(NSArray<IAPSubscriptionStatus *> *statuses) {
    for (IAPSubscriptionStatus *status in statuses) {
        NSLog(@"State: %ld, Auto-renew: %@", (long)status.state, status.willAutoRenew ? @"YES" : @"NO");
    }
}];
```

### Manage Subscriptions

```objc
[IAPAppStore showManageSubscriptionsIn:windowScene];
```

## API Overview

| Class | Purpose |
|-------|---------|
| `IAPProduct` | Load products, initiate purchases, check entitlements |
| `IAPTransaction` | Transaction data, history, finishing, and refund requests |
| `IAPTransactionObserver` | Listen for real-time transaction updates |
| `IAPSubscriptionInfo` | Subscription group details, period, and offers |
| `IAPSubscriptionStatus` | Renewal state, auto-renew, expiration reason |
| `IAPSubscriptionPeriod` | Billing cycle unit and value |
| `IAPSubscriptionOffer` | Introductory and promotional offer details |
| `IAPOffer` | Offer type and payment mode |
| `IAPAppStore` | Environment detection, manage subscriptions, request review |
| `IAPError` | StoreKit error code mapping |

## Example Project

An Objective-C example app is included in `example/` demonstrating product loading, purchasing, and entitlement checking.

## License

MIT License. See [LICENSE](LICENSE) for details.
