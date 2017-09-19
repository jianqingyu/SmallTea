//
//  UserEditPasswordVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserEditPasswordVC.h"
#import "ZBButten.h"
@interface UserEditPasswordVC ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UITextField *codeFie;
@property (weak, nonatomic) IBOutlet ZBButten *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordFie;
@property (weak, nonatomic) IBOutlet UITextField *surePassFie;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, copy) NSString *biz;
@end

@implementation UserEditPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    [self.loginBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    if (self.isFir) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    [self.codeBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    [self.loginBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    [self.codeBtn setbuttenfrontTitle:@"" backtitle:@"s后获取"];
}

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getCodeClick:(id)sender {
    [self requestCheckWord];
}

- (void)requestCheckWord{
    NSString *phone = [AccountTool account].mobile;
    if (phone.length<11){
        [MBProgressHUD showError:@"手机号输入有误"];
        [self.codeBtn resetBtn];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNumber"] = phone;
    NSString *logUrl = [NSString stringWithFormat:@"%@api/sms/send",baseNet];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([YQObjectBool boolForObject:response.result]&&[response.code isEqualToString:@"0000"]) {
            self.biz = response.result[@"bizId"];
        }else{
            [self.codeBtn resetBtn];
            NSString *str = response.msg?response.msg:@"获取验证码失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:logUrl params:params];
}

- (IBAction)sureClick:(UIButton *)sender {
    if (self.codeFie.text.length==0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    if (self.passwordFie.text.length<6){
        [MBProgressHUD showError:@"密码不足6位"];
        return;
    }
    if (![self.passwordFie.text isEqualToString:self.surePassFie.text]) {
        [MBProgressHUD showError:@"两次密码不符"];
        return;
    }
    sender.enabled = NO;
    NSString *bizCode = [self.biz stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNumber"] = [AccountTool account].mobile;
    params[@"password"] = self.passwordFie.text;
    params[@"rePassword"] = self.surePassFie.text;
    NSString *netUrl = [NSString stringWithFormat:@"%@api/user/register/%@/%@",baseNet,bizCode,self.codeFie.text];
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
//            params[@"userId"] = response.result[@"id"];
//            params[@"isNorm"] = [AccountTool account].isNorm;
//            Account *account = [Account accountWithDict:params];
//            //自定义类型存储用NSKeyedArchiver
//            [AccountTool saveAccount:account];
        }else{
            NSString *str = response.msg?response.msg:@"注册失败";
            SHOWALERTVIEW(str);
        }
        sender.enabled = YES;
    } requestURL:netUrl params:params];
}

@end
