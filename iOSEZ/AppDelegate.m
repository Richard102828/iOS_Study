

//
//  AppDelegate.m
//  iOSEZ
//
//  Created by ezrealzhang on 2023/2/2.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

// @ezrealzhang 这块改了之后没用啊，后面再看看 vc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // root vc
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self changeRootVC];
    [self.window makeKeyAndVisible];
    
    [self setupPods];
    
    return YES;
}

#pragma mark - other

- (void)changeRootVC {
    self.rootVC = [[EZHomeViewController alloc] init];
    self.mainNavVC = [[UINavigationController alloc] initWithRootViewController:self.rootVC];
    self.window.rootViewController = self.mainNavVC;
}

- (void)setupPods {
    // pods init
    [SVProgressHUD setMinimumDismissTimeInterval:0.3];
}


@end
