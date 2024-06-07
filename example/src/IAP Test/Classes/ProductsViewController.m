//
//  ProductsViewController.m
//  IAP Test
//
//  Created by Dominic Rodemer on 06.06.24.
//

#import "ProductsViewController.h"

#import "ProductViewController.h"

@interface ProductsViewController ()

@end

@implementation ProductsViewController

- (id)initWithProducts:(NSArray<IAPProduct *> *)products
{
    if (self = [super initWithStyle:UITableViewStylePlain])
    {
        self.title = @"Products";
        self.products = products;
    }
    
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [self.products count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *resuseIdentifier = @"ProductsViewControllerReuseIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:resuseIdentifier];
    }
    
    IAPProduct *product = [self.products objectAtIndex:indexPath.row];
    cell.textLabel.text = product.displayName;
    cell.detailTextLabel.text = product.displayPrice;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IAPProduct *product = [self.products objectAtIndex:indexPath.row];
    ProductViewController *vc = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    vc.product = product;
    vc.title = product.displayName;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
