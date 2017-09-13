//
//  CustomRegisterV.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "CustomRegisterV.h"
#import "ZBButten.h"
#import "MainProtocolVC.h"
#import "ChooseStoreInfoVC.h"
#import "ShowLoginViewTool.h"
#import "MainNavViewController.h"
@interface CustomRegisterV()
@property (weak, nonatomic) IBOutlet UITextField *phoneFie;
@property (weak, nonatomic) IBOutlet UITextField *codeFie;
@property (weak, nonatomic) IBOutlet ZBButten *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, copy) NSString *biz;
@end
@implementation CustomRegisterV

+ (CustomRegisterV *)createRegisterView{
    CustomRegisterV *registerV = [[CustomRegisterV alloc]init];
    return registerV;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomRegisterV" owner:nil options:nil][0];
        [self.getCodeBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
        [self.nextBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
        [self.getCodeBtn setbuttenfrontTitle:@"" backtitle:@"s后获取"];
    }
    return self;
}

- (IBAction)codeClick:(UIButton *)sender {
    if (self.phoneFie.text.length<11){
        [NewUIAlertTool show:@{@"title":@"手机号输入有误"} with:self back:nil];
        return;
    }
    [self requestCheckWord];
}

- (void)requestCheckWord{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNumber"] = self.phoneFie.text;
    NSString *logUrl = [NSString stringWithFormat:@"%@api/sms/send",baseNet];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([YQObjectBool boolForObject:response.result]&&[response.code isEqualToString:@"0000"]) {
            params[@"tokenKey"] = response.result[@"tokenKey"];
            params[@"isNorm"] = [AccountTool account].isNorm;
            params[@"isNoShow"] = [AccountTool account].isNoShow;
            NSString *encodeURL = [response.result[@"bizId"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.biz = encodeURL;
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
        }else{
            [self.getCodeBtn resetBtn];
            NSString *str = response.msg?response.msg:@"登录失败";
            SHOWALERTVIEW(str);
        }
    } requestURL:logUrl params:params];
}

- (IBAction)chooseClick:(id)sender {
    
}

- (IBAction)nextClick:(UIButton *)sender {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"phone"] = self.phoneFie.text;
    params[@"phone"] = self.phoneFie.text;
    params[@"biz"] = self.biz;
    params[@"code"] = self.codeFie.text;
    //    params[@"userName"] = self.codeFie.text;
    //    "loginName": "sysadmin", //登录名
    //    "userName": "admin",//用户名
    //    "nickName": "admin",//昵称
    //    "passwordReal": null,
    //    "mobile": null,//手机号
    //    "shopId": null,//商铺id
    //    "imgUrl": null//图像地址
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    ChooseStoreInfoVC *store = [ChooseStoreInfoVC new];
    store.mutDic = params;
    [vc presentViewController:store animated:YES completion:nil];
}

- (IBAction)proClick:(id)sender {
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    MainProtocolVC *pro = [MainProtocolVC new];
    pro.isFir = YES;
    MainNavViewController *main = [[MainNavViewController alloc]initWithRootViewController:pro];
    [vc presentViewController:main animated:YES completion:nil];
}

- (void)confrimCode{
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = self.phoneFie.text;
    //    params[@"userName"] = self.codeFie.text;
    //    "loginName": "sysadmin", //登录名
    //    "userName": "admin",//用户名
    //    "nickName": "admin",//昵称
    //    "passwordReal": null,
    //    "mobile": null,//手机号
    //    "shopId": null,//商铺id
    //    "imgUrl": null//图像地址
    NSString *logUrl = [NSString stringWithFormat:@"%@api/user/register/%@/%@",baseNet,self.biz,self.codeFie.text];
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            params[@"tokenKey"] = response.result[@"tokenKey"];
            params[@"isNorm"] = [AccountTool account].isNorm;
            params[@"isNoShow"] = [AccountTool account].isNoShow;
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
        }else{
            NSString *str = response.msg?response.msg:@"登录失败";
            SHOWALERTVIEW(str);
        }
    } requestURL:logUrl params:params];
}

@end
