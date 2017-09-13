//
//  ChooseStoreInfoView.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ChooseStoreInfoView.h"
@interface ChooseStoreInfoView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *list;
@end
@implementation ChooseStoreInfoView

+ (ChooseStoreInfoView *)createLoginView{
    static ChooseStoreInfoView *_InfoView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _InfoView = [[ChooseStoreInfoView alloc]init];
    });
    return _InfoView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ChooseStoreInfoView" owner:nil options:nil][0];
        self.list = @[@{@"title":@"001门店",@"id":@"1"},
                      @{@"title":@"002门店",@"id":@"2"},
                      @{@"title":@"003门店",@"id":@"3"},
                      @{@"title":@"004门店",@"id":@"4"}];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.bounces = NO;
        [self.tableView reloadData];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count?self.list.count:3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Id = @"customCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Id];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = CUSTOM_COLOR(40, 40, 40);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic;
    if (indexPath.row<self.list.count) {
        dic = self.list[indexPath.row];
    }
    cell.textLabel.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic;
    if (indexPath.row<self.list.count) {
        dic = self.list[indexPath.row];
    }
    if (self.storeBack) {
        self.storeBack(dic[@"id"],YES);
    }
}

- (IBAction)cancelClick:(id)sender {
    if (self.storeBack) {
        self.storeBack(@"",NO);
    }
}

@end
