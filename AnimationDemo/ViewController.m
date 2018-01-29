//
//  ViewController.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ViewController.h"
#import "NextVC.h"
#import "CircleView.h"
#import "ChartView.h"


@interface ViewController (){
    CircleView *_circleView;
    ChartView *_chartView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"NextVC" style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    self.navigationItem.title = NSStringFromClass([self class]);
    _circleView = [[CircleView alloc] initWithFrame:CGRectMake(100, 250, 150, 150)];
    [_circleView startAnimation];
    [self.view addSubview:_circleView];
    
    
    _chartView = [[ChartView alloc] initWithFrame:CGRectMake(100,100,100,100)];
    [self.view addSubview:_chartView];
}

- (void)next:(id)sender {
    NextVC *VC = [NextVC new];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self chartViewStartAnimationWithPosition:point];
}

- (void)chartViewStartAnimationWithPosition:(CGPoint)position {
    //旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    animation.duration = 1.0;
    animation.speed = 6.0;
    animation.repeatCount = HUGE_VAL;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //掉落
    UIBezierPath *path = [UIBezierPath bezierPath];
    //路径动画必须要moveToPoint
    [path moveToPoint:CGPointMake(_chartView.frame.origin.x, _chartView.frame.origin.y)];
    //弧线路径
    [path  addQuadCurveToPoint:position controlPoint:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 0)];
    CAKeyframeAnimation  *dropAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    dropAnimation.duration = 3.0;
    dropAnimation.repeatCount = 1;
    dropAnimation.path = path.CGPath;
    dropAnimation.fillMode = kCAFillModeForwards;
    dropAnimation.removedOnCompletion = NO;
    dropAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //透明度
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @(1.0);
    alphaAnimation.toValue = @(0.3);
    alphaAnimation.duration = 3.0;
    alphaAnimation.repeatCount = 1;
    alphaAnimation.fillMode = kCAFillModeForwards;
    alphaAnimation.removedOnCompletion = NO;
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //缩小
    CABasicAnimation *minusAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    minusAnimation.fromValue = @(1.0);
    minusAnimation.toValue = @(0.0);
    minusAnimation.duration = 3.0;
    minusAnimation.repeatCount = 1;
    minusAnimation.fillMode = kCAFillModeForwards;
    minusAnimation.removedOnCompletion = NO;
    minusAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,dropAnimation,alphaAnimation,minusAnimation];
    group.duration = 5.0;
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    group.autoreverses = NO;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [_chartView.layer addAnimation:group forKey:@"animationgroup"];
}

@end
