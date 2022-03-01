//
//  ViewController.m
//  newDemo
//
//  Created by lishuijiao on 2021/1/5.
//

#import "ViewController.h"
#import "QMChatRoomViewController.h"
#import "SettingViewController.h"
#import "QMLoadingHUD.h"
#import "UIImage+Color.h"
#import "QMChatEmojiManger.h"


static NSString *k_qm_accessId = @"accessId";

@interface ViewController ()<QMRegisterDelegate>

@property (nonatomic, strong) UIButton *customButton;
@end

@implementation ViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    

    [self layoutViews];
    
}

- (void)layoutViews {
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"7moor_logo"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-70);
        make.width.mas_equalTo(208);
        make.height.mas_equalTo(200);
    }];
    
    [self.customButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-80);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
    }];
    
//    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
//    [setBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
//    [setBtn addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:setBtn];
    
//    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradual"]];
//    [self.customButton addSubview:bgView];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.customButton);
//    }];
    
//    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.customButton.mas_bottom).offset(60);
//        make.centerX.equalTo(self.customButton);
//        make.width.mas_equalTo(50);
//        make.height.mas_equalTo(30);
//    }];
    
    
}

- (UIButton *)customButton {
    if (!_customButton) {
        _customButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        button.frame = CGRectMake(25, QM_kScreenHeight - 100, QM_kScreenWidth - 50, 50);
//        _customButton.backgroundColor = [UIColor colorWithHexString:@"#0081FF"];
        [_customButton setTitle:@"点击咨询" forState:UIControlStateNormal];
        [_customButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_customButton setBackgroundImage:[UIImage imageFromColor:k_QMRGB(0, 170, 134)] forState:UIControlStateNormal];
        _customButton.titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Med size:18];
        [_customButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _customButton.layer.cornerRadius = 8;
        _customButton.clipsToBounds = YES;
        [self.view addSubview:_customButton];
    }
    return _customButton;
}

- (void)settingAction:(UIButton *)sender {
    SettingViewController *setVC = [SettingViewController new];
    
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)buttonAction:(UIButton *)button {
    
    [self getThemeColor];

}

- (void)getThemeColor {
    if (k_qm_accessId.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"请检查AccessId" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:sureAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [QMLoadingHUD loading];
    [QMConnect sdkGetThemeConfig:@{@"accessId":k_qm_accessId} completion:^(id dict) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = dict[@"data"];
            NSDictionary *CssTmp = data[@"sdkChannelCssTmp"];
            NSDictionary *sessionWindow = CssTmp[@"sessionWindow"];
            NSString *account = [CssTmp objectForKey:@"account"];
            [[QMThemeManager shared] setAccount:account];
            [[QMThemeManager shared] handelNetThemeColor:sessionWindow];
            NSDictionary *globalConfig = data[@"globalConfig"];

            [QMThemeManager shared].isHiddenAddBtn = NO;
            if ([globalConfig isKindOfClass:[NSDictionary class]]) {
                QMThemeManager.shared.isVisitorTypeNotice = [globalConfig[@"isVisitorTypeNotice"] boolValue];
                [QMThemeManager shared].isShowRead = [globalConfig[@"isAgentReadMessage"] boolValue];
            }
            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MoorV7Bundle" ofType:@"bundle"];
            NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
            [QMConnect sdkReceiveImageBundle:bundle];
            
            [self registerSDK];
        }
        
    } failure:^(NSError * err) {
        NSLog(@"dict = %@",err.localizedDescription);
    }];
}

- (void)registerSDK {
    
    NSUserDefaults *defualt = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defualt stringForKey:@"k_userID"];
    NSString *userName = [defualt stringForKey:@"k_userName"];

    if (userId.length == 0) {
        NSString *uuid = [NSUUID UUID].UUIDString;
        if (uuid.length > 8) {
            uuid = [uuid substringToIndex:8];
        }
        userId = [NSString stringWithFormat:@"qme%@",uuid];
        [defualt setValue:userId forKey:@"k_userID"];
        userName = [@"测试" stringByAppendingFormat:@"%d", arc4random()% 10];
        [defualt setValue:userName forKey:@"k_userName"];
        [defualt synchronize];

    }
    
    [[QMClient shared] initSDKWithModel:^(QMClientModel * _Nonnull server) {
        server.accessId = k_qm_accessId;
//        server.userName = @"星语";
//        server.userId = @"53213566";
        
        server.userName = userName;
        server.userId = userId;

        server.visitorHeadImg = @"http://test-bucket.dmallcdn.com/userIcon/202101252008/aaf8f289-12c8-4939-be05-656fbd0c7fbf";
        server.account = QMThemeManager.shared.account;
        [QMChatManager.shared setDelegate];
    } completion:^(NSDictionary * dict) {
        if (dict && [dict[@"success"] intValue] == 1) {
            [self registerSuccess];
        } else {
            [self registerFailure:dict];
        }
    }];
    
//    [[QMClient shared] initSDK:self block:^(QMClientModel * _Nonnull server) {
//        server.accessId = k_qm_accessId;
////        server.userName = userName;
////        server.userId = userId;
//        server.userName = @"星语";
//        server.userId = @"53213566";
//        server.visitorHeadImg = @"http://test-bucket.dmallcdn.com/userIcon/202101252008/aaf8f289-12c8-4939-be05-656fbd0c7fbf";
//        server.account = QMThemeManager.shared.account;
//        [QMChatManager.shared setDelegate];
////        server.account = @"4000343";
//    }];
    
}

- (void)registerSuccess {
    
    __weak typeof(self)wSelf = self;
    [QMConnect sdkGetEmojiRUL:^(NSDictionary * _Nonnull data) {
        [QMChatEmojiManger.shared handleEmojiData:data completion:^{
            
            [wSelf newSession];
        }];

    } failure:^(NSDictionary * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMRemind showMessage:@"获取表情失败"];
        });
    }];
    
}

- (void)registerFailure:(NSDictionary *)reason {
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMLoadingHUD hidden];
    });

}

- (void)newSession {

    [QMConnect sdkNewSession:^(NSDictionary * _Nonnull data) {
        [self pushViewController];
    } failure:^(NSDictionary * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = [error valueForKey:@"message"];
            [QMLoadingHUD hidden];
            if (message.length > 0) {
                [QMRemind showMessage:message];
            }
            [[QMClient shared] disconnectSocket];

        });
    }];

}

- (void)pushViewController {


//    model.logoutTitle = @"返回";
//    model.iconModel.isIcon = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMLoadingHUD hidden];

        QMChatRoomViewController *chatVC = [QMChatRoomViewController new];
        chatVC.title = @"在线客服";
        [self.navigationController pushViewController:chatVC animated:YES];
    });
}

@end
