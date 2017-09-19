//
//  CustomLoginV.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "CustomLoginV.h"
#import "ShowLoginViewTool.h"
#import "NetworkDetermineTool.h"
#import "UserEditPasswordVC.h"
#import "SaveUserInfoTool.h"
#import "MainNavViewController.h"
@interface CustomLoginV()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation CustomLoginV

+ (CustomLoginV *)createLoginView{
    static CustomLoginV *_loginView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _loginView = [[CustomLoginV alloc]init];
    });
    return _loginView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomLoginV" owner:nil options:nil][0];
        [self.loginBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    }
    return self;
}

- (IBAction)forgotPass:(id)sender {
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    UserEditPasswordVC *edit = [UserEditPasswordVC new];
    edit.isFir = YES;
    MainNavViewController *main = [[MainNavViewController alloc]initWithRootViewController:edit];
    [vc presentViewController:main animated:YES completion:nil];
}

- (IBAction)loginClick:(UIButton *)sender {
    if (self.phoneFie.text.length==0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (self.passFie.text.length==0) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if (![NetworkDetermineTool isExistenceNet]) {
        [MBProgressHUD showError:@"网络断开、请联网"];
        return;
    }
    [SVProgressHUD show];
    sender.enabled = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = self.phoneFie.text;
    params[@"passwordReal"] = self.passFie.text;
    NSString *logUrl = [NSString stringWithFormat:@"%@api/user/login",baseNet];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            params[@"mobile"] = response.result[@"mobile"];
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
            SaveUserInfoTool *save = [SaveUserInfoTool shared];
            save.mobile = response.result[@"mobile"];
            save.id = response.result[@"id"];
            save.nickName = response.result[@"nickName"];
            save.shopId = response.result[@"nickName"];
            save.imgUrl = response.result[@"imgUrl"];
            if (self.btnBack) {
                self.btnBack(1);
            }
        }else{
            NSString *str = response.msg?response.msg:@"登录失败";
            SHOWALERTVIEW(str);
        }
        sender.enabled = YES;
    } requestURL:logUrl params:params];
}

- (IBAction)weixinClick:(id)sender {
    [MBProgressHUD showError:@"暂未开通"];
//    if (self.btnBack) {
//        self.btnBack(2);
//    }
}

- (IBAction)qqClick:(id)sender {
    [MBProgressHUD showError:@"暂未开通"];
//    if (self.btnBack) {
//        self.btnBack(3);
//    }
}

@end
