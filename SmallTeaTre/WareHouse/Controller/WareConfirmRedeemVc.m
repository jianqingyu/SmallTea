//
//  WareConfirmRedeemVc.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/11.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "WareConfirmRedeemVc.h"

@interface WareConfirmRedeemVc ()
@property (weak, nonatomic) IBOutlet UILabel *reNum;
@property (weak, nonatomic) IBOutlet UILabel *ordPrice;
@property (weak, nonatomic) IBOutlet UILabel *ordPic;
@property (weak, nonatomic) IBOutlet UILabel *redeemPic;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@end

@implementation WareConfirmRedeemVc

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIButton *btn in self.btns) {
        [btn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    NSInteger idex = [self.btns indexOfObject:sender];
}

@end
