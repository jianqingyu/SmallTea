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
#import "HomeShopListInfo.h"
#import "CustomBackgroundView.h"
#import "ShopShareCustomView.h"
#import "HomeShoppingDetailVc.h"
#import "ShoppingListInfo.h"
@interface HomePageVC ()<UITableViewDelegate,UITableViewDataSource,
UINavigationControllerDelegate>{
    int curPage;
    int pageCount;
    int totalCount;//商品总数量
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,  weak) HomePageHeadView *headView;
@property(nonatomic,strong) NSArray *dataArray;
@property (assign,nonatomic) CGFloat height;
@property (weak,  nonatomic) CustomBackgroundView *baView;
@property (weak,  nonatomic) ShopShareCustomView *shareView;
@property(nonatomic,  copy) NSDictionary *versionDic;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    self.dataArray = @[@[].mutableCopy,@[].mutableCopy];
    pageCount = 10;
    [self setupTableView];
    [self setupHeaderRefresh];
    self.height = 190;
    [self creatBaseView];
    [self loadHomeHead];
    [self loadMessage];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
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

- (void)loadHomeHead{
    NSString *url = [NSString stringWithFormat:@"%@api/ads/page",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = @(curPage);
    params[@"pageSize"] = @3;
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            if ([YQObjectBool boolForObject:response.result]){
                NSArray *arr = response.result[@"result"];
                [self creatCusTomHeadView:arr];
            }
        }
    } requestURL:url params:params];
}

- (void)loadMessage{
    NSString *url = [NSString stringWithFormat:@"%@api/notice/page",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = @(curPage);
    params[@"pageSize"] = @1;
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            if ([YQObjectBool boolForObject:response.result]){
                NSArray *arr = response.result[@"result"];
                self.headView.messDic = arr[0];
            }
        }
    } requestURL:url params:params];
}

#pragma mark -- 网络请求
- (void)setupHeaderRefresh{
    // 刷新功能
    MJRefreshStateHeader*header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRereshing];
    }];
    [header setTitle:@"用力往下拉我!!!" forState:MJRefreshStateIdle];
    [header setTitle:@"快放开我!!!" forState:MJRefreshStatePulling];
    [header setTitle:@"努力刷新中..." forState:MJRefreshStateRefreshing];
    _tableView.header = header;
    [self.tableView.header beginRefreshing];
}

- (void)setupFootRefresh{
    
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"上拉有惊喜" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    _tableView.footer = footer;
}
#pragma mark - refresh
- (void)headerRereshing{
    [self loadNewRequestWith:YES];
}

- (void)footerRereshing{
    [self loadNewRequestWith:NO];
}

- (void)loadNewRequestWith:(BOOL)isPullRefresh{
    if (isPullRefresh){
        curPage = 1;
        for (NSMutableArray *mutA in self.dataArray) {
            [mutA removeAllObjects];
        }
    }
    [self getCommodityData];
}

- (void)getCommodityData{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@api/goods/page",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = @(curPage);
    params[@"pageSize"] = @(pageCount);
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([response.code isEqualToString:@"0000"]) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.result]){
                [self setupListDataWithDict:response.result];
            }
            [self.tableView reloadData];
            self.view.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }
    } requestURL:url params:params];
}

- (void)setupListDataWithDict:(NSDictionary *)dict{
    if([dict[@"result"] isKindOfClass:[NSArray class]]
       && [dict[@"result"] count]>0){
        self.tableView.footer.state = MJRefreshStateIdle;
        curPage++;
        totalCount = [dict[@"totalPage"]intValue];
        NSArray *seaArr = [ShoppingListInfo objectArrayWithKeyValuesArray:dict[@"result"]];
        for (NSMutableArray *mutA in _dataArray) {
            [mutA addObjectsFromArray:seaArr];
        }
        if(curPage>totalCount){
            //已加载全部数据
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_tableView.footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        //[self.tableView.header removeFromSuperview];
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_tableView.footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        _tableView.footer.state = MJRefreshStateNoMoreData;
    }
}

#pragma mark - 初始化图片
- (void)creatCusTomHeadView:(id)arr{
    NSMutableArray *pic  = @[].mutableCopy;
    for (NSDictionary*dict in arr) {
        NSString *str = [self UsingEncoding:dict[@"imgUrl"]];
        if (str.length>0) {
            [pic addObject:str];
        }
    }
    if (pic.count==0) {
        [pic addObject:@"pic"];
    }
    [self setupHeadView:pic.copy];
}

- (NSString *)UsingEncoding:(NSString *)str{
    NSString *url = [NSString stringWithFormat:@"%@%@",baseNet,str];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)setupHeadView:(NSArray *)headArr{
    CGRect headF = CGRectMake(0, 0, SDevWidth, SDevWidth*0.53+46);
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
    hView.infoArr = headArr;
    self.headView = hView;
    self.tableView.tableHeaderView = headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArray[section];
    return arr.count;
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
    NSArray *arr;
    ShoppingListInfo *listInfo;
    if (indexPath.section<_dataArray.count) {
        arr = _dataArray[indexPath.section];
        if (indexPath.row<arr.count) {
            listInfo = arr[indexPath.row];
        }
    }
    teaCell.listInfo = listInfo;
    teaCell.back = ^(int staue,BOOL isYes){
        if (staue==2) {
            [self shareShopClick];
        }
    };
    return teaCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeShoppingDetailVc *detail = [HomeShoppingDetailVc new];
    NSArray *arr;
    ShoppingListInfo *listInfo;
    if (indexPath.section<_dataArray.count) {
        arr = _dataArray[indexPath.section];
        if (indexPath.row<arr.count) {
            listInfo = arr[indexPath.row];
        }
    }
    detail.title = listInfo.goodsName;
    detail.url = listInfo.informationUrl;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
