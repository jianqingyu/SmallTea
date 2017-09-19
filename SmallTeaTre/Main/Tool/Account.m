//
//  Account.m
//  MillenniumStar08.07
//
//  Created by yjq on 15/10/10.
//  Copyright © 2015年 qxzx.com. All rights reserved.
//

#import "Account.h"

@implementation Account

+ (instancetype)accountWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithAccountDict:dict];
}

- (id)initWithAccountDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.loginName = dict[@"loginName"];
        self.passwordReal = dict[@"passwordReal"];
        self.mobile    = dict[@"mobile"];
    }
    return self;
}
/**
 *当一个对象要归档进沙盒时，就会调用这个方法
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.loginName forKey:@"loginName"];
    [aCoder encodeObject:self.passwordReal forKey:@"passwordReal"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
}
/**
 *当从沙盒中解当时，就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.loginName = [aDecoder decodeObjectForKey:@"loginName"];
        self.passwordReal = [aDecoder decodeObjectForKey:@"passwordReal"];
        self.mobile    = [aDecoder decodeObjectForKey:@"mobile"];
    }
    return self;
}

@end
