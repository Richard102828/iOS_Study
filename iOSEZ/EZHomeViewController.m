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

#define kCellReuseIdentifier    @"EZHomeVCTableViewCell_Identifier"

#define kSection_0          @"核心动画"
#define kSection_1          @"SwiftUI"
#define kSection_2          @"并发"
#define kSection_3          @"音视频"

#define kSection_0_row_0    @"频繁的动画"
#define kSection_1_row_0    @"swift ui"
#define kSection_1_row_1    @"combine"
#define kSection_1_row_2    @"tca - uikit"
#define kSection_1_row_3    @"tca - swiftui"
#define kScetion_2_row_0    @"swift 并发"
#define kSection_3_row_0    @"音视频_1"


@interface EZHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSArray<NSString *> *> *> *datas;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EZHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // frame
    self.tableView.frame = self.view.bounds;
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
        ];
    }
    return _datas;
}

@end
