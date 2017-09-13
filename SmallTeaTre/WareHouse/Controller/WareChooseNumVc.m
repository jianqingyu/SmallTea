//
//  WareChooseNumVc.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/11.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "WareChooseNumVc.h"

@interface WareChooseNumVc ()
@property (weak, nonatomic) IBOutlet UITextField *numFie;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, copy) NSDictionary *dic;
@end

@implementation WareChooseNumVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择质押数量";
    self.dic = @{@"title":@"已提交质押申请，待审核",@"message":@""};
    [self.sureBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
}

- (IBAction)sureClick:(id)sender {
    [NewUIAlertTool show:self.dic with:self back:^{
        
    }];
}

@end
