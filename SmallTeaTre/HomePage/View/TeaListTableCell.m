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

- (IBAction)favClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.back) {
        self.back(1,sender.selected);
    }
}

- (IBAction)shareClick:(id)sender {
    if (self.back) {
        self.back(2,YES);
    }
}

@end
