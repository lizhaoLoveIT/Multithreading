//
//  ViewController.m
//  03-pthread
//
//  Created by Ammar on 15/7/8.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>

@interface ViewController ()

@end

/*
 void * run(void *param)
 {
 for (NSInteger i = 0; i<50000; i++) {
 NSLog(@"------buttonClick---%zd--%@", i, [NSThread currentThread]);
 }
 return NULL;
 }
 
 - (IBAction)buttonClick:(id)sender {
 pthread_t thread;
 pthread_create(&thread, NULL, run, NULL);
 
 pthread_t thread2;
 pthread_create(&thread2, NULL, run, NULL);
 }
 */

void * run(void *param)
{
    for (NSInteger i = 0; i < 1000; i++) {
        NSLog(@"---buttonclick---%zd---%@", i, [NSThread currentThread]);
    }
    
    return NULL;
}

@implementation ViewController

- (IBAction)clickButton:(id)sender {
    // 定义一个线程
    pthread_t thread;
    
    // 创建一个线程  (参1)pthread_t *restrict:创建线程的指针，(参2)const pthread_attr_t *restrict:线程属性  (参3)void *(*)(void *):线程执行的函数的指针，(参4)void *restrict:null
    pthread_create(&thread, NULL, run, NULL);
    
    // 何时回收线程不需要你考虑
    pthread_t thread2;
    
    pthread_create(&thread2, NULL, run, NULL);

}


- (void)viewDidLoad {
    [super viewDidLoad];
}



@end
