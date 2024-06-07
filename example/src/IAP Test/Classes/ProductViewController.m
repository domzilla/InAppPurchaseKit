//
//  ProductViewController.m
//  IAP Test
//
//  Created by Dominic Rodemer on 06.06.24.
//

#import "ProductViewController.h"

@interface ProductViewController ()

@end

@implementation ProductViewController

- (IBAction)purchaseButtonAction:(id)sender
{
    [self.product purchaseWithConfirmIn:self.view.window.windowScene
                      completionHandler:^(IAPTransaction * _Nullable transaction, IAPPurchaseResult result, NSError * _Nullable error) {
        
        if (result == IAPPurchaseResultSuccess)
        {
            NSLog(@"--------");
            NSLog(@"Purchased Product: %@", self.product.displayName);
            NSLog(@"---");
            NSLog(@"Transaction:");
            NSLog(@"%@", transaction.description);
        }
        else if (result == IAPPurchaseResultPending)
        {
            NSLog(@"--------");
            NSLog(@"Purchase of Product: %@ is Pending", self.product.displayName);
        }
        else if (result == IAPPurchaseResultUserCancelled)
        {
            NSLog(@"--------");
            NSLog(@"Purchase of Product: %@ has been caceled by user", self.product.displayName);
        }
        else
        {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (IBAction)currentEntitlementButtonAction:(id)sender
{
    [self.product currentEntitlementWithCompletionHandler:^(IAPTransaction * _Nullable transaction) {
        NSLog(@"--------");
        NSLog(@"Current Entitlement for: %@", self.product.displayName);
        NSLog(@"%@", transaction.description);
    }];
}

- (IBAction)latestTransactionButtonAction:(id)sender
{
    [self.product latestTransactionWithCompletionHandler:^(IAPTransaction * _Nullable transaction) {
        NSLog(@"--------");
        NSLog(@"Latest Transaction for: %@", self.product.displayName);
        NSLog(@"%@", transaction.description);
    }];
}

- (IBAction)refundRequestButtonAction:(id)sender
{
    [self.product latestTransactionWithCompletionHandler:^(IAPTransaction * _Nullable transaction) {
        if (!transaction)
        {
            NSLog(@"Product was never purchased. Refund not possible");
        }
            
        dispatch_async(dispatch_get_main_queue(), ^{
            [transaction beginRefundRequestIn:self.view.window.windowScene
                            completionHandler:^(IAPRefundRequestStatus status, NSError * _Nullable error) {
                NSLog(@"--------");
                NSLog(@"Refund request status: %ld for: %@", (long)status, self.product.displayName);
                NSLog(@"Error: %@", error);
            }];
        });
    }];
}

@end
