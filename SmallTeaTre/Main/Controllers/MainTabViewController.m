//
//  MainTabViewController.m
//  MillenniumStar08.07
//
//  Created by yjq on 15/8/7.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import "MainTabViewController.h"
#import "MainNavViewController.h"
#import "HomePageVC.h"
#import "WareHouseVC.h"
#import "ShoppingMallVC.h"
#import "NetworkDetermineTool.h"
#import "UserCenterViewController.h"
@interface MainTabViewController ()<UITabBarControllerDelegate>

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    HomePageVC *newPage = [[HomePageVC alloc]init];
    [self addChildVcWithVC:newPage Title:@"首页"imageName:@"icon_home"
            selectImage:@"icon_home_s"];
    
    ShoppingMallVC *shopVc = [[ShoppingMallVC alloc]init];
    [self addChildVcWithVC:shopVc Title:@"商城"imageName:@"icon_shop"
               selectImage:@"icon_shop_s"];
    
    WareHouseVC *houseVc = [[WareHouseVC alloc]init];
    [self addChildVcWithVC:houseVc Title:@"仓储"imageName:@"icon_cangc"
               selectImage:@"icon_cangc_s"];
    
    UserCenterViewController *listVc = [[UserCenterViewController alloc]init];
    [self addChildVcWithVC:listVc Title:@"我的"imageName:@"icon_center"
               selectImage:@"icon_center_s"];
     UIImage *backImg = [CommonUtils createImageWithColor:[UIColor whiteColor]];
     [self.tabBar setBackgroundImage:backImg];
}

- (void)addChildVcWithVC:(UIViewController *)vc Title:(NSString *)title
            imageName:(NSString *)imageName selectImage:(NSString *)selectImage{
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:
        UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *selectDict = [NSMutableDictionary dictionary];
    selectDict[NSForegroundColorAttributeName] = CUSTOM_COLOR(114, 27, 6);
    selectDict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:9];
    [vc.tabBarItem setTitleTextAttributes:selectDict forState:UIControlStateSelected];
    
    NSMutableDictionary *norDict = [NSMutableDictionary dictionary];
    norDict[NSForegroundColorAttributeName] = [UIColor blackColor];
    norDict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:9];
    [vc.tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];
    
    MainNavViewController *nav = [[MainNavViewController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController
                 shouldSelectViewController:(UIViewController *)viewController{
    if (![NetworkDetermineTool isExistenceNet]) {
        [NetworkDetermineTool changeSupNaviWithNav:(MainNavViewController *)viewController];
    }
    return YES;
}

@end
