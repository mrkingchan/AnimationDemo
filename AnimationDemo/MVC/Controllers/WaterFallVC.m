//
//  WaterFallVC.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/31.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "WaterFallVC.h"
#import "WatwerLayout.h"
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define RGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define RandColor RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface WaterFallVC ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;
}

@end

@implementation WaterFallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    WatwerLayout *layout = [WatwerLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

#pragma mark --UICollectionViewDataSource&delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 29;
}

- ( __kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = RandColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


@end
