//
//  ChartView.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/24.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ChartView.h"

@implementation ChartView

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
    CGFloat itemW = (rect.size.width - 18)/ 10;
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ref, 2.0);
    CGContextSetRGBStrokeColor(ref, 106/255.0, 106/255.0, 106/255.0, 1.0);
    for (int i = 0; i < 9; i ++) {
        //竖线
        CGContextMoveToPoint(ref, itemW * (i +1) +(i * 2) , 0);
        CGContextAddLineToPoint(ref, itemW * (i +1) +(i * 2), rect.size.height);
        //横线
        CGContextMoveToPoint(ref, 0 , itemW * (i +1) +(i * 2));
        CGContextAddLineToPoint(ref, rect.size.width,itemW * (i +1) +(i * 2));
    }
    CGContextStrokePath(ref);
    for (int i = 0; i < 9; i ++) {
        for (int j = 0; j < 9; j++) {
            
        }
    }
}

@end
