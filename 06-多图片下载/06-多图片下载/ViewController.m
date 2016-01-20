//
//  ViewController.m
//  06-多图片下载
//
//  Created by Ammar on 15/7/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "AMApps.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 数据模型 */
@property (strong, nonatomic) NSMutableArray *apps;

/** 缓存image */
@property (strong, nonatomic) NSMutableDictionary *images;

/** 缓存操作 */
@property (strong, nonatomic) NSMutableDictionary *options;

/** 创建队列 */
@property (strong, nonatomic) NSOperationQueue *queue;

@end

@implementation ViewController
#pragma mark - 懒加载
- (NSMutableArray *)apps
{
    if (_apps == nil)
    {
        _apps = [NSMutableArray array];
        NSArray *appArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"apps.plist" ofType:nil]];
        
        for (NSDictionary *dict in appArray) {
            AMApps *apps = [AMApps appsWithDict:dict];
            [_apps addObject:apps];
        }
    }
    return _apps;
}

- (NSMutableDictionary *)images
{
    if (_images == nil) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

- (NSMutableDictionary *)options
{
    if (_options == nil) {
        _options = [NSMutableDictionary dictionary];
    }
    return _options;
}

- (NSOperationQueue *)queue
{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 3;
    }
    return _queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

#pragma mark - 接收到内存警告时
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.images = nil;
    self.options = nil;
    // 把所有队列撤销
    [self.queue cancelAllOperations];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.apps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"app";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    AMApps *app = self.apps[indexPath.row];
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.download;
    
    // 先在内存中查找image
    UIImage *image = self.images[app.icon];
    if (image) {
        cell.imageView.image = image;
    }else
    {
        // 如果没有在沙盒中查找是否有图片
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[app.icon lastPathComponent]];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if (data) { // 如果有将图片则直接用
            cell.imageView.image = [UIImage imageWithData:data];
            // 然后将图片存入内存
            self.images[app.icon] = cell.imageView.image;
        }else{ // 如果没有图片则下载图片
            // 设置占位图片
            cell.imageView.image = [UIImage imageNamed:@"34522c3f53fdad27ea2fefdf3d395bb6"];
            NSOperation *option = self.options[app.icon];
            // 先从缓存中看看有没有现在当前图片的NSOperation对象(当用户拖拽时，保证只下载一次)
            if (option) return cell;
            
            // 如果operation为空 则开启线程下载图片
            option = [NSBlockOperation blockOperationWithBlock:^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:app.icon]];
                UIImage *image = [UIImage imageWithData:data];
                
                // 如果下载失败
                if (data == nil){
                    // 清空操作
                    [self.options removeObjectForKey:app.icon];
                    return;
                }
                // 将图片加载到内存中
                self.images[app.icon] = image;
                
                // 将图片存入到沙盒中
                [data writeToFile:filePath atomically:YES];
                
                [NSThread sleepForTimeInterval:2.0];
                
                // 回到主线程显示图片
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // 这样写会产生一个问题：图片还没显示 用户就拖拽 由于cell循环利用，则会产生图片错乱
//                    cell.imageView.image = image;
                    // 规范写法：只更新对应的indexPath的数据 由于已经将图片存入缓存 则直接取图片
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }];
            
            [self.queue addOperation:option];
            
            // 将操作存入到缓存中
            self.options[app.icon] = option;
        }
    }
    
    
    return cell;
}



@end
