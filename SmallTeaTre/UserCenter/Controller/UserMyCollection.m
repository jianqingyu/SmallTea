//
//  UserMyCollection.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserMyCollection.h"
#import "ShoppingListInfo.h"
#import "ShoppingListTableCell.h"
@interface UserMyCollection ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation UserMyCollection

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    [self setupTableView];
    [self loadHomeData];
}

- (void)loadHomeData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([[SaveUserInfoTool shared].id isKindOfClass:[NSString class]]) {
        params[@"userId"] = [SaveUserInfoTool shared].id;
    }
    NSString *netUrl = [NSString stringWithFormat:@"%@api/user/goods/likes",baseNet];
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            self.dataArray = [ShoppingListInfo objectArrayWithKeyValuesArray:response.result];
            [self.tableView reloadData];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            SHOWALERTVIEW(str);
        }
    } requestURL:netUrl params:params];
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
    return self.dataArray.count;
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
    ShoppingListInfo *listInfo;
    if (indexPath.section<_dataArray.count) {
        listInfo = _dataArray[indexPath.section];
    }
    teaCell.listInfo = listInfo;
    return teaCell;
}

@end
