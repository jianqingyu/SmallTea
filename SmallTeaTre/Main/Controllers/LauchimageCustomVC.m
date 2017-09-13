//
//  LauchimageCus/Users/yjq/Desktop/MillFactory/MillenniumStarERPtomVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "LauchimageCustomVC.h"
#import "LoginViewController.h"
@interface LauchimageCustomVC ()
@property (weak,  nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,  weak) NSTimer *timer;
@property (nonatomic,assign) int i;
@end

@implementation LauchimageCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.i = 3;
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeClick:) userInfo:nil repeats:YES];
}

- (void)timeClick:(id)user{
    if (self.i==1) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[LoginViewController alloc]init];
         [_timer invalidate];
        _timer = nil;
    }
    self.i--;
    [self.btn setTitle:[NSString stringWithFormat:@"跳过 %d",self.i] forState:UIControlStateNormal];
}

- (IBAction)openClick:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[LoginViewController alloc]init];
}

@end
