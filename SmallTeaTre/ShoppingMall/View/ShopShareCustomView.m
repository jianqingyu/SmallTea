//
//  ShopShareCustomView.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ShopShareCustomView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
@interface ShopShareCustomView()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@property (nonatomic,   copy) NSDictionary *shareDic;
@end
@implementation ShopShareCustomView

+ (id)creatCustomView{
    ShopShareCustomView *headView = [[ShopShareCustomView alloc]init];
    return headView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ShopShareCustomView" owner:nil options:nil][0];
    }
    return self;
}

- (IBAction)shareClick:(UIButton *)sender {
    NSInteger idex = [self.btns indexOfObject:sender];
    [self setShareSdkAtIndex:idex];
}

- (void)setShareSdkAtIndex:(NSInteger)idex{
    //创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    self.shareDic = @{@"des":@"小茶宝",@"url":@"www.baidu.com",@"title":@"小茶宝"};
    [shareParams SSDKSetupShareParamsByText:self.shareDic[@"des"]
                                     images:[UIImage imageNamed:@"iOSCode"]
                                        url:[NSURL URLWithString:self.shareDic[@"url"]]
                                      title:self.shareDic[@"title"]
                                       type:SSDKContentTypeAuto];
    SSDKPlatformType type;
    switch (idex) {
        case 0:
            type = SSDKPlatformTypeWechat;
            break;
        case 1:
            type = SSDKPlatformSubTypeWechatTimeline;
            break;
        case 2:
            type = SSDKPlatformTypeQQ;
            break;
        case 3:
            type = SSDKPlatformTypeSinaWeibo;
            break;
        default:
            break;
    }
    //进行分享 //传入分享的平台类型
    [ShareSDK share:type parameters:shareParams onStateChanged:nil];
}

@end
