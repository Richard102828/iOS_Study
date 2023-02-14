//
//  AppDelegate.h
//  iOSEZ
//
//  Created by ezrealzhang on 2023/2/2.
//

#import <UIKit/UIKit.h>
#import "EZHomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
/// 后续可以用来跟踪 vc
@property (nonatomic, strong) UINavigationController *mainNavVC;
@property (nonatomic, strong) EZHomeViewController *rootVC;

@end

