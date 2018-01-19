//
//  NextVC.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "NextVC.h"
#import "BounceView.h"

@interface NextVC ()<CAAnimationDelegate> {
    BounceView *_subView;
}

@end

@implementation NextVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startAnimation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _subView = [[BounceView alloc] initWithFrame:CGRectMake(400, 200, 100, 40)];
    [self.view addSubview:_subView];
}

- (void)startAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGRect:CGRectMake(400, 200, 100, 40)];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(100, 200, 100, 40)];
     animation.repeatCount = 1;
     animation.fillMode = kCAFillModeForwards;
     animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = NO;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue = @(0);
    animation2.toValue = @(1);
    animation2.repeatCount = 1;
    animation2.fillMode = kCAFillModeForwards;
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,animation2];
    group.duration = 2.0;
    group.repeatCount = 1;
    group.fillMode = kCAFillModeForwards;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.removedOnCompletion = NO;
    [_subView.layer addAnimation:group forKey:@"fgagaga"];
}

/*- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGRect:CGRectMake(100, 200, 100, 40)];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(120, 200, 100, 40)];
    animation.duration = 0.5;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 1;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_subView.layer addAnimation:animation forKey:@"animationrr"];
    _subView.transform = CGAffineTransformMakeScale(0.1, 0.2);
    [UIView animateWithDuration: 0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        _subView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
 }*/
@end
