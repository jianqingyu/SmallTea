//
//  UserEditNameVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserEditNameVC.h"

@interface UserEditNameVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameFie;

@end

@implementation UserEditNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置昵称";
    [self setRightNaviBar];
    [self.nameFie setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setRightNaviBar{
    UIButton *bar = [UIButton buttonWithType:UIButtonTypeCustom];
    bar.frame = CGRectMake(0, 0, 30, 30);
    [bar setTitle:@"保存" forState:UIControlStateNormal];
    bar.titleLabel.font = [UIFont systemFontOfSize:15];
    [bar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bar];
}

- (void)btnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
