//
//  HomePageVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/5.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "HomePageVC.h"
#import "TeaListTableCell.h"
#import "HYBLoopScrollView.h"
#import "HomePageHeadView.h"
#import "ShowHidenTabBar.h"
#import "CustomBackgroundView.h"
#import "ShopShareCustomView.h"
#import "HomeShoppingDetailVc.h"
@interface HomePageVC ()<UITableViewDelegate,UITableViewDataSource,
                                                UINavigationControllerDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,  weak) HomePageHeadView *headView;
@property(nonatomic,  copy) NSArray *list;
@property (assign,nonatomic) CGFloat height;
@property (weak,  nonatomic) CustomBackgroundView *baView;
@property (weak,  nonatomic) ShopShareCustomView *shareView;
@property(nonatomic,  copy) NSDictionary *versionDic;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    [self setupTableView];
    [self loadHomeData];
    self.height = 190;
    [self creatBaseView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
//    [self loadNewVersion];
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

#pragma mark -- 检查新版本
- (void)loadNewVersion{
    NSString *url = [NSString stringWithFormat:@"%@currentVersion",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"device"] = @"ios";
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code intValue]==0) {
            self.versionDic = response.result;
            [self loadAlertView];
        }
    } requestURL:url params:params];
}

- (void)loadAlertView{
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if (![version isEqualToString:self.versionDic[@"version"]]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                            message:self.versionDic[@"message"] delegate:self
                        cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:self.versionDic[@"url"]]];
    application = nil;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)loadHomeData{
    [self creatCusTomHeadView:@""];
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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
}

#pragma mark - 初始化图片
- (void)creatCusTomHeadView:(id)arr{
    NSMutableArray *pic  = @[].mutableCopy;
//    for (NSDictionary*dict in arr) {
//        NSString *str = [self UsingEncoding:dict[@"pic"]];
//        if (str.length>0) {
//            [pic addObject:str];
//        }
//    }
    [pic addObject:@"pic"];
    [pic addObject:@"pic"];
    [self setupHeadView:pic.copy];
}

- (NSString *)UsingEncoding:(NSString *)str{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)setupHeadView:(NSArray *)headArr{
    CGRect headF = CGRectMake(0, 0, SDevWidth, 250);
    //轮播视图
    UIView *headView = [[UIView alloc]initWithFrame:headF];
    headView.backgroundColor = DefaultColor;
    HomePageHeadView *hView = [HomePageHeadView createHeadView];
    [headView addSubview:hView];
    [hView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(0);
        make.top.equalTo(headView).offset(0);
        make.right.equalTo(headView).offset(0);
        make.bottom.equalTo(headView).offset(-6);
    }];
    hView.infoArr = @[@{@"pic":@"http://appapi2.fanerweb.com/images/ad/20170727/round2.jpg"},
                      @{@"pic":@"http://appapi2.fanerweb.com/images/ad/20170727/round3.jpg"},
                      @{@"pic":@"http://appapi2.fanerweb.com/images/ad/20170727/round4.jpg"}];
    self.tableView.tableHeaderView = headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 18.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 18)];
    UIView *heView = [[UIView alloc]initWithFrame:CGRectMake(9.5, 0,SDevWidth-19, 18)];
    [heView setLayerWithW:0.001 andColor:DefaultColor andBackW:0.5];
    heView.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SDevWidth-30, 18)];
    lab.text = @"新茶上架";
    lab.font = [UIFont systemFontOfSize:11];
    lab.backgroundColor = [UIColor whiteColor];
    [hView addSubview:heView];
    [heView addSubview:lab];
    return hView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeaListTableCell *teaCell = [TeaListTableCell cellWithTableView:tableView];
//    ProductInfo *proInfo;
//    if (indexPath.row<self.dataArray.count) {
//        proInfo = self.dataArray[indexPath.row];
//    }
    teaCell.back = ^(int staue,BOOL isYes){
        if (staue==1) {
            [self favShopClick:isYes];
        }else{
            [self shareShopClick];
        }
    };
    return teaCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeShoppingDetailVc *detail = [HomeShoppingDetailVc new];
//    ProductInfo *proInfo;
//    if (indexPath.row<self.dataArray.count) {
//        proInfo = self.dataArray[indexPath.row];
//    }
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)favShopClick:(BOOL)isYes{
    
}

@end
