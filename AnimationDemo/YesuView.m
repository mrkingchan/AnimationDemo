//
//  YesuView.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/24.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "YesuView.h"

@implementation YesuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ref, 1.0);
    CGContextSetRGBStrokeColor(ref, 106/255.0, 106/255.0, 106/255.0, 1.0);
    CGContextMoveToPoint(ref,10, rect.size.height / 2.0);
    CGContextAddLineToPoint(ref, rect.size.width - 10, rect.size.height / 2.0);
    
    CGContextMoveToPoint(ref, rect.size.width / 2.0,10);
    CGContextAddLineToPoint(ref, rect.size.width / 2.0, rect.size.height -10);
    
    CGContextMoveToPoint(ref, 0, 0);
    CGContextAddLineToPoint(ref, rect.size.width, rect.size.height);
    
    CGContextMoveToPoint(ref, 0, rect.size.height);
    CGContextAddLineToPoint(ref, rect.size.width, 0);
    
    CGContextStrokePath(ref);
    
}
@end
