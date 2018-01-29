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
#import <sqlite3.h>
#import "Student.h"
#import "HeartView.h"
#import "ShopCartVC.h"

@interface NextVC ()<CAAnimationDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    BounceView *_subView;
    UIImagePickerController *_pickerVC;
    ChartView *_chartView;
    sqlite3 *_dataBase;
    HeartView *_heartView;
}

@end

@implementation NextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSStringFromClass([self class]);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"shoppingCart" style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    /*_subView = [[BounceView alloc] initWithFrame:CGRectMake(400, 200, 100, 40)];
    [self.view addSubview:_subView];
    
    //十字架
    YesuView *subView = [[YesuView alloc] initWithFrame:CGRectMake(200,250 , 100, 100)];
    [self.view addSubview:subView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
    [subView addGestureRecognizer:tap];

    //表格
    _chartView = [[ChartView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_chartView];
    [self sqliteAction];*/
    
    //心跳
}

- (void)animationWithHeartView:(HeartView *)heartView {
    CABasicAnimation *plusAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    plusAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    plusAnimation.duration = 1;
    plusAnimation.autoreverses = YES;
    plusAnimation.fromValue = @(0.7);
    plusAnimation.toValue = @(1.1);
    plusAnimation.repeatCount = HUGE_VAL;
    plusAnimation.removedOnCompletion = NO;
    [heartView.layer addAnimation:plusAnimation forKey:@"heartBeat"];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
//    [self chartViewStartAnimationWithPosition:touchPoint];
    HeartView *heartView = [[HeartView alloc]initWithFrame:CGRectMake(touchPoint.x, touchPoint.y, 60, 60)];
    [self.view addSubview:heartView];
    [self  animationWithHeartView:heartView];
}

#pragma mark --private Method
- (void)next:(id)sender {
    ShopCartVC *VC = [ShopCartVC new];
    [self.navigationController pushViewController:VC animated:YES];    
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

- (void)sqliteAction {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath =  [documentPath stringByAppendingPathComponent:@"student.sqlite"];
    
    int result =sqlite3_open([dbPath UTF8String], &_dataBase);
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功!");
        //创建表
        char *ERROR = NULL;
        //建表
        NSString *sqlStr = @"create table if not exists 'student' ('number' integer primary key autoincrement not null,'name' text,'sex' text,'age' integer)";
        if (sqlite3_exec(_dataBase, [sqlStr UTF8String], NULL, NULL, &ERROR) == SQLITE_OK) {
            NSLog(@"创建表成功！");
            //插入
            for (int i = 0; i< 100; i ++) {
                NSString *sqlStr =[NSString stringWithFormat:@"INSERT OR REPLACE INTO student(name,sex,age) VALUES('%@','%@','%d')",[NSString stringWithFormat:@"Chan%d",i],
                                   i %2 == 0 ? @"男":@"女",
                                   100 +i];
                if (sqlite3_exec(_dataBase, [sqlStr UTF8String], NULL, NULL, &ERROR) == SQLITE_OK) {
                    NSLog(@"插入成功!");
                }
            }
            
            //查询
            NSString *selectStr = @"SELECT * FROM student";
            sqlite3_stmt *stmt;
            if (sqlite3_prepare(_dataBase, [selectStr UTF8String], -1, &stmt, nil) == SQLITE_OK) {
                while (sqlite3_step(stmt) == SQLITE_ROW ) {
                    NSString *name = [NSString stringWithUTF8String:(char*) sqlite3_column_text(stmt, 1)];
                    NSLog(@"name:%@",name);
                    
                    NSString *sex = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                    NSLog(@"sex:%@",sex);
                    
                    NSInteger age = sqlite3_column_int(stmt, 3);
                    NSLog(@"%zd",age);
                   /* StudentModel  *model = [StudentModel new];
                    model.name = name;
                    model.sex = sex;
                    model.age = age;
                    [_dataArray addObject: model];*/
                }
                if (sqlite3_step(stmt) == SQLITE_DONE) {
                    //释放句柄
                    sqlite3_finalize(stmt);
                }
            }
        } else {
            NSLog(@"创建表失败!");
        }
    } else {
        NSLog(@"数据库打开失败!");
        sqlite3_close(_dataBase);
    }
}



- (void)openSqlite {
    //判断数据库是否为空,如果不为空说明已经打开
    if(_dataBase != nil) {
        NSLog(@"数据库已经打开");
        return;
    }
    //获取文件路径
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *strPath = [str stringByAppendingPathComponent:@"my.sqlite"];
    NSLog(@"%@",strPath);
    //打开数据库
    //如果数据库存在就打开,如果不存在就创建一个再打开
    int result = sqlite3_open([strPath UTF8String], &_dataBase);
    //判断
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    } else {
        NSLog(@"数据库打开失败");
    }
}


- (void)createTable {
    NSString *sqlite = [NSString stringWithFormat:@"create table if not exists 'student' ('number' integer primary key autoincrement not null,'name' text,'sex' text,'age'integer)"];
    char *error = NULL;//执行sqlite语句失败的时候,会把失败的原因存储到里面
    int result = sqlite3_exec(_dataBase, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}

//添加数据
- (void)addStudent:(Student *)stu {
    NSString *sqlite = [NSString stringWithFormat:@"insert into student(number,name,age,sex) values ('%ld','%@','%@','%ld')",stu.number,stu.name,stu.sex,stu.age];
    char *error = NULL;//执行sqlite语句失败的时候,会把失败的原因存储到里面
    int result = sqlite3_exec(_dataBase, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"添加数据成功");
    } else {
        NSLog(@"添加数据失败");
    }
}

//删除数据
- (void)delete:(Student*)stu {
    //1.准备sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"delete from student where number = '%ld'",stu.number];
    //2.执行sqlite语句
    char *error = NULL;//执行sqlite语句失败的时候,会把失败的原因存储到里面
    int result = sqlite3_exec(_dataBase, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功");
    } else {
        NSLog(@"删除数据失败%s",error);
    }
}

//修改数据
- (void)updataWithStu:(Student *)stu {
    //1.sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"update student set name = '%@',sex = '%@',age = '%ld' where number = '%ld'",stu.name,stu.sex,stu.age,stu.number];
    //2.执行sqlite语句
    char *error = NULL;//执行sqlite语句失败的时候,会把失败的原因存储到里面
    int result = sqlite3_exec(_dataBase, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"修改数据成功");
    } else {
        NSLog(@"修改数据失败");
    }
}

//查询所有数据
- (NSMutableArray*)selectWithStu {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *sqlite = [NSString stringWithFormat:@"select * from student"];
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare(_dataBase, sqlite.UTF8String, -1, &stmt, NULL);//第4个参数是一次性返回所有的参数,就用-1
    if (result == SQLITE_OK) {
        NSLog(@"查询成功");
        //4.执行n次
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            Student *stu = [[Student alloc] init];
            //从伴随指针获取数据,第0列
            stu.number = sqlite3_column_int(stmt, 0);
            //从伴随指针获取数据,第1列
            stu.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)] ;
            //从伴随指针获取数据,第2列
            stu.sex = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)] ;
            //从伴随指针获取数据,第3列
            stu.age = sqlite3_column_int(stmt, 3);
        }
    } else {
        NSLog(@"查询失败");
    }
    sqlite3_finalize(stmt);
    return array;
}

- (void)closeSqlite {
    if (sqlite3_close(_dataBase) == SQLITE_OK) {
        NSLog(@"数据库关闭成功");
    } else {
        NSLog(@"数据库关闭失败");
    }
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
