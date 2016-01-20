//
//  ViewController.m
//  05-NSOperation
//
//  Created by Ammar on 15/7/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

///** 图片1 */
//@property (strong, nonatomic) UIImage *image1;
///** 图片2 */
//@property (strong, nonatomic) UIImage *image2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 下载图片1
    __block UIImage *image1 = nil;
    NSBlockOperation *block1 = [NSBlockOperation blockOperationWithBlock:^{
        image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://7xjanq.com1.z0.glb.clouddn.com/6478.jpg"]]];
    }];
    
    // 下载图片2
    __block UIImage *image2 = nil;
    NSBlockOperation *block2 = [NSBlockOperation blockOperationWithBlock:^{
        image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://7xjanq.com1.z0.glb.clouddn.com/6478.jpg"]]];

    }];
    
    CGFloat imageW = self.imageView.bounds.size.width;
    CGFloat imageH = self.imageView.bounds.size.height;
    
    // 合成图片
    NSBlockOperation *block3 = [NSBlockOperation blockOperationWithBlock:^{
        UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
        [image1 drawInRect:CGRectMake(0, 0, imageW * 0.5, imageH)];
        [image2 drawInRect:CGRectMake(0.5 * imageW, 0, 0.5 * imageW, imageH)];
        
        UIImage *image3 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 切换回主线程显示图片
        [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
            self.imageView.image = image3;
        }]];
    
    }];
    
    // 设置依赖
    [block3 addDependency:block1];
    [block3 addDependency:block2];
    
    // 添加任务到队列中
    [queue addOperation:block1];
    [queue addOperation:block2];
    [queue addOperation:block3];
}

/*
 * 线程通信
 */
- (void)communication
{
    // 下载图片 operation实现线程间通信
    [[[NSOperationQueue alloc] init] addOperation:[NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://7xjanq.com1.z0.glb.clouddn.com/6478.jpg"]]];
        
        // 返回主线程
        [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
            self.imageView.image = image;
        }]];
        
    }]];
}

- (void)addDependency
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *block1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download1 -------------- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *block2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download2 -------------- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *block3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download3 -------------- %@", [NSThread currentThread]);
    }];
    
    // 添加依赖: block1 和 block2执行完后 再执行 block3  block3依赖于block1和block2
    
    // 给block3添加依赖 让block3在block1和block2之后执行
    [block3 addDependency:block1];
    [block3 addDependency:block2];
    
    [queue addOperation:block1];
    [queue addOperation:block2];
    [queue addOperation:block3];
}

- (void)basic
{
    // 创建一个其他队列(包括串行队列和并发队列) 放到这个队列中的NSOperation对象会自动放到子线程中执行
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 创建一个主队列，放到这个队列中的NSOperation对象会自动放到子线程中执行
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    // 表示串行队列
    queue.maxConcurrentOperationCount = 1;
    
    queue.suspended = YES;
}

- (void)run
{
    NSLog(@"11%@", [NSThread currentThread]);
}
@end
