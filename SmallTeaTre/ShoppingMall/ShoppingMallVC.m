//
//  ShoppingMallVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ShoppingMallVC.h"
#import "ShoppingSearchVC.h"
#import "CustomBackgroundView.h"
#import "ShopShareCustomView.h"
#import "ShoppingListTableCell.h"
#import "HomeShoppingDetailVc.h"
#import "ShowHidenTabBar.h"
@interface ShoppingMallVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak,  nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *tableView;
@property (assign,nonatomic) CGFloat height;
@property (weak,  nonatomic) CustomBackgroundView *baView;
@property (weak,  nonatomic) ShopShareCustomView *shareView;
@end

@implementation ShoppingMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    UIImage *backImg = [CommonUtils createImageWithColor:CUSTOM_COLOR(200, 200, 200)];
    [self.searchBar setBackgroundImage:backImg];
    self.searchBar.delegate = self;
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
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(self.height);
        }];
        [self.shareView layoutIfNeeded];//强制绘制
        self.baView.hidden = isHi;
        if (isHi) {
            [ShowHidenTabBar showTabBar:self];
        }
    }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    ShoppingSearchVC *searchVc = [ShoppingSearchVC new];
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = DefaultColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(44);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
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
    ShoppingListTableCell *teaCell = [ShoppingListTableCell cellWithTableView:tableView];
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
//    HomeShoppingDetailVc *detail = [HomeShoppingDetailVc new];
//    //    ProductInfo *proInfo;
//    //    if (indexPath.row<self.dataArray.count) {
//    //        proInfo = self.dataArray[indexPath.row];
//    //    }
//    [self.navigationController pushViewController:detail animated:YES];
}

- (void)favShopClick:(BOOL)isYes{
    
}

@end
