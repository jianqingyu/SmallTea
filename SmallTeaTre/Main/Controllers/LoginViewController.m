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
    NSString *name = [AccountTool account].loginName;
    NSString *password = [AccountTool account].password;
    self.loginView.phoneFie.text = name;
    self.loginView.passFie.text = password;
}

- (void)loadHomeView{
    CustomLoginV *loginV = [CustomLoginV createLoginView];
    [self.view addSubview:loginV];
    loginV.btnBack = ^(int staue){
        if (staue==1) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[MainTabViewController alloc]init];
        }else if(staue==2){
            [self loadWeiXinAndQQ:SSDKPlatformTypeWechat];
        }else if (staue==3){
            [self loadWeiXinAndQQ:SSDKPlatformTypeQQ];
        }
    };
    [loginV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(165);
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
        make.top.equalTo(self.view).offset(165);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.regisView = regisV;
}

- (void)loadWeiXinAndQQ:(SSDKPlatformType)type{
    [SVProgressHUD show];
    if ([ShareSDK hasAuthorized:type]) {
        [ShareSDK cancelAuthorize:type];
    }
    //例如QQ的登录
    [ShareSDK getUserInfo:type  //SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error){
               if (state == SSDKResponseStateSuccess){
                   //验证成功，主线程处理UI
                   [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                       SaveUserInfoTool *data = [SaveUserInfoTool shared];
                       data.nickName = user.nickname;
                       [self presentAssociatPhone];
                   }];
//                        NSLog(@"uid=%@",user.uid);
//                        NSLog(@"%@",user.credential);
//                        NSLog(@"token=%@",user.credential.token);
//                        NSLog(@"nickname=%@",user.nickname);
               }else{
                   [MBProgressHUD showError:@"取消"];
               }
               [SVProgressHUD dismiss];
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

@end
