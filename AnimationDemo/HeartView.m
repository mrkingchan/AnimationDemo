//
//  HeartView.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/25.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "HeartView.h"

@implementation HeartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [[UIColor whiteColor] setStroke];
    [[UIColor redColor] setFill];
    CGFloat drawingPadding = 4.0;
    CGFloat curveRadius = floor((CGRectGetWidth(rect) - 2*drawingPadding) / 4.0);
    UIBezierPath *heartPath = [UIBezierPath bezierPath];
    CGPoint tipLocation = CGPointMake(floor(CGRectGetWidth(rect) / 2.0), CGRectGetHeight(rect) - drawingPadding);
    [heartPath moveToPoint:tipLocation];
    
    CGPoint topLeftCurveStart = CGPointMake(drawingPadding, floor(CGRectGetHeight(rect) / 2.4));
    
    [heartPath addQuadCurveToPoint:topLeftCurveStart controlPoint:CGPointMake(topLeftCurveStart.x, topLeftCurveStart.y + curveRadius)];
    
    [heartPath addArcWithCenter:CGPointMake(topLeftCurveStart.x + curveRadius, topLeftCurveStart.y) radius:curveRadius startAngle:M_PI endAngle:0 clockwise:YES];
    
    CGPoint topRightCurveStart = CGPointMake(topLeftCurveStart.x + 2*curveRadius, topLeftCurveStart.y);
    [heartPath addArcWithCenter:CGPointMake(topRightCurveStart.x + curveRadius, topRightCurveStart.y) radius:curveRadius startAngle:M_PI endAngle:0 clockwise:YES];
    
    CGPoint topRightCurveEnd = CGPointMake(topLeftCurveStart.x + 4*curveRadius, topRightCurveStart.y);
    [heartPath addQuadCurveToPoint:tipLocation controlPoint:CGPointMake(topRightCurveEnd.x, topRightCurveEnd.y + curveRadius)];
    
    [heartPath fill];
    heartPath.lineWidth = 1;
    heartPath.lineCapStyle = kCGLineCapRound;
    heartPath.lineJoinStyle = kCGLineCapRound;
    [heartPath stroke];
}

@end
