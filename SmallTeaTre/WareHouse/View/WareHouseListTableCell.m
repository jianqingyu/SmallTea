//
//  WareHouseListTableCell.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/5.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "WareHouseListTableCell.h"

@interface WareHouseListTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *teaImg;
@property (weak, nonatomic) IBOutlet UILabel *wareTLab;
@property (weak, nonatomic) IBOutlet UILabel *wareSta;
@property (weak, nonatomic) IBOutlet UILabel *sPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *styBtn;
@end
@implementation WareHouseListTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    WareHouseListTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[WareHouseListTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"WareHouseListTableCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setListInfo:(ShoppingListInfo *)listInfo{
    if (listInfo) {
        _listInfo = listInfo;
        NSString *url = [NSString stringWithFormat:@"%@%@",baseNet,_listInfo.imgUrl];
        [self.teaImg sd_setImageWithURL:[NSURL URLWithString:url]
                       placeholderImage:DefaultImage];
        self.wareTLab.text = _listInfo.goodsName;
        self.wareSta.text = [NSString stringWithFormat:@"%@ %@",_listInfo.deportName,_listInfo.typeName];
        [self.styBtn setTitle:_listInfo.unitName forState:UIControlStateNormal];
        NSString *str = _listInfo.introduction;
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
        str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
}

- (IBAction)staueClick:(id)sender {
    if (self.reBack) {
        self.reBack(YES);
    }
}

@end
