//
//  ShopShareCustomView.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ShopShareCustomView.h"
@interface ShopShareCustomView()

@end
@implementation ShopShareCustomView

+ (id)creatCustomView{
    ShopShareCustomView *headView = [[ShopShareCustomView alloc]init];
    return headView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ShopShareCustomView" owner:nil options:nil][0];
    }
    return self;
}

@end
