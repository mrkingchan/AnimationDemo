//
//  ShopCell.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/29.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ShopCell.h"

@implementation ShopCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _add = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        _add.image = [UIImage imageNamed:@"add"];
        _add.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
        [_add addGestureRecognizer:tap];
        [self addSubview:_add];
    }
    return self;
}

#pragma mark --private Method
- (void)buttonAction:(id)sender {
    if (_complete) {
        _complete(_add);
    }
}

@end
