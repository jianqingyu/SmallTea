//
//  RigisterUserInfoVc.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "RigisterUserInfoVc.h"
#import "MainTabViewController.h"
@interface RigisterUserInfoVc ()
@property (weak, nonatomic) IBOutlet UITextField *nameFie;
@property (weak, nonatomic) IBOutlet UITextField *passFie;
@property (weak, nonatomic) IBOutlet UIButton *rigisBtn;
@end

@implementation RigisterUserInfoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [self.rigisBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    if (self.isFir) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
}

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)rigisterClick:(UIButton *)sender {
    sender.enabled = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = _dic[@"phone"];
    params[@"mobile"] = _dic[@"phone"];
    params[@"nickName"] = self.nameFie.text;
    params[@"passwordReal"] = self.passFie.text;
    params[@"shopId"] = _dic[@"shopId"];
    //    "loginName": "sysadmin", //登录名
    //    "userName": "admin",//用户名
    //    "nickName": "admin",//昵称
    //    "passwordReal": null,
    //    "mobile": null,//手机号
    //    "shopId": null,//商铺id
    //    "imgUrl": null//图像地址
    NSString *logUrl = [NSString stringWithFormat:@"%@api/user/register/%@/%@",baseNet,_dic[@"biz"],_dic[@"code"]];
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            params[@"tokenKey"] = response.result[@"tokenKey"];
            params[@"isNorm"] = [AccountTool account].isNorm;
            params[@"isNoShow"] = [AccountTool account].isNoShow;
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = [[MainTabViewController alloc]init];
            });
        }else{
            NSString *str = response.msg?response.msg:@"注册失败";
            SHOWALERTVIEW(str);
        }
        sender.enabled = YES;
    } requestURL:logUrl params:params];
}

@end
