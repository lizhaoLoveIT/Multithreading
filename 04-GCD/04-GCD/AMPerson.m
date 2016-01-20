//
//  AMPerson.m
//  04-GCD
//
//  Created by Ammar on 15/7/10.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "AMPerson.h"

@implementation AMPerson

static id _person;
+ (instancetype)sharePerson
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _person = [[super alloc] init];
    });
    return _person;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _person = [super allocWithZone:zone];
    });
    return _person;
}

- (id)copy
{
    return _person;
}

@end
