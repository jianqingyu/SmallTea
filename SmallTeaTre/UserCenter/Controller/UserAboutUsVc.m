//
//  UserAboutUsVc.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserAboutUsVc.h"

@interface UserAboutUsVc ()
@property (weak, nonatomic) IBOutlet UILabel *aboutLab;
@property (weak, nonatomic) IBOutlet UILabel *verLab;
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@end

@implementation UserAboutUsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHomeData];
}

- (void)loadHomeData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userId;
    if ([[SaveUserInfoTool shared].id isKindOfClass:[NSString class]]) {
        userId = [SaveUserInfoTool shared].id;
    }
    NSString *netUrl = [NSString stringWithFormat:@"%@api/app/info",baseNet];
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            [self setBaseView:response.result];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            SHOWALERTVIEW(str);
        }
    } requestURL:netUrl params:params];
}

- (void)setBaseView:(NSDictionary *)dic{
    self.aboutLab.text = dic[@"app_introduction"];
    self.verLab.text = [NSString stringWithFormat:@"版本号:%@",dic[@"app_ios_version"]];
    self.telLab.text = [NSString stringWithFormat:@"客服电话:%@",dic[@"customer_service_phone"]];
}

@end
