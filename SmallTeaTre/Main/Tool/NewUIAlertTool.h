//
//  NewUIAlertTool.h
//  MillenniumStarERP
//
//  Created by yjq on 17/2/16.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewUIAlertTool : NSObject
+ (void)creatActionSheetPhoto:(void (^)(void))PhotoBlock
                    andCamera:(void (^)(void))CameraBlock
                       andCon:(id)con andView:(UIView *)view;
+ (void)show:(NSDictionary *)dic with:(id)con back:(void (^)(void))okBlock;
@end
