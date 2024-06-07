//
//  SceneDelegate.m
//  IAP Test
//
//  Created by Dominic Rodemer on 02.06.24.
//

#import "SceneDelegate.h"

#import "ViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions 
{
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    
    ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nvc;
    
    [self.window makeKeyAndVisible];
}

@end
