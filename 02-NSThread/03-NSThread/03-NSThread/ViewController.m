//
//  ViewController.m
//  03-NSThread
//
//  Created by Ammar on 15/7/8.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - 创建线程方法1
- (IBAction)clickButton:(id)sender {
    // 创建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"jack"];
    
    [thread start];
    // 线程启动了，事情做完了才会死， 一个NSThread对象就代表一条线程
    
    
}

#pragma mark - 创建线程方法2
- (IBAction)clickButton2:(id)sender {
    // 直接创建并启动线程
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"jack"];
}


#pragma mark - 创建线程方法3
- (IBAction)clickButton3:(id)sender {
    // 直接创建并启动线程
    // 使线程进入阻塞状态
    [NSThread sleepForTimeInterval:2.0];
    [self performSelectorInBackground:@selector(run:) withObject:@"jack"];
    
    // 方法2和方法3的优点:快捷    方法1的优点:可以轻松拿到线程
}


#pragma mark - 执行run方法
- (void)run:(NSString *)param
{
    // 当前线程是否是主线程
    for (NSInteger i = 0; i < 100; i++) {
        NSLog(@"---%@---%zd---%d", [NSThread currentThread], i, [NSThread isMainThread]);
    }
    
}


@end
