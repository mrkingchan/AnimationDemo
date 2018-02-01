//
//  WaterVC.m
//  AnimationDemo
//
//  Created by Chan on 2018/2/1.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "WaterVC.h"
#import "WaterLayout.h"

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define RandColor RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface WaterVC ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterLayoutDelegate> {
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;
}

@end

@implementation WaterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray new];
    WaterLayout *layout = [WaterLayout new];
    layout.delegate = self;
    for (int i = 0; i < 100; i ++) {
        [_dataArray  addObject:@(50 + i)];
    }
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

#pragma mark --UICollectionViewDataSource&delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- ( __kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = RandColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark --WaterFlowDelegate
-(CGFloat)waterflowLayout:(WaterLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    NSNumber *height = _dataArray[index];
    return [height doubleValue];
}

-(NSInteger)columnCountInWaterflowLayout:(WaterLayout *)waterflowLayout {
    return 3;
}
-(CGFloat)columnMarginInWaterflowLayout:(WaterLayout *)waterflowLayout {
    return 5;
}

-(CGFloat)rowMarginInWaterflowLayout:(WaterLayout *)waterflowLayout {
    return 5;
}

-(UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterLayout *)waterflowLayout {
    return UIEdgeInsetsZero;
}
@end
