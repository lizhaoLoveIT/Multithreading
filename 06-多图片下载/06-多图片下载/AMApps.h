//
//  AMApps.h
//  06-多图片下载
//
//  Created by Ammar on 15/7/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMApps : NSObject

/** name */
@property (strong, nonatomic) NSString *name;

/** icon */
@property (strong, nonatomic) NSString *icon;

/** download */
@property (strong, nonatomic) NSString *download;

+ (instancetype)appsWithDict:(NSDictionary *)dict;

@end
