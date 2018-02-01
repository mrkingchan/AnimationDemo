//
//  WatwerLayout.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/31.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "WatwerLayout.h"

@implementation WatwerLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _attrsArray = [NSMutableArray new];
    }
    return self;
}

#warning 必须调用这个方法
- (void)prepareLayout {
    [super prepareLayout];
    
    [_attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i ++) {
        UICollectionViewLayoutAttributes *attri = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [_attrsArray addObject:attri];
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _attrsArray;
}

#warning 如果不设置这个的话 collectionView就不能滑动
-(CGSize)collectionViewContentSize {
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    int index = ceilf(count / 6.0);
    NSInteger left = count % 6;
    CGFloat sectionH = 3 * 5 +  (2 *((self.collectionView.frame.size.width - 5)/2.0));
    CGFloat itemH = (self.collectionView.frame.size.width - 5)/2.0;
    return CGSizeMake(0, sectionH * index + (left/6.0 * itemH));
    /*NSInteger rows = (count + 3 - 1) / 3.0;
    CGFloat rowH = (self.collectionView.frame.size.width - 5) / 2.0;
    if ((count)%6==2 || (count)%6==4) {
        return CGSizeMake(0, rows * rowH-rowH/2);
    } else {
        return CGSizeMake(0, rows*rowH );
    }*/
}

//重写每个cell的layoutAttris布局属性
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat width = (self.collectionView.frame.size.width - 5.0)/2.0;
    CGFloat kGap = 5.0;
    CGFloat height = width;
    NSInteger i = indexPath.row;
    if (i==0) {
        attrs.frame = CGRectMake(0, 0, width, height);
    } else if (i==1) {
        attrs.frame = CGRectMake(width + kGap, 0, width, height/2);
    } else if (i==2) {
        attrs.frame = CGRectMake(width + kGap, height/2 + kGap, width, height/2);
    } else if (i==3) {
        attrs.frame = CGRectMake(0, height + kGap, width, height/2);
    } else if (i==4) {
        attrs.frame = CGRectMake(width + kGap, height + kGap + kGap, width, height);
    } else if (i==5) {
        attrs.frame = CGRectMake(0, height + (height / 2.0) + (2 * kGap), width, height/2.0);
    } else {
        //6个就完成一个循环，以此类推
        UICollectionViewLayoutAttributes *lastAttrs = _attrsArray[i-6];
        CGRect frame = lastAttrs.frame;
        frame.origin.y =  frame.origin.y +  (2 * height) + (3 * kGap);
        attrs.frame = frame;
    }
    return attrs;
}
@end
