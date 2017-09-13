//
//  ServerTypeTableView.m
//  CheKu
//
//  Created by JIMU on 15/5/14.
//  Copyright (c) 2015年 puxiang. All rights reserved.
//

#import "UserManagerTableView.h"
#import "WareHouseListTableCell.h"
#import "WareHouseDetailVC.h"
#import "WareConfirmRedeemVc.h"
@interface UserManagerTableView()<UITableViewDataSource,UITableViewDelegate>{
    int curPage;
    int totalCount;//商品总数量
    NSMutableArray *_dataArray;
    UITableView *_mTableView;
    BOOL isFir;
}

@end

@implementation UserManagerTableView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        curPage = 1;
        _dataArray = [NSMutableArray array];
        _mTableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                style:UITableViewStyleGrouped];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:_mTableView];
        [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.top.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(0);
        }];
        _dataArray = @[@"",@"",@"",@""].mutableCopy;
//        [self setupHeaderRefresh];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict{
    if (dict) {
        _dict = dict;
        if (isFir) {
            return;
        }
//        [_mTableView.header beginRefreshing];
    }
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
    _mTableView.header = header;
    [_mTableView.header beginRefreshing];
}

- (void)setupFootRefresh{
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"加载更多订单" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    _mTableView.footer = footer;
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
        [_dataArray removeAllObjects];
    }
    [self getCommodityData];
}
#pragma mark - 网络数据
- (void)getCommodityData{
    if ([self.dict[@"netUrl"]length]==0) {
        [_mTableView.header endRefreshing];
        return;
    }
    isFir = YES;
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"cpage"] = @(curPage);
    NSString *url = [NSString stringWithFormat:@"%@%@",baseNet,self.dict[@"netUrl"]];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        [_mTableView.header endRefreshing];
        [_mTableView.footer endRefreshing];
        if ([response.code intValue]==0) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.result]){
                switch ([self.dict[@"proId"]intValue]) {
                    case 10:case 20:
                        
                        break;
                    case 30:
                        
                        break;
                    case 40:
                        break;
                    default:
                        break;
                }
                [_mTableView reloadData];
            }
            [SVProgressHUD dismiss];
        }
    } requestURL:url params:params];
}

//更新list数据
- (void)setListData:(NSDictionary *)dicList and:(id)couDic{
    if([YQObjectBool boolForObject:dicList]){
        _mTableView.footer.state = MJRefreshStateIdle;
        curPage++;
        totalCount = [couDic intValue];
//        NSArray *seaArr = [OrderListNewInfo objectArrayWithKeyValuesArray:dicList];
//        [_dataArray addObjectsFromArray:seaArr];
        if(_dataArray.count>=totalCount){
            //已加载全部数据
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_mTableView.footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            _mTableView.footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        //[self.tableView.header removeFromSuperview];
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_mTableView.footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        _mTableView.footer.state = MJRefreshStateNoMoreData;
    }
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0001f;
    if (section==0) {
        height = 5.0f;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WareHouseListTableCell *cell = [WareHouseListTableCell cellWithTableView:tableView];
    cell.reBack = ^(BOOL isYes){
        WareConfirmRedeemVc *redVc = [WareConfirmRedeemVc new];
        [self.superNav pushViewController:redVc animated:YES];
    };
    return cell;
}

#pragma mark -- UITableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WareHouseDetailVC *detailVc = [WareHouseDetailVC new];
    [self.superNav pushViewController:detailVc animated:YES];
}

@end
