//
//  UserEditPasswordVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserEditPasswordVC.h"

@interface UserEditPasswordVC ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UITextField *codeFie;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordFie;
@property (weak, nonatomic) IBOutlet UITextField *surePassFie;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation UserEditPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    [self.loginBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    if (self.isFir) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
}

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getCodeClick:(id)sender {
    
}

- (IBAction)sureClick:(id)sender {
    
}

@end
