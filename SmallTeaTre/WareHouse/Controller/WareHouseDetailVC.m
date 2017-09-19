//
//  WareHouseDetailVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/5.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "WareHouseDetailVC.h"
#import "NewUIAlertTool.h"
#import "WareChooseNumVc.h"
#import "WareHouseListTableCell.h"
@interface WareHouseDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,   copy) NSDictionary *dic;
@end

@implementation WareHouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dic = @{@"title":@"请与客户联系",@"message":@""};
    [self setupTableView];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = DefaultColor;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-44);
    }];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
    return cell;
}

- (IBAction)bottomClick:(UIButton *)sender {
    NSInteger idex = [self.btns indexOfObject:sender];
    if (idex==3) {
        WareChooseNumVc *numVc = [WareChooseNumVc new];
        [self.navigationController pushViewController:numVc animated:YES];
        return;
    }
    [NewUIAlertTool show:self.dic back:^{
        
    }];
}

@end
