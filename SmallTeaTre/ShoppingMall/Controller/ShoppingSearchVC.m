//
//  ShoppingSearchVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/8.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ShoppingSearchVC.h"
#import "ShopShareCustomView.h"
#import "ShoppingListTableCell.h"
@interface ShoppingSearchVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak,  nonatomic)UISearchBar *searchBar;
@property (nonatomic,strong)UITableView *tableView;
@property (weak, nonatomic) UIView *baView;
@property (assign,nonatomic) CGFloat height;
@property (weak, nonatomic) ShopShareCustomView *shareView;
@end

@implementation ShoppingSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    [self creatNaviBaseView];
    [self setupTableView];
    [self loadHomeData];
    self.height = 190;
    [self creatBaseView];
}

- (void)creatNaviBaseView{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
    UIButton *bar = [UIButton buttonWithType:UIButtonTypeCustom];
    bar.frame = CGRectMake(0, 0, 30, 30);
    [bar setTitle:@"取消" forState:UIControlStateNormal];
    bar.titleLabel.font = [UIFont systemFontOfSize:15];
    [bar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bar];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth-80, 30)];
    titleView.backgroundColor = [UIColor clearColor];
    UISearchBar *seaBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SDevWidth-80, 30)];
    [titleView addSubview:seaBar];
    [seaBar setPlaceholder:@"搜索茶叶信息"];
    [seaBar becomeFirstResponder];
    for (id view in seaBar.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            for (id laV in [view subviews]){
                if ([laV isKindOfClass:[UITextField class]]) {
                    [laV setReturnKeyType:UIReturnKeyDone];
                }
            }
        }
        if ([view isKindOfClass:[UITextField class]]) {
            [view setReturnKeyType:UIReturnKeyDone];
        }
    }
    seaBar.delegate = self;
    self.searchBar = seaBar;
    
    UIImage *backImg = [CommonUtils createImageWithColor:[UIColor clearColor]];
    [self.searchBar setBackgroundImage:backImg];
     self.navigationItem.titleView = titleView;
}

- (void)btnClick:(id)sender{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

- (void)creatBaseView{
    UIView *bView = [UIView new];
    bView.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
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

- (void)favShopClick:(BOOL)isYes{
    
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
        self.height = 0;
        isHi = NO;
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
    }];
}

@end
