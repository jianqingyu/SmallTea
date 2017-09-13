//
//  UserHelpViewController.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserHelpViewController.h"

@interface UserHelpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,  copy)NSArray *list;
@end

@implementation UserHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.list = @[@"小茶宝服务协议",@"仓储管理服务协议",@"仓储类问题",
                  @"茶叶质押协议", @"茶叶赎回协议"];
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
    self.tableView = [[UITableView alloc]init];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Id = @"centerCell";
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        customCell.textLabel.font = [UIFont systemFontOfSize:14];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    customCell.textLabel.text = self.list[indexPath.row];
    return customCell;
}

@end
