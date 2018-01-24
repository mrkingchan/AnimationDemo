//
//  CircleView.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "CircleView.h"

@interface CircleView(){
    UIView *_dotView;
}

@end

@implementation CircleView

#pragma mark --initialize Method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _dotView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/ 2.0 - 10, self.bounds.size.height - 10, 20, 20)];
        _dotView.backgroundColor = [UIColor orangeColor];
        _dotView.clipsToBounds = YES;
        _dotView.layer.cornerRadius = 10;
        [self addSubview:_dotView];
    }
    return self;
}

#pragma mark --private Method
- (void)startAnimation {
    /*CGMutablePathRef path = CGPathCreateMutable();
      CGPathAddArc(path, nil, self.frame.size.width / 2.0
             , self.frame.size.height / 2.0, self.frame.size.height * 0.5 - 10, 0, 2*M_PI, 0.0);*/
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2.0) radius:self.bounds.size.height / 2.0  startAngle:0 endAngle:2*M_PI clockwise:YES];
    UIBezierPath  *path = [UIBezierPath bezierPath];
    //    [path addQuadCurveToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height) controlPoint:CGPointMake(self.bounds.size.width,0)];
    [path addArcWithCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2.0) radius:self.bounds.size.height / 2.0
                startAngle:0
                  endAngle:2 * M_PI clockwise:YES];
    //圆形路径
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.repeatCount = HUGE_VAL;
    animation.duration = 10.0;
    animation.speed = 5.0;
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [_dotView.layer  addAnimation:animation forKey:@"circleAnimation"];
    
    //透明度
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.repeatCount = HUGE_VAL;
    opacityAnimation.fromValue =@(1.0);
    opacityAnimation.toValue = @(0);
    opacityAnimation.duration = 10.0;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode  = kCAFillModeForwards;
    
    //放大
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.repeatCount = HUGE_VAL;
    scaleAnimation.fromValue = @(0);
    scaleAnimation.toValue = @(1.0);
    scaleAnimation.duration = 10.0;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    //动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[opacityAnimation,scaleAnimation];
    group.repeatCount = HUGE_VAL;
    group.duration = 10.0;
    group.speed =  5.0;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:group forKey:@"opacityAndScaleAnimation"];
}

- (void)drawRect:(CGRect)rect {
    //注意这里不需要调用superdrawRect方法
    CGContextRef ref = UIGraphicsGetCurrentContext();  //画布
    CGContextSetRGBStrokeColor(ref, 1.0, 0, 0, 1);  //设置画笔颜色
    CGContextSetRGBFillColor(ref, 0, 0, 1.0, 1.0);  //设置填充色
    CGContextSetLineWidth(ref, 2.0); //设置线条粗细
    CGContextSetAlpha(ref, 0.8); //设置透明度
    CGContextAddArc(ref, self.bounds.size.width *0.5,self.bounds.size.height*0.5,self.bounds.size.height* 0.5 , 0,2*M_PI, 0);
//    CGContextAddEllipseInRect(ref, CGRectMake(rect.origin.x + 5, rect.origin.y + 5, rect.size.width - 5, rect.size.height - 5)); //画椭圆
    CGContextDrawPath(ref, kCGPathFillStroke); //推荐使用这个 可以同时指定线条或者填充
//    CGContextStrokePath(ref);  //线条路径
//    CGContextFillPath(ref);//填充路径
}
@end
