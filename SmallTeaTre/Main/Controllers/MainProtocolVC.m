//
//  MainProtocolVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "MainProtocolVC.h"

@interface MainProtocolVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MainProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isFir) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    if (self.content.length>0) {
        [self setDataWith:self.content];
        return;
    }
    [self loadHomeData];
}

- (void)loadHomeData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *netUrl = [NSString stringWithFormat:@"%@api/help/type/%@",baseNet,_typeId];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            [self setDataWith:response.result[0][@"content"]];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:netUrl params:params];
}

- (void)setDataWith:(NSString *)str{
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithData:
                [str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                          documentAttributes:nil error:nil];
    self.textView.attributedText = attributedString;
}

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
