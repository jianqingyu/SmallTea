//
//  HomePageHeadView.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/6.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "HomePageHeadView.h"
#import "HYBLoopScrollView.h"
#import "MainProtocolVC.h"
#import "ShowLoginViewTool.h"
@interface HomePageHeadView()
@property (weak, nonatomic) IBOutlet UIButton *conBtn;
@property (weak, nonatomic) IBOutlet UILabel *messLab;
@end
@implementation HomePageHeadView

+ (HomePageHeadView *)createHeadView{
    HomePageHeadView *headView = [[HomePageHeadView alloc]init];
    return headView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HomePageHeadView" owner:nil options:nil][0];
    }
    return self;
}

- (void)setLoopScrollView:(NSArray *)arr{
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:
                               CGRectMake(0, 0, SDevWidth, SDevWidth*0.53) imageUrls:arr];
    loop.timeInterval = 3.0;
    loop.didSelectItemBlock = ^(NSInteger atIndex,HYBLoadImageView  *sender){
        
    };
    loop.alignment = kPageControlAlignRight;
    [self addSubview:loop];
}

- (void)setInfoArr:(NSArray *)infoArr{
    if (infoArr) {
        _infoArr = infoArr;
        [self setLoopScrollView:_infoArr];
    }
}

- (void)setMessDic:(NSDictionary *)messDic{
    if (messDic) {
        _messDic = messDic;
        self.messLab.text = _messDic[@"title"];
    }
}

- (IBAction)topClick:(id)sender {
    self.conBtn.enabled = NO;
    [self performSelector:@selector(changeButtonStatus)withObject:nil afterDelay:1.0f];//防止重复点击
    [self openConfirmOrder];
}

- (void)changeButtonStatus{
    self.conBtn.enabled = YES;
}

- (void)openConfirmOrder{
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    MainProtocolVC *pro = [MainProtocolVC new];
    pro.title = _messDic[@"title"];
    pro.content = _messDic[@"content"];
    [vc.navigationController pushViewController:pro animated:YES];
}

@end
