//
//  WaterLayout.m
//  AnimationDemo
//
//  Created by Chan on 2018/2/1.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "WaterLayout.h"

static const NSInteger defaultColumnCount = 3;

static const CGFloat defaultColumnMargin = 10;

static const CGFloat defaultRowMargin = 10;

static const UIEdgeInsets defaultInset = {10, 10, 10, 10};

@implementation WaterLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _attrsArray = [NSMutableArray new];
        _columnHeights = [NSMutableArray new];
        _contentHeight = 0.0f;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    _contentHeight = 0;
    //清空高度
    [_columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    //清空布局属性
    [_attrsArray removeAllObjects];
    //重新添加属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [_attrsArray addObject:attrs];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _attrsArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //获取指定行的布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    //宽度(平均)
    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    //每一个item的高度
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    // 找出高度最短的那一列
    //找出来最短后 就把下一个cell 添加到低下
    NSInteger destColumn = 0;
    //获取第一个最短高度
    CGFloat minColumnHeight = [_columnHeights[0] doubleValue];
    
    //从第一个开始
    for (NSInteger i = 1; i < self.columnCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    // 更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    // 记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    //找出最高的高度
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attrs;
}

- (CGSize)collectionViewContentSize {
    /*CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        
        if (maxColumnHeight < columnHeight) {
            maxColumnHeight = columnHeight;
        }
    }*/
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

#pragma mark --get Method
- (CGFloat)columnMargin {
    if ([_delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [_delegate columnMarginInWaterflowLayout:self];
    } else {
        return defaultColumnMargin;
    }
}

- (CGFloat)rowMargin {
    if ([_delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [_delegate  rowMarginInWaterflowLayout:self];
    } else {
        return defaultRowMargin;
    }
}

-(NSInteger)columnCount {
    if ([_delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [_delegate columnCountInWaterflowLayout:self];
    } else {
        return defaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets {
    if ([_delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [_delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return defaultInset;
    }
}
@end
