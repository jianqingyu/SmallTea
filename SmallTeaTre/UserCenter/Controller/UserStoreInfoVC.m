//
//  UserStoreInfoVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserStoreInfoVC.h"

@interface UserStoreInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeAdd;
@property (weak, nonatomic) IBOutlet UILabel *storeTel;
@property (weak, nonatomic) IBOutlet UILabel *storeTime;

@end

@implementation UserStoreInfoVC

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
    NSString *netUrl = [NSString stringWithFormat:@"%@api/shop/%@",baseNet,userId];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            [self setBaseView:response.result];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            SHOWALERTVIEW(str);
        }
    } requestURL:netUrl params:params];
}

- (void)setBaseView:(NSDictionary *)dic{
    self.storeName.text = dic[@"shopName"];
    self.storeAdd.text = dic[@"address"];
    self.storeTel.text = dic[@"tel"];
    self.storeTime.text = [NSString stringWithFormat:@"%@-%@",dic[@"busiStartTime"],dic[@"busiEndTime"]];
}

@end
