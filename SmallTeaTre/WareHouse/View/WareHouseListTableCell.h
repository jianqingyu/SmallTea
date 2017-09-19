//
//  WareHouseListTableCell.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/5.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListInfo.h"
typedef void (^WareListBack)(BOOL isSel);
@interface WareHouseListTableCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy)WareListBack reBack;
@property (nonatomic,strong)ShoppingListInfo *listInfo;
@end
