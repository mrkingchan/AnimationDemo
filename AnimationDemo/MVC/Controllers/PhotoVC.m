
//
//  PhotoVC.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/30.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "PhotoVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoCell.h"
#import "PhotoGroupVC.h"

#import <MWPhotoBrowser.h>
#import <MWPhoto.h>
#import <MWPhotoProtocol.h>
#import "PreViewVC.h"
#import "WaterFallVC.h"

@interface PhotoVC ()<MWPhotoBrowserDelegate> {
    ALAssetsLibrary *_lib;
    NSMutableArray *_dataArray;
    UICollectionView *_collectionView;
    NSMutableArray *_photos;
}

@end

@implementation PhotoVC

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count) {
        return _photos[index];
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _photos = [NSMutableArray new];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSStringFromClass([self class]);
    if (!_fromGroup) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSStringFromClass([PhotoGroupVC class]) style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSStringFromClass([WaterFallVC class]) style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    }
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 10)/3.0, ([UIScreen mainScreen].bounds.size.width - 10)/3.0);
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    _dataArray = [NSMutableArray new];
    
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *tipStr = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        NSLog(@"%@",tipStr);
        return ;
    }
    
    _lib = [[ALAssetsLibrary alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_lib enumerateGroupsWithTypes:ALAssetsGroupAll
                            usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                if (group) {
                                    ALAssetsFilter *filter = [ALAssetsFilter allAssets];//包括照片和视频
                                    [group setAssetsFilter:filter];
                                    if (group.numberOfAssets > 0) {
                                        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                            //判断asset的类型(照片、视频)
                                            if (result) {
                                                [_dataArray addObject:result];
                                            }
                                        }];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [_collectionView reloadData];
                                        });
                                    }
                                } else {
                                    if (_dataArray.count > 0) {
                                        NSLog(@"photos = %@",_dataArray);
                                    } else {
                                        NSLog(@"相册资源为空!");
                                    }
                                }
                            } failureBlock:^(NSError *error) {
                                NSLog(@"Asset group not found,error = %@",error);
                            }];
    });
}

- (void)next:(id)sender {
    if (_fromGroup) {
        PhotoGroupVC *VC = [PhotoGroupVC new];
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        WaterFallVC *VC = [WaterFallVC new];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark --UICollectionViewDataSource&delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- ( __kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setCellWithData:_dataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (_fromGroup) {
        PreViewVC *VC = [PreViewVC new];
        VC.currentIndex = indexPath.row;
        
        __block NSMutableArray *temArray = [NSMutableArray new];
        [_dataArray enumerateObjectsUsingBlock:^(ALAsset *value, NSUInteger idx, BOOL * _Nonnull stop) {
            [temArray addObject:[UIImage imageWithCGImage:[ value thumbnail]]];
        }];
        
        VC.dataArray = temArray;
        [self.navigationController pushViewController:VC animated:YES];
        
    } else {
        
        __block NSMutableArray *temArray = [NSMutableArray new];
        [_dataArray enumerateObjectsUsingBlock:^(ALAsset *value, NSUInteger idx, BOOL * _Nonnull stop) {
            MWPhoto *photo = [MWPhoto photoWithImage:[UIImage imageWithCGImage:[ value thumbnail]]];
            [temArray addObject:photo];
        }];
        _photos = [NSMutableArray arrayWithArray:temArray];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        
        browser.displayActionButton = YES;
        browser.displayNavArrows = NO;
        browser.displaySelectionButtons = NO;
        browser.zoomPhotosToFill = YES;
        browser.alwaysShowControls = NO;
        browser.enableGrid = YES;
        browser.startOnGrid = NO;
        browser.autoPlayOnAppear = NO;
        browser.customImageSelectedIconName = @"ImageSelected.png";
        browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
        [browser setCurrentPhotoIndex:indexPath.row];
        [self.navigationController pushViewController:browser animated:YES];
    }
}


@end
