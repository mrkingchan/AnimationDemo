//
//  PageLayout.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/31.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "PageLayout.h"

@implementation PageLayout

- (void)prepareLayout{
    [super prepareLayout];
}

- (id)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumInteritemSpacing = 0.0f;
        self.sectionInset = UIEdgeInsetsZero;
        self.minimumLineSpacing = 0;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            if (visibleRect.origin.x == 0) {
                [_pageDelegate collectionView:self.collectionView layout:self cellCenteredAtIndexPath:attribute.indexPath page:0];
            } else {
                // 除法取整 取余数
                div_t x = div(visibleRect.origin.x,visibleRect.size.width);
                if (x.quot > 0 && x.rem > 0) {
                    [_pageDelegate collectionView:self.collectionView layout:self cellCenteredAtIndexPath:attribute.indexPath page:x.quot + 1];
                }
                if (x.quot > 0 && x.rem == 0) {
                    [_pageDelegate collectionView:self.collectionView layout:self cellCenteredAtIndexPath:attribute.indexPath page:x.quot];
                }
            }
        }
    }
    return attributes;
}
@end
