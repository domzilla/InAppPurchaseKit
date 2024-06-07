//
//  ViewController.m
//  IAP Test
//
//  Created by Dominic Rodemer on 02.06.24.
//

#import "ViewController.h"

#import "ProductsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.productIDs = @[@"net.domzilla.iaptest.consumable.product1",
                            @"net.domzilla.iaptest.nunconsumable.product1",
                            @"net.domzilla.iaptest.nonrenewing.subscription1",
                            @"net.domzilla.iaptest.subscriptions.subscription1.yearly",
                            @"net.domzilla.iaptest.subscriptions.subscription1.monthly",
                            @"net.domzilla.iaptest.subscriptions.subscription2.yearly",
                            @"net.domzilla.iaptest.subscriptions.subscription2.monthly",
                            @"net.domzilla.iaptest.subscriptions.subscription2.upgrade.yearly",
                            @"net.domzilla.iaptest.subscriptions.subscription2.upgrade.monthly"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(transactionDidFinishNotification:)
                                                     name:IAPTransaction.TransactionDidFinishNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    /*
    [IAPSubscriptionInfo statusForGroupID:@"21478861"
                          completionHandler:^(NSArray<IAPSubscriptionStatus *> *statuses, NSError *error) {
        for (IAPSubscriptionStatus *status in statuses)
        {
            NSLog(@"%@", status);
        }
        NSLog(@"Error: %@", error);
    }];
     */
}

- (IBAction)loadProductsButtonAction:(id)sender
{
    if ([self.products count] > 0)
    {
        ProductsViewController *vc = [[ProductsViewController alloc] initWithProducts:self.products];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [self startLoading];
    
    NSDate *date = [NSDate date];
    [IAPProduct productsFor:self.productIDs
            completionHandler:^(NSArray<IAPProduct *> * _Nullable products, NSError * _Nullable error) {
        
        self.products = products;
        
        NSLog(@"Products:");
        for (IAPProduct *product in self.products)
        {
            NSLog(@"--------");
            NSLog(@"%@", [product description]);
        }
        NSLog(@"Error: %@", error);
        
        NSLog(@"Execution time: %f", [[NSDate date] timeIntervalSinceDate:date]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ProductsViewController *vc = [[ProductsViewController alloc] initWithProducts:self.products];
            [self.navigationController pushViewController:vc animated:YES];
            [self stopLoading];
        });
    }];
}

- (IBAction)latestTransactionsButtonAction:(id)sender
{
    [self startLoading];
    
    NSDate *date = [NSDate date];
    [IAPTransaction latestForProductIDs:self.productIDs
                        completionHandler:^(NSArray<IAPTransaction *> *transactions) {
        
        NSLog(@"Latest Transactions:");
        
        dispatch_semaphore_t s = dispatch_semaphore_create(0);
        
        for (IAPTransaction *transaction in transactions)
        {
            NSLog(@"--------");
            NSLog(@"%@", [transaction description]);
            NSLog(@"---");
            
            [transaction subscriptionStatusWithCompletionHandler:^(IAPSubscriptionStatus *status) {
                NSLog(@"%@", [status description]);
                dispatch_semaphore_signal(s);
            }];
            
            dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
        }
        
        NSLog(@"Execution time: %f", [[NSDate date] timeIntervalSinceDate:date]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopLoading];
        });
    }];
}

- (IBAction)currentEntitlementsButtonAction:(id)sender
{
    [self startLoading];
    
    NSDate *date = [NSDate date];
    [IAPTransaction currentEntitlementsWithCompletionHandler:^(NSArray<IAPTransaction *> *transactions) {
        
        NSLog(@"Current Entitlements:");
        dispatch_semaphore_t s = dispatch_semaphore_create(0);
        
        for (IAPTransaction *transaction in transactions)
        {
            NSLog(@"--------");
            NSLog(@"%@", [transaction description]);
            NSLog(@"...");
            
            [transaction subscriptionStatusWithCompletionHandler:^(IAPSubscriptionStatus *status) {
                NSLog(@"%@", [status description]);
                dispatch_semaphore_signal(s);
            }];
            
            dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
        }
        
        NSLog(@"Execution time: %f", [[NSDate date] timeIntervalSinceDate:date]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopLoading];
        });
    }];
}

- (IBAction)restorePurchasesButtonAction:(id)sender
{
    [IAPAppStore syncWithCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark Private
#pragma mark ---
- (void)startLoading
{
    self.contentView.userInteractionEnabled = NO;
    self.contentView.layer.opacity = 0.5;
    [self.activityIndicator startAnimating];
}

- (void)stopLoading
{
    self.contentView.userInteractionEnabled = YES;
    self.contentView.layer.opacity = 1.0;
    [self.activityIndicator stopAnimating];
}

#pragma mark IAPTransaction Notifications
#pragma mark ---
- (void)transactionDidFinishNotification:(NSNotification *)notification
{
    NSLog(@"--------");
    NSLog(@"Transaction did finish:");
    IAPTransaction *transaction = (IAPTransaction *)notification.object;
    NSLog(@"%@", [transaction description]);
}

@end
