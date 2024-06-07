//
//  ViewController.h
//  IAP Test
//
//  Created by Dominic Rodemer on 02.06.24.
//

#import <UIKit/UIKit.h>

#import <InAppPurchaseKit/InAppPurchaseKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) NSArray *productIDs;
@property (nonatomic, strong) NSArray<IAPProduct *> *products;

@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

