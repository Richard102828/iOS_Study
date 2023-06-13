

//
//  AppDelegate.m
//  iOSEZ
//
//  Created by ezrealzhang on 2023/2/2.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "iOSEZ-Swift.h"
#import "GlobleDefines.h"

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
    self.mainNavVC = [self setupMainNavVC];
    self.window.rootViewController = self.mainNavVC;
}

- (UINavigationController *)setupMainNavVC {
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:self.rootVC];
    self.rootVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(navigationBack)];
    self.rootVC.navigationItem.title = @"navigation";
    return nvc;
}

- (void)navigationBack {
    
}

- (void)setupPods {
    // pods init
    [SVProgressHUD setMinimumDismissTimeInterval:0.3];
}


@end
