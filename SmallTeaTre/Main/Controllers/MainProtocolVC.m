//
//  MainProtocolVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "MainProtocolVC.h"

@interface MainProtocolVC ()

@end

@implementation MainProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主要协议";
    if (self.isFir) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
}

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
