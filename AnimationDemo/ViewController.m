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

@interface ViewController (){
    CircleView *_circleView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSStringFromClass([self class]);
    _circleView = [[CircleView alloc] initWithFrame:CGRectMake(100, 250, 150, 150)];
    [_circleView startAnimation];
    [self.view addSubview:_circleView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NextVC *VC = [NextVC new];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
