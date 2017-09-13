//
//  UserCenterHeadView.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserCenterHeadView.h"

@implementation UserCenterHeadView

+ (UserCenterHeadView *)createHeadView{
    static UserCenterHeadView *_userHV = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userHV = [[UserCenterHeadView alloc]init];
    });
    return _userHV;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"UserCenterHeadView" owner:nil options:nil][0];
    }
    return self;
}

@end
