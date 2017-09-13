//
//  UserCenterViewController.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/20.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterListCell.h"
#import "UserCenterHeadView.h"
#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "CustomBackgroundView.h"
#import "ShopShareCustomView.h"
#import "ShowHidenTabBar.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
@interface UserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property(strong,nonatomic) UITableView *tableView;
@property(nonatomic,  copy) NSArray *list;
@property (assign,nonatomic) CGFloat height;
@property (weak,  nonatomic) CustomBackgroundView *baView;
@property (weak,  nonatomic) ShopShareCustomView *shareView;
@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.list = @[@{@"image":@"icon_store_info",@"title":@"门店信息",@"vc":@"UserStoreInfoVC"},
                  @{@"image":@"icon_fav",@"title":@"我的收藏",@"vc":@"UserMyCollection"},
                  @{@"image":@"icon_share_2",@"title":@"分享小茶宝",@"vc":@"UserShare"},
                  @{@"image":@"icon_help",@"title":@"使用帮助及协议",@"vc":@"UserHelpViewController"},
                  @{@"image":@"icon_me",@"title":@"关于我们",@"vc":@"UserAboutUsVc"},
                  @{@"image":@"icon_set",@"title":@"设置",@"vc":@"UserReSetViewC"}];
    [self setupTableView];
    [self loadHomeData];
    self.height = 190;
    [self creatBaseView];
}

- (void)creatBaseView{
    CustomBackgroundView *bView = [CustomBackgroundView createBackView];
    bView.hidden = YES;
    [self.view addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.baView = bView;
    
    ShopShareCustomView *infoV = [ShopShareCustomView creatCustomView];
    [self.view addSubview:infoV];
    [infoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(self.height);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(190);
    }];
    self.shareView = infoV;
}

- (void)shareShopClick {
    [self changeStoreView:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self changeStoreView:YES];
}

- (void)changeStoreView:(BOOL)isClose{
    BOOL isHi = YES;
    if (self.height==190) {
        if (isClose) {
            return;
        }
        self.height = 48;
        isHi = NO;
        [ShowHidenTabBar hideTabBar:self];
    }else{
        self.height = 190;
        isHi = YES;
        [ShowHidenTabBar showTabBar:self];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(self.height);
        }];
        [self.shareView layoutIfNeeded];//强制绘制
        self.baView.hidden = isHi;
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)loadHomeData{
    //    [SVProgressHUD show];
    //    NSString *regiUrl = [NSString stringWithFormat:@"%@userAdminPage",baseUrl];
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"tokenKey"] = [AccountTool account].tokenKey;
    //    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
    //        if ([response.error intValue]==0) {
    //            [self creatCusTomHeadView:response.data];
    //            if ([YQObjectBool boolForObject:response.data[@"userInfo"]]) {
    //            }
    //        }else{
    //            [MBProgressHUD showError:response.message];
    //        }
    //        [SVProgressHUD dismiss];
    //    } requestURL:regiUrl params:params];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = DefaultColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self setupHeadView];
    [self setupFootView];
}

- (void)setupHeadView{
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, SDevWidth*0.71+10)];
    hView.backgroundColor = DefaultColor;
    UserCenterHeadView *headV = [UserCenterHeadView createHeadView];
    [hView addSubview:headV];
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hView).offset(0);
        make.left.equalTo(hView).offset(0);
        make.right.equalTo(hView).offset(0);
        make.bottom.equalTo(hView).offset(-10);
    }];
    self.tableView.tableHeaderView = hView;
}

- (void)setupFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 65)];
    footView.backgroundColor = DefaultColor;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:
                                                   UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [footView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(0);
        make.top.equalTo(footView).offset(10);
        make.right.equalTo(footView).offset(0);
        make.height.mas_equalTo(@45);
    }];
    self.tableView.tableFooterView = footView;
}

- (void)cancelClick{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[LoginViewController alloc]init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCenterListCell *cell = [UserCenterListCell cellWithTableView:tableView];
    cell.dic = self.list[indexPath.row];
    return cell;
}

- (void)setCell{
//    NSString *Id = @"centerCell";
//    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
//    if (customCell==nil) {
//        customCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Id];
//        customCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        customCell.textLabel.font = [UIFont systemFontOfSize:14];
//        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    NSDictionary *dic = self.list[indexPath.row];
//    customCell.imageView.image = [UIImage imageNamed:dic[@"image"]];
//    customCell.textLabel.text = dic[@"title"];
//    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.list[indexPath.row];
    NSString *class = dic[@"vc"];
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    //如果没有则注册一个类
    if (!newClass) {
        [self shareShopClick];
        return;
    }
//    if (!newClass) {
//        Class superClass = [NSObject class];
//        newClass = objc_allocateClassPair(superClass, className, 0);
//        objc_registerClassPair(newClass);
//    }
    // 创建对象
    BaseViewController *instance = [[newClass alloc] init];
    instance.title = dic[@"title"];
    [self.navigationController pushViewController:instance animated:YES];
}

- (void)setShare:(UITableViewCell *)cell{
    //创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray *arr = @[@(SSDKPlatformTypeSinaWeibo),
                     @(SSDKPlatformTypeWechat),
                     @(SSDKPlatformTypeQQ)];
//    [shareParams SSDKSetupShareParamsByText:self.shareDic[@"des"]
//                                     images:[UIImage imageNamed:@"iOSCode"]
//                                        url:[NSURL URLWithString:self.shareDic[@"url"]]
//                                      title:self.shareDic[@"title"]
//                                       type:SSDKContentTypeAuto];
//    [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                     images:images //传入要分享的图片
//                                        url:[NSURL URLWithString:@"http://mob.com"]
//                                      title:@"分享标题"
//                                       type:SSDKContentTypeAuto];
    //进行分享
    [ShareSDK share:SSDKPlatformTypeSinaWeibo //传入分享的平台类型
         parameters:shareParams
     onStateChanged:nil];
}

@end
