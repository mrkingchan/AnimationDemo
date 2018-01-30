//
//  PhotoGroupVC.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/30.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "PhotoGroupVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "GroupCell.h"
#import "GroupDetailVC.h"

@interface PhotoGroupVC ()<UITableViewDelegate,UITableViewDataSource> {
    ALAssetsLibrary *_lib;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
}
@end

@implementation PhotoGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSStringFromClass([self class]);
    
    _dataArray = [NSMutableArray new];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *tipStr = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        NSLog(@"%@",tipStr);
        return ;
    }
    
    _lib = [[ALAssetsLibrary alloc] init];
    [_lib enumerateGroupsWithTypes:ALAssetsGroupAll
                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                            if (group) {
                                [_dataArray addObject:group];
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [_tableView reloadData];
                            });
                        } failureBlock:^(NSError *error) {
                            NSLog(@"Asset group not found,error = %@",error);
                        }];
    
}

#pragma mark --UITableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kcellID = @"kcellID";
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellID];
    if (!cell) {
        cell = [[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kcellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellWithData:_dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ALAssetsGroup *group = _dataArray[indexPath.row];
    GroupDetailVC *VC = [GroupDetailVC new];
    VC.group = group;
    [self.navigationController pushViewController:VC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
    
}
@end
