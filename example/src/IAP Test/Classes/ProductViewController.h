//
//  ProductViewController.h
//  IAP Test
//
//  Created by Dominic Rodemer on 06.06.24.
//

#import <UIKit/UIKit.h>

#import <InAppPurchaseKit/InAppPurchaseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductViewController : UIViewController

@property (nonatomic, strong) IAPProduct *product;

@end

NS_ASSUME_NONNULL_END
