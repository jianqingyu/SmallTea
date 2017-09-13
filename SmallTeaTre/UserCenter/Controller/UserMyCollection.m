//
//  UserMyCollection.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserMyCollection.h"
#import "ShoppingListTableCell.h"
@interface UserMyCollection ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation UserMyCollection

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    [self setupTableView];
    [self loadHomeData];
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
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.tableView.tableFooterView = [UIView new];
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
    return teaCell;
}

@end
