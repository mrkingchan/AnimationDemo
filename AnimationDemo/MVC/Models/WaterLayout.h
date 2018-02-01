//
//  WaterLayout.h
//  AnimationDemo
//
//  Created by Chan on 2018/2/1.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterLayout;

@protocol WaterLayoutDelegate <NSObject>

@required

- (CGFloat)waterflowLayout:(WaterLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional

- (NSInteger)columnCountInWaterflowLayout:(WaterLayout *)waterflowLayout;

- (CGFloat)columnMarginInWaterflowLayout:(WaterLayout *)waterflowLayout;

- (CGFloat)rowMarginInWaterflowLayout:(WaterLayout *)waterflowLayout;

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterLayout *)waterflowLayout;

@end

@interface WaterLayout : UICollectionViewLayout

@property (nonatomic, weak) id<WaterLayoutDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *attrsArray;

@property (nonatomic, strong) NSMutableArray *columnHeights;

@property (nonatomic, assign) CGFloat contentHeight;

/*
/////property (set&get)
@property(nonatomic, assign) CGFloat rowMargin;

@property(nonatomic, assign) CGFloat columnMargin;

@property(nonatomic, assign) NSInteger columnCount;

@property(nonatomic, assign) UIEdgeInsets edgeInsets;*/


//这里方法为了简化 数据处理(通过getter方法来实现)
- (CGFloat)rowMargin;

- (CGFloat)columnMargin;

- (NSInteger)columnCount;

- (UIEdgeInsets)edgeInsets;

@end
