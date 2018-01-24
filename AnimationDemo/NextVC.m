//
//  NextVC.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "NextVC.h"
#import "BounceView.h"
#import "YesuView.h"
#import "ChartView.h"

@interface NextVC ()<CAAnimationDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    BounceView *_subView;
    UIImagePickerController *_pickerVC;
    ChartView *_chartView;
}

@end

@implementation NextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _subView = [[BounceView alloc] initWithFrame:CGRectMake(400, 200, 100, 40)];
    [self.view addSubview:_subView];
    
    //十字架
    YesuView *subView = [[YesuView alloc] initWithFrame:CGRectMake(200,250 , 100, 100)];
    [self.view addSubview:subView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
    [subView addGestureRecognizer:tap];

    
    //表格
    _chartView = [[ChartView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_chartView];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self chartViewStartAnimation];
}

- (void)chartViewStartAnimation {
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
    [path moveToPoint:CGPointMake(_chartView.frame.origin.x, _chartView.frame.origin.y)];
    [path  addQuadCurveToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) controlPoint:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 0)];
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
    group.duration = 3.0;
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [_chartView.layer addAnimation:group forKey:@"animationgroup"];
}

#pragma mark --private Method
- (void)buttonAction:(id)sender {
    UIAlertController *alertVC  = [UIAlertController alertControllerWithTitle:nil
                                                                      message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < 3; i ++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle: i == 0 ? @"拍照": i == 1 ?@"相册":@"取消" style:i == 2 ?  UIAlertActionStyleCancel:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (i<2) {
                _pickerVC = [UIImagePickerController new];
                _pickerVC.delegate = self;
                _pickerVC.sourceType = i == 0 ?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:_pickerVC animated:YES completion:nil];
            }
        }];
        [alertVC addAction:action];
    }
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    [_subView.layer addAnimation:group forKey:@"animationgroup"];
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
