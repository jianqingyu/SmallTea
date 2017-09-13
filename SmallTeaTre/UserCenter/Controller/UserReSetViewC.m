//
//  UserReSetViewC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserReSetViewC.h"
#import "CommonUsedTool.h"
#import "UserEditNameVC.h"
#import "CustomChoosePhotoV.h"
#import "UserEditPasswordVC.h"
#import "CustomBackgroundView.h"
@interface UserReSetViewC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak,  nonatomic) CustomBackgroundView *baView;
@property (assign,nonatomic) CGFloat height;
@property (weak,  nonatomic) CustomChoosePhotoV *shareView;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,  copy)NSString *url;
@end

@implementation UserReSetViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.height = 135;
    [self creatBaseView];
}

- (void)creatBaseView{
    CustomBackgroundView *bView = [CustomBackgroundView createBackView];
    bView.hidden = YES;
    [self.view addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.baView = bView;
    
    CustomChoosePhotoV *infoV = [CustomChoosePhotoV creatCustomView];
    infoV.picBack = ^(NSInteger staue){
        switch (staue) {
            case 0:
                [self openAlbum];
                break;
            case 1:
                [self openCamera];
                break;
            default:
                [self changeStoreView:YES];
                break;
        }
    };
    [self.view addSubview:infoV];
    [infoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(self.height);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(135);
    }];
    self.shareView = infoV;
}

- (void)shareShopClick {
    [self changeStoreView:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self changeStoreView:YES];
}

- (void)changeStoreView:(BOOL)isClose{
    BOOL isHi = YES;
    if (self.height==135) {
        if (isClose) {
            return;
        }
        self.height = 0;
        isHi = NO;
    }else{
        self.height = 135;
        isHi = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(self.height);
        }];
        [self.shareView layoutIfNeeded];//强制绘制
        self.baView.hidden = isHi;
    }];
}
//- (void)loadUserInfoData{
//    [SVProgressHUD show];
//    NSString *regiUrl = [NSString stringWithFormat:@"%@userModifyPage",baseUrl];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"tokenKey"] = [AccountTool account].tokenKey;
//    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
//        if ([response.error intValue]==0) {
//            if ([YQObjectBool boolForObject:response.data]) {
//                self.masterInfo = [MasterCountInfo objectWithKeyValues:response.data];
//                if ([YQObjectBool boolForObject:response.data[@"headPic"]]) {
//                    self.url = response.data[@"headPic"];
//                }
//                if ([YQObjectBool boolForObject:response.data[@"userName"]]) {
//                    self.mutDic[@"用户名"] = response.data[@"userName"];
//                }
//                if ([YQObjectBool boolForObject:response.data[@"phone"]]) {
//                    self.mutDic[@"修改手机号码"] = response.data[@"phone"];
//                }
//                if ([YQObjectBool boolForObject:response.data[@"address"]]) {
//                    self.mutDic[@"管理地址"] = response.data[@"address"];
//                }
//                [self.tableView reloadData];
//            }
//        }
//        [SVProgressHUD dismiss];
//    } requestURL:regiUrl params:params];
//}
- (IBAction)openImage:(id)sender {
    [self shareShopClick];
}

- (IBAction)editName:(id)sender {
    UserEditNameVC *editName = [UserEditNameVC new];
    [self.navigationController pushViewController:editName animated:YES];
}

- (IBAction)editPass:(id)sender {
    UserEditPasswordVC *editPass = [UserEditPasswordVC new];
    [self.navigationController pushViewController:editPass animated:YES];
}

- (UIImageView *)creatImageView{
    CGFloat width = 70;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width,width)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    //设置头像
    if (self.image) {
        imageView.image = self.image;
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.url]placeholderImage:
         [UIImage imageNamed:@"head_nor"]];
    }
    [imageView setLayerWithW:35 andColor:[UIColor whiteColor] andBackW:3.0f];
    return imageView;
}

- (void)creatUIAlertView{
    [NewUIAlertTool creatActionSheetPhoto:^{
        [self openAlbum];
    } andCamera:^{
        [self openCamera];
    } andCon:self andView:nil];
}

//打开相机
- (void)openCamera{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}
//打开相册
//TypePhotoLibrary > TypeSavedPhotosAlbum
- (void)openAlbum{
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}
//通过imagePickerController获取图片
- (void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = type;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:ipc animated:YES completion:nil];
        [self changeStoreView:YES];
    }];
}

#pragma mark -- UIImagePickerControllerDelagate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //info中包含选择的图片 UIImagePickerControllerOriginalImage
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self loadUpDateImage:image];
    }];
}
//上传图片
- (void)loadUpDateImage:(UIImage *)image{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *key = [AccountTool account].tokenKey;
    NSString *url = [NSString stringWithFormat:@"%@userModifyHeadPicDo?tokenKey=%@",baseNet,key];
    [CommonUsedTool loadUpDate:^(NSDictionary *response, NSError *error) {
        NSString *imageStr;
        if ([response[@"error"]intValue]==0) {
            if ([YQObjectBool boolForObject:response[@"data"][@"headPic"]]) {
                imageStr = response[@"data"][@"headPic"];
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
            }];
        }
    } image:image Dic:params Url:url];
}

@end
