//
//  ProductsViewController.h
//  IAP Test
//
//  Created by Dominic Rodemer on 06.06.24.
//

#import <UIKit/UIKit.h>

#import <InAppPurchaseKit/InAppPurchaseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductsViewController : UITableViewController

@property (nonatomic, strong) NSArray<IAPProduct *> *products;

- (id)initWithProducts:(NSArray<IAPProduct *> *)products;

@end

NS_ASSUME_NONNULL_END
