//
//  HomePageHeadView.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/6.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "HomePageHeadView.h"
#import "HYBLoopScrollView.h"
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
                               CGRectMake(0, 0, SDevWidth, 204) imageUrls:arr];
//    [loop.pageControl setValue:[UIImage imageNamed:@"banner_s"] forKeyPath:@"pageImage"];
//    [loop.pageControl setValue:[UIImage imageNamed:@"banner_m"] forKeyPath:@"currentPageImage"];
    loop.timeInterval = 3.0;
    loop.didSelectItemBlock = ^(NSInteger atIndex,HYBLoadImageView  *sender){
        
    };
    loop.alignment = kPageControlAlignRight;
    [self addSubview:loop];
}

- (void)setInfoArr:(NSArray *)infoArr{
    if (infoArr) {
        _infoArr = infoArr;
        NSMutableArray *mutA = [NSMutableArray new];
        for (NSDictionary *dic in _infoArr) {
            [mutA addObject:dic[@"pic"]];
        }
        [self setLoopScrollView:mutA];
    }
}

@end
