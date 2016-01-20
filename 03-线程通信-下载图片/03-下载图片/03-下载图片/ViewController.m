//
//  ViewController.m
//  03-下载图片
//
//  Created by Ammar on 15/7/8.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    // 获取图片的url
    NSURL *url = [NSURL URLWithString:@"http://7xjanq.com1.z0.glb.clouddn.com/6478.jpg"];
    // 另开1条线程 object用于数据的传递
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downLoadWithURL:) object:url];
    // 由于下面下载图片的耗时太长，应领开启线程来完成
    [thread start];
}

// 下载图片
- (void)downLoadWithURL:(NSURL *)url
{
    NSLog(@"%@", [NSThread currentThread]);
    // 下载图片
    NSData *data = [NSData dataWithContentsOfURL:url];
    // 生成图片
    UIImage *image = [UIImage imageWithData:data];
    
    // 返回主线程显示图片
    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
}

@end
