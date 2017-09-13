//
//  ShoppingListTableCell.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/5.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ShopListBack)(int staue,BOOL isSel);
@interface ShoppingListTableCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy)ShopListBack back;
@end
