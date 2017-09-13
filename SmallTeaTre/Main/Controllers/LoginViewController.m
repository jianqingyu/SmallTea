//
//  LoginViewController.m
//  CityHousekeeper
//
//  Created by yjq on 15/11/18.
//  Copyright © 2015年 com.millenniumStar. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabViewController.h"
#import "MainNavViewController.h"
#import "RegisterViewController.h"
#import "PassWordViewController.h"
#import "IQKeyboardManager.h"
#import "CustomLoginV.h"
#import "ChooseStoreInfoVC.h"
#import "CustomRegisterV.h"
#import "AssociatPhoneVC.h"
#import <ShareSDK/ShareSDK.h>
@interface LoginViewController ()
@property (nonatomic, weak)CustomLoginV *loginView;
@property (nonatomic, weak)CustomRegisterV *regisView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *regisBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self loadHomeView];
    [self creatRegisterView];
    [self changeLoginVAndRegisV:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *name = [AccountTool account].userName;
    NSString *password = [AccountTool account].password;
    self.loginView.phoneFie.text = name;
    self.loginView.passFie.text = password;
}

- (void)loadHomeView{
    CustomLoginV *loginV = [CustomLoginV createLoginView];
    [self.view addSubview:loginV];
    loginV.btnBack = ^(int staue){
        if (staue==1) {
            if (_noLogin) {
                [self dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[MainTabViewController alloc]init];
        }else if (staue==2){
            [self presentAssociatPhone];
        }else{
            [self presentAssociatPhone];
        }
    };
    [loginV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(160);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.loginView = loginV;
}

- (void)creatRegisterView{
    CustomRegisterV *regisV = [CustomRegisterV createRegisterView];
    [self.view addSubview:regisV];
    [regisV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(160);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.regisView = regisV;
}

- (void)loadQQ{
    //例如QQ的登录
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ  //SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess){
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
         }else{
             NSLog(@"%@",error);
         }
     }];
}

- (void)presentAssociatPhone{
    AssociatPhoneVC *assVc = [AssociatPhoneVC new];
    [self presentViewController:assVc animated:YES completion:nil];
}

- (IBAction)cancelClick:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[MainTabViewController alloc]init];
}

- (IBAction)loginClick:(id)sender {
    [self changeLoginVAndRegisV:YES];
}

- (IBAction)regisClick:(id)sender {
    [self changeLoginVAndRegisV:NO];
}

- (void)changeLoginVAndRegisV:(BOOL)isChange{
    self.loginBtn.enabled = !isChange;
    self.regisBtn.enabled = isChange;
    self.loginView.hidden = !isChange;
    self.regisView.hidden = isChange;
}

- (void)registerClick{
    RegisterViewController *regiVC = [[RegisterViewController alloc]init];
    MainNavViewController *naviVC = [[MainNavViewController alloc]initWithRootViewController:regiVC];
    [self presentViewController:naviVC animated:YES completion:nil];
}

- (void)forgotKeyClick{
    PassWordViewController *passVc = [[PassWordViewController alloc]init];
    passVc.title = @"忘记密码";
    passVc.isForgot = YES;
    MainNavViewController *naviVC = [[MainNavViewController alloc]initWithRootViewController:passVc];
    [self presentViewController:naviVC animated:YES completion:nil];
}

@end
