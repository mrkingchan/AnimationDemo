//
//  PreViewCell.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/31.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "PreViewCell.h"
@interface PreViewCell(){
    UIImageView *_imageView;
}

@end
@implementation PreViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:_imageView];
    }
    return self;
}

-(void)setCellWithData:(UIImage *)model {
    _imageView.image = model;
    /*CGRect frame = _imageView.frame;
    frame.size = model.size;
    frame.origin.x = self.bounds.size.width / 2.0 - (model.size.width/2.0);
    frame.origin.y = self.bounds.size.height / 2.0 - (model.size.height/2.0);
    _imageView.frame = frame;*/
}
@end
