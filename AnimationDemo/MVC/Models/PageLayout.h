//
//  PageLayout.h
//  AnimationDemo
//
//  Created by Chan on 2018/1/31.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pageDelegate <NSObject>

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath page:(int)page;

@optional

@end
@interface PageLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<pageDelegate>pageDelegate;

@end
