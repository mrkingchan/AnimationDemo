//
//  ShopCartVC.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/29.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ShopCartVC.h"
#import "ShopCell.h"
#import "PhotoVC.h"

@interface ShopCartVC ()<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate> {
    UITableView *_tableView;
}

@end

@implementation ShopCartVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (UIView *subView in self.view.window.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [((UIImageView *)subView) removeFromSuperview];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSStringFromClass([self class]);
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSStringFromClass([PhotoVC class]) style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:0];
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)next:(id)sender {
    PhotoVC *VC = [PhotoVC new];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark --UITableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kcellID = @"kcellID";
    ShopCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellID];
    if (!cell) {
        cell = [[ShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kcellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(cell)weakCell = cell;
    cell.complete = ^(UIImageView *add) {
        CGRect frame = [weakCell convertRect:weakCell.add.frame toView:[UIApplication sharedApplication].keyWindow];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = add.image;
        [self.view.window addSubview:imageView];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(frame.origin.x, frame.origin.y)];
        [path addQuadCurveToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width/1.5, [UIScreen mainScreen].bounds.size.height) controlPoint:CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0, 0)];
        CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnimation.delegate = self;
        moveAnimation.duration = 1.0;
        moveAnimation.removedOnCompletion = YES;
        moveAnimation.repeatCount = 1;
        moveAnimation.path = path.CGPath;
        moveAnimation.autoreverses = NO;
        moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [imageView.layer addAnimation:moveAnimation forKey:@"moveAnimation"];
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (UIView *subView in self.view.window.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [((UIImageView *)subView) removeFromSuperview];
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
}
@end
