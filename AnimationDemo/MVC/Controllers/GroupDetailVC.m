//
//  GroupDetailVC.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/30.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "GroupDetailVC.h"
#import "PhotoCell.h"
#define kcellID @"cell"

#import "PhotoVC.h"

#import <MWPhotoBrowser.h>
#import <MWPhoto.h>
#import <MWPhotoProtocol.h>

@interface GroupDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,MWPhotoBrowserDelegate> {
    NSMutableArray *_dataArray;
    UICollectionView *_collectionView;
    NSMutableArray *_photos;
}

@end

@implementation GroupDetailVC

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
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSStringFromClass([PhotoVC class]) style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    
    _dataArray = [NSMutableArray new];
    if (_group) {
        [_group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [_dataArray addObject:result];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
            });
        }];
    }
    [self setUI];
}

- (void)next:(id)sender {
    PhotoVC *VC = [PhotoVC new];
    VC.fromGroup = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark --setUI
- (void)setUI {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 10)/3.0, ([UIScreen mainScreen].bounds.size.width - 10)/3.0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:kcellID];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
}

#pragma mark --UICollectionViewDataSource&delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- ( __kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellID forIndexPath:indexPath];
    [cell setCellWithData:_dataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    __block NSMutableArray *temArray = [NSMutableArray new];
    [_dataArray enumerateObjectsUsingBlock:^(ALAsset *value, NSUInteger idx, BOOL * _Nonnull stop) {
        MWPhoto *photo = [MWPhoto photoWithImage:[UIImage imageWithCGImage:[ value thumbnail]]];
        [temArray addObject:photo];
    }];
    _photos = [NSMutableArray arrayWithArray:temArray];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = YES;
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


@end
