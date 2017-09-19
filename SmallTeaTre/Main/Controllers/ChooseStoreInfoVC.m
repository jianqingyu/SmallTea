//
//  ChooseStoreInfoVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ChooseStoreInfoVC.h"
#import "MainNavViewController.h"
#import "ChooseStoreInfoView.h"
#import "RigisterUserInfoVc.h"
#import "ChooseStoreInfoView.h"
@interface ChooseStoreInfoVC ()
@property (weak,  nonatomic) IBOutlet UIButton *nextBtn;
@property (weak,  nonatomic) UIView *baView;
@property (weak,  nonatomic) ChooseStoreInfoView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *storeLab;
@property (assign,nonatomic) CGFloat height;
@end

@implementation ChooseStoreInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nextBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    self.height = 270;
    [self creatBaseView];
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
    
    ChooseStoreInfoView *infoV = [ChooseStoreInfoView createLoginView];
    [self.view addSubview:infoV];
    infoV.storeBack = ^(NSDictionary *store,BOOL isYes){
        if (isYes) {
            self.mutDic[@"shopId"] = store[@"id"];
            self.storeLab.text = store[@"shopName"];
        }
        [self changeStoreView:NO];
    };
    [infoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(self.height);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(270);
    }];
    self.infoView = infoV;
}

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeStore:(id)sender {
    [self changeStoreView:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self changeStoreView:YES];
}

- (void)changeStoreView:(BOOL)isClose{
    BOOL isHi = YES;
    if (self.height==270) {
        if (isClose) {
            return;
        }
        self.height = 0;
        isHi = NO;
    }else{
        self.height = 270;
        isHi = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(self.height);
        }];
        [self.infoView layoutIfNeeded];//强制绘制
        self.baView.hidden = isHi;
    }];
}

- (IBAction)nextClick:(id)sender {
    if (![YQObjectBool boolForObject:self.mutDic[@"shopId"]]) {
        [MBProgressHUD showSuccess:@"请选择门店"];
    }
    RigisterUserInfoVc *infoVc = [RigisterUserInfoVc new];
    infoVc.dic = self.mutDic.copy;
    infoVc.isFir = YES;
    MainNavViewController *naviVC = [[MainNavViewController alloc]initWithRootViewController:infoVc];
    [self presentViewController:naviVC animated:YES completion:nil];
}

@end
