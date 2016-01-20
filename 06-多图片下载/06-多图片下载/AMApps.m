//
//  AMApps.m
//  06-多图片下载
//
//  Created by Ammar on 15/7/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "AMApps.h"

@implementation AMApps

+ (instancetype)appsWithDict:(NSDictionary *)dict
{
    AMApps *apps = [[AMApps alloc] init];
    [apps setValuesForKeysWithDictionary:dict];
    return apps;
}

@end
