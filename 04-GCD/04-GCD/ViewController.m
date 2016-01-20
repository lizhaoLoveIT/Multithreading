//
//  ViewController.m
//  04-GCD
//
//  Created by Ammar on 15/7/10.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "AMPerson.h"

@interface ViewController ()

/** imageView */
@property (weak, nonatomic) UIImageView *imageView;

/** 图片1 */
@property (strong, nonatomic) UIImage *image1;

/** 图片2 */
@property (strong, nonatomic) UIImage *image2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(100, 100, 200, 200);
    self.imageView = imageView;
    [self.view addSubview:imageView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}
- (void)group
{
    // GCD的其他常用函数
    
    // 创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    
    // 用组队列下载图片1
    dispatch_group_async(group, queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://7xjanq.com1.z0.glb.clouddn.com/6478.jpg"]];
        self.image1 = [UIImage imageWithData:data];
        NSLog(@"1%@", [NSThread currentThread]);
    });
    // 用组队列下载图片2
    dispatch_group_async(group, queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://7xjanq.com1.z0.glb.clouddn.com/6478.jpg"]];
        self.image2 = [UIImage imageWithData:data];
        NSLog(@"2%@", [NSThread currentThread]);
    });
    
    // 将图片1和图片2合成一张图片
    dispatch_group_notify(group, queue, ^{
        CGFloat imageW = self.imageView.bounds.size.width;
        CGFloat imageH = self.imageView.bounds.size.height;
        // 开启位图上下文
        UIGraphicsBeginImageContext(self.imageView.bounds.size);
        
        // 画图
        [self.image1 drawInRect:CGRectMake(0, 0, imageW * 0.5, imageH)];
        [self.image2 drawInRect:CGRectMake(imageW * 0.5, 0, imageW * 0.5, imageH)];
        
        // 将图片取出
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 关闭图形上下文
        UIGraphicsEndImageContext();
        
        // 在主线程上显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
        NSLog(@"3%@", [NSThread currentThread]);
        
    });
}

- (void)apply
{
    // GCD的其他常用函数
    
    // 将图片剪切到另一个文件夹里
    NSString *from = @"/Users/Ammar/Pictures/壁纸";
    NSString *to = @"/Users/Ammar/Pictures/to";
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *subPaths = [manager subpathsAtPath:from];
    // 快速迭代
    dispatch_apply(subPaths.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        //        NSLog(@"%@ - %zd", [NSThread currentThread], index);
        NSString *subPath = subPaths[index];
        NSString *fromPath = [from stringByAppendingPathComponent:subPath];
        NSString *toPath = [to stringByAppendingPathComponent:subPath];
        
        // 剪切
        [manager moveItemAtPath:fromPath toPath:toPath error:nil];
        NSLog(@"%@---%zd", [NSThread currentThread], index);
    });
}

- (void)once
{
    // 整个程序中只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 一次性代码
    });
}

- (void)delay
{
    // GCD的其他常用函数
    
    // 延迟执行
    // 方法1
    [self performSelector:@selector(run:) withObject:@"参数" afterDelay:2.0];
    // 方法2
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 100; i++) {
            NSLog(@"%@", [NSThread currentThread]);
        }
    });
    // 方法3
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:NO];
}

- (void)barrier
{
    // CGD其他常用函数
    
    // 1.barrier : 在barrier前面的先执行，然后再执行barrier，然后再执行barrier后面的
    dispatch_queue_t queue = dispatch_queue_create("11", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0;  i < 100; i++) {
            NSLog(@"%@--1", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0;  i < 100; i++) {
            NSLog(@"%@--2", [NSThread currentThread]);
        }
    });
    
    dispatch_barrier_async(queue, ^{
        for (int i = 0;  i < 100; i++) {
            NSLog(@"%@--3", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0;  i < 100; i++) {
            NSLog(@"%@--4", [NSThread currentThread]);
        }
    });
}

- (void)downloadImage
{
    // 获取图片的url
    NSURL *url = [NSURL URLWithString:@"http://7xjanq.com1.z0.glb.clouddn.com/6478.jpg"];
    
    // 开启线程下载图片
    dispatch_queue_t queue = dispatch_queue_create("111", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        UIImage *image = [UIImage imageWithData:data];
        
        // 下载完成后返回主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    });
}

- (void)queue
{
    // 创建并发队列 参1:const char *label 队列名称 参2:dispatch_queue_attr_t attr 队列类型
    dispatch_queue_t queueConcurrent = dispatch_queue_create("520it.com", DISPATCH_QUEUE_CONCURRENT);
    
    // 创建串行队列  serial 串行  concurrent并发
    dispatch_queue_t queueSerial = dispatch_queue_create("520it.com", DISPATCH_QUEUE_SERIAL);
    
    // 获取全局队列 全局队列是并发队列 参1:队列的优先级 参2:0(以后可能用到的参数)
    dispatch_queue_t queueGlobal = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 全局并发队列的优先级
#define DISPATCH_QUEUE_PRIORITY_HIGH 2 // 高
#define DISPATCH_QUEUE_PRIORITY_DEFAULT 0 // 默认（中）
#define DISPATCH_QUEUE_PRIORITY_LOW (-2) // 低
#define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN // 后台
    
    // 获取主队列
    dispatch_queue_t queueMain = dispatch_get_main_queue();
    
    // GCD同步函数串行队列(立即执行，当前线程) 参1: dispatch_queue_t queue 队列 参2:任务
    dispatch_sync(queueSerial, ^{
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"~~~%@", [NSThread currentThread]);
        }
    });
    
    // 同步函数并行队列(立即执行，当前线程)
    dispatch_sync(queueConcurrent, ^{
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"~~~%@", [NSThread currentThread]);
        }
    });
    
    // 异步函数串行队列 (另开线程，多个任务按顺序执行)
    dispatch_async(queueSerial, ^{
        dispatch_async(queueSerial, ^{
            for (NSInteger i = 0; i < 10; i++) {
                NSLog(@"~~~%@", [NSThread currentThread]);
            }
        });
        dispatch_async(queueSerial, ^{
            for (NSInteger i = 0; i < 10; i++) {
                NSLog(@"~~~%@", [NSThread currentThread]);
            }
        });
        dispatch_async(queueSerial, ^{
            for (NSInteger i = 0; i < 10; i++) {
                NSLog(@"~~~%@", [NSThread currentThread]);
            }
        });
    });
    
    // 异步函数并行队列 (另开线程，多个任务一起执行)
    dispatch_async(queueConcurrent, ^{
        dispatch_async(queueSerial, ^{
            for (NSInteger i = 0; i < 10; i++) {
                NSLog(@"~~~%@", [NSThread currentThread]);
            }
        });
        dispatch_async(queueSerial, ^{
            for (NSInteger i = 0; i < 10; i++) {
                NSLog(@"~~~%@", [NSThread currentThread]);
            }
        });
        dispatch_async(queueSerial, ^{
            for (NSInteger i = 0; i < 10; i++) {
                NSLog(@"~~~%@", [NSThread currentThread]);
            }
        });
    });
    
    // 主队列:(任何一个任务只要在主队列中，都会加入到主线程的队列中执行)
}

@end
