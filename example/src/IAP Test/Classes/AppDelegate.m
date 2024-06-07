//
//  AppDelegate.m
//  IAP Test
//
//  Created by Dominic Rodemer on 02.06.24.
//

#import "AppDelegate.h"

#import <InAppPurchaseKit/InAppPurchaseKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    [[IAPTransactionObserver shared] startObservingUpdates];
    
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options 
{
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions 
{

}

@end
