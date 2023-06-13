//
//  EZHomeViewController.m
//  iOSEZ
//
//  Created by ezrealzhang on 2023/2/14.
//

#import "EZHomeViewController.h"

#import "EZFrequentlyAnimationViewController.h"
#import "SVProgressHUD.h"
#import "iOSEZ-Swift.h"
#import "GlobleDefines.h"

#define kCellReuseIdentifier    @"EZHomeVCTableViewCell_Identifier"

#define kSection_0          @"核心动画"
#define kSection_1          @"SwiftUI"
#define kSection_2          @"并发"
#define kSection_3          @"音视频"
#define kSection_4          @"push/present vc"
#define kSection_last       @"temp_test"

#define kSection_0_row_0    @"频繁的动画"
#define kSection_1_row_0    @"swift ui"
#define kSection_1_row_1    @"combine"
#define kSection_1_row_2    @"tca - uikit"
#define kSection_1_row_3    @"tca - swiftui"
#define kScetion_2_row_0    @"swift 并发"
#define kSection_3_row_0    @"音视频_1"
#define kSection_4_row_0    @"push/pop"
#define kSection_4_row_1    @"present/dismiss"
#define kSection_last_row_0 @"navc push navc"


@interface EZHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSArray<NSString *> *> *> *datas;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EZHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.tableView];
//    [self setupTestNavigationBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // frame
    self.tableView.frame = self.view.bounds;
}

- (void)setupTestNavigationBar {
        // test
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.navigationController.navigationBar.frame.size.height)];
    UINavigationItem *item1 = [[UINavigationItem alloc] initWithTitle:@"new"];
    item1.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back_1" menu:nil];
    UINavigationItem *item2 = [[UINavigationItem alloc] initWithTitle:@"old"];
    item2.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back_2" menu:nil];
    bar.items = @[item1, item2];
//    [bar pushNavigationItem:[[UINavigationItem alloc] initWithTitle:@"other"] animated:YES];
    
    [self.view addSubview:bar];
//    nvc.navigationBar.items = @[[[UINavigationItem alloc] initWithTitle:@"new"], self.rootVC.navigationItem];
//    [nvc.navigationBar pushNavigationItem:[[UINavigationItem alloc] initWithTitle:@"new"] animated:YES];
//    nvc.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
    [EZLogger logWithTag:NSStringFromClass(EZHomeViewController.class) content:[NSString stringWithFormat:@"navigation item count: %lu, top: %@, back: %@", (unsigned long)bar.items.count, [bar.topItem title], [bar.backItem title]]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datas objectAtIndex:section].allValues.firstObject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    cell.textLabel.text = [[self.datas objectAtIndex:indexPath.section].allValues.firstObject objectAtIndex:indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.datas objectAtIndex:section].allKeys.firstObject;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // @ezrealzhang todo
    NSString *title = [[self.datas objectAtIndex:indexPath.section].allValues.firstObject objectAtIndex:indexPath.row];
    if ([title isEqualToString:kSection_0_row_0]) {
        // @ezrealzhang todo
        EZFrequentlyAnimationViewController *vc = [[EZFrequentlyAnimationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:kSection_1_row_1]) {
        EZCombineViewController *vc = [[EZCombineViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:kSection_1_row_2]) {
        EZTCAViewController *vc = [[EZTCAViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:kSection_1_row_3]) {
        EZTCASwiftUIViewController *vc = [[EZTCASwiftUIViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:kSection_4_row_0]) {
        EZPushTestViewController *vc = [[EZPushTestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:kSection_4_row_1]) {
        EZPresentTestViewController *vc = [[EZPresentTestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:kSection_last_row_0]) {
        // test - 这里会 crash
        EZPresentTestViewController *vc = [[EZPresentTestViewController alloc] init];
        [self.navigationController pushViewController: [[UINavigationController alloc] initWithRootViewController:vc] animated:YES];
    } else {
        [SVProgressHUD showInfoWithStatus:@"尚未实现"];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
        _tableView = tableView;
    }
    return _tableView;
}
    
- (NSArray<NSDictionary<NSString *, NSArray<NSString *> *> *> *)datas {
    if (!_datas) {
        _datas = @[
            @{kSection_0 : @[
                kSection_0_row_0,
            ]},
            @{kSection_1 : @[
                kSection_1_row_0,
                kSection_1_row_1,
                kSection_1_row_2,
                kSection_1_row_3,
            ]},
            @{kSection_2 : @[
                kScetion_2_row_0,
            ]},
            @{kSection_3 : @[
                kSection_3_row_0,
            ]},
            @{kSection_4 : @[
                kSection_4_row_0,
                kSection_4_row_1,
            ]},
            @{kSection_last : @[
                kSection_last_row_0,
            ]},
        ];
    }
    return _datas;
}

@end
