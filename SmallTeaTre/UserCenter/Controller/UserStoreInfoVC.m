//
//  UserStoreInfoVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserStoreInfoVC.h"
#import "UserShopInfo.h"
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
    if ([[SaveUserInfoTool shared].shopId isKindOfClass:[NSString class]]) {
        userId = [SaveUserInfoTool shared].shopId;
    }
    NSString *netUrl = [NSString stringWithFormat:@"%@api/shop/%@",baseNet,userId];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            UserShopInfo *info = [UserShopInfo objectWithKeyValues:response.result];
            [self setBaseView:info];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:netUrl params:params];
}

- (void)setBaseView:(UserShopInfo *)info{
    self.storeName.text = info.shopName;
    self.storeAdd.text = info.address;
    self.storeTel.text = info.tel;
    self.storeTime.text = [NSString stringWithFormat:@"%@-%@",info.busiStartTime,info.busiEndTime];
}

@end
