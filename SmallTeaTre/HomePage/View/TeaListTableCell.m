//
//  TeaListTableCell.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "TeaListTableCell.h"
@interface TeaListTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *teaImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *styleLab;
@property (weak, nonatomic) IBOutlet UILabel *listLab;
@property (weak, nonatomic) IBOutlet UIButton *favBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@end
@implementation TeaListTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    TeaListTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[TeaListTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"TeaListTableCell" owner:nil options:nil][0];
        [self.teaImg setLayerWithW:35 andColor:BordColor andBackW:0.00001];
        [self.styleLab setLayerWithW:6 andColor:BordColor andBackW:0.0001];
        [self.favBtn setLayerWithW:2 andColor:BordColor andBackW:0.5];
        [self.shareBtn setLayerWithW:2 andColor:BordColor andBackW:0.5];
    }
    return self;
}

- (void)setListInfo:(ShoppingListInfo *)listInfo{
    if (listInfo) {
        _listInfo = listInfo;
        NSString *url = [NSString stringWithFormat:@"%@%@",baseNet,_listInfo.imgUrl];
        [self.teaImg sd_setImageWithURL:[NSURL URLWithString:url]
                       placeholderImage:DefaultImage];
        self.titleLab.text = _listInfo.goodsName;
        self.listLab.text = [NSString stringWithFormat:@"%@ %@",_listInfo.deportName,_listInfo.typeName];
        self.styleLab.text = _listInfo.tagName;
        NSString *str = _listInfo.introduction;
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
        str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        self.infoLab.text = str;
    }
}

- (IBAction)favClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([[SaveUserInfoTool shared].id isKindOfClass:[NSString class]]) {
        params[@"userId"] = [SaveUserInfoTool shared].id;
    }
    params[@"goodsId"] = _listInfo.id;
    NSString *netUrl = [NSString stringWithFormat:@"%@api/user/goods/like",baseNet];
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"收藏成功"];
        }else{
            NSString *str = response.msg?response.msg:@"收藏失败";
            SHOWALERTVIEW(str);
        }
        sender.enabled = YES;
    } requestURL:netUrl params:params];
}

- (IBAction)shareClick:(id)sender {
    if (self.back) {
        self.back(2,YES);
    }
}

@end
