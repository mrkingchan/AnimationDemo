//
//  ShopCell.h
//  AnimationDemo
//
//  Created by Chan on 2018/1/29.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCell : UITableViewCell

@property(nonatomic,strong) UIImageView *add;

@property(nonatomic,copy)void (^complete)(UIImageView *add);

@end
