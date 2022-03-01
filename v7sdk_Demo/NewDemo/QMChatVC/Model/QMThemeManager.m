//
//  QMRoomUIModel.m
//  newDemo
//
//  Created by lishuijiao on 2021/2/2.
//

#import "QMThemeManager.h"
#import "QMChatMoreView.h"

@implementation QMThemeManager

+ (instancetype)shared {
    static QMThemeManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [QMThemeManager new];
        _shared.isHiddenEvaluateBtn = YES;
        [[NSNotificationCenter defaultCenter] addObserver:_shared selector:@selector(showEvaluateBtn) name:CUSTOM_SATISFACTION_STATUS object:nil];
    });
    return _shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.iconModel = [[QMIconModel alloc] init];
        self.naviColorModel = [QMColorModel new];
        self.mainColorModel = [QMColorModel new];
        self.leftMsgBgColor = [QMColorModel new];
        self.leftMsgTextColor = [QMColorModel new];
        self.rightMsgTextColor = [QMColorModel new];
        self.rightMsgBgColor = [QMColorModel new];

        NSString *hx = [NSUserDefaults.standardUserDefaults valueForKey:@"QM_k_Color"];
        if (hx.length > 5) {
            _naviColorModel.hexColor = hx;
        }
    }
    return self;
}

+ (void)setNavigationColor:(UIColor *)color {
    [[QMThemeManager shared].naviColorModel setColor:color];
}

- (void)saveNavColorToDoc {
    [NSUserDefaults.standardUserDefaults setValue:self.naviColorModel.hexColor forKey:@"QM_k_Color"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)handelNetThemeColor:(NSDictionary *)themes {
    if (themes.count > 0) {
        self.mainColorModel.hexColor = [self themes:themes valueForKey:@"sdkMainThemeColor"];
        self.leftMsgBgColor.hexColor = [self themes:themes valueForKey:@"leftMsgBgColor"];
        self.leftMsgTextColor.hexColor = [self themes:themes valueForKey:@"leftMsgTextColor"];
        self.rightMsgBgColor.hexColor = [self themes:themes valueForKey:@"rightMsgBgColor"];
        self.rightMsgTextColor.hexColor = [self themes:themes valueForKey:@"rightMsgTextColor"];
        
        self.sdkTitleBarText = [self themes:themes valueForKey:@"sdkTitleBarText"];
        self.leftTitleBtnText = [self themes:themes valueForKey:@"leftTitleBtnText"];
        self.leftTitleBtnImgUrl = [self themes:themes valueForKey:@"leftTitleBtnImgUrl"];
        
        self.isTransferSeatsShow = [[self themes:themes valueForKey:@"isTransferSeatsShow"] boolValue];
        self.isCloseSeatsSessionShow = [[self themes:themes valueForKey:@"isCloseSeatsSessionShow"] boolValue];
        self.transferSeatsBtnText = [self themes:themes valueForKey:@"transferSeatsBtnText"];
        self.topNoticeText = [self themes:themes valueForKey:@"topNoticeText"];

        
        
        self.transferSeatsBtnImgUrl = [self themes:themes valueForKey:@"transferSeatsBtnImgUrl"];
        self.closeSeatsSessionBtnText = [self themes:themes valueForKey:@"closeSeatsSessionBtnText"];
        self.closeSeatsSessionBtnImgUrl = [self themes:themes valueForKey:@"closeSeatsSessionBtnImgUrl"];
        self.topNoticeText = [self themes:themes valueForKey:@"topNoticeText"];
        self.sysMsgHeadImgUrl = [self themes:themes valueForKey:@"sysMsgHeadImgUrl"];
        self.msgHeadImgType = [[self themes:themes valueForKey:@"msgHeadImgType"] lowercaseString];
        
        if ([self.msgHeadImgType isEqualToString:@"rectangle"]) {
            self.msgHeadImgAngle = QMMsgHeadImgAngleTypeRectAngle;
        } else if ([self.msgHeadImgType isEqualToString:@"round"] || [self.msgHeadImgType isEqualToString:@"circular"]) {
            self.msgHeadImgAngle = QMMsgHeadImgAngleTypeRound;
        } else {
            self.msgHeadImgAngle = QMMsgHeadImgAngleTypeNone;
        }
        
        
        self.inputViewHintText = [self themes:themes valueForKey:@"inputViewHintText"];

        self.isVoiceBtnShow = [[self themes:themes valueForKey:@"isVoiceBtnShow"] boolValue];
        self.isVoiceBtnImgUrl = [self themes:themes valueForKey:@"isVoiceBtnImgUrl"];
        self.isEmojiBtnShow = [[self themes:themes valueForKey:@"isEmojiBtnShow"] boolValue];
        self.isEmojiBtnImgUrl = [self themes:themes valueForKey:@"isEmojiBtnImgUrl"];
        self.moreFunctionImgUrl = [self themes:themes valueForKey:@"moreFunctionImgUrl"];
        self.showKeyboardImgUrl = [self themes:themes valueForKey:@"showKeyboardImgUrl"];
        self.sendMsgBtnImgUrl = [self themes:themes valueForKey:@"sendMsgBtnImgUrl"];
        
        self.isHiddenVoiceBtn = !self.isVoiceBtnShow;
        self.isHiddenFaceBtn = !self.isEmojiBtnShow;
        
    } else {
        self.mainColorModel.color = k_QMRGB(0, 125, 255);
        self.leftMsgBgColor.color = k_QMRGB(255, 255, 255);
        self.leftMsgTextColor.color = k_QMRGB(21, 21, 21);
        self.rightMsgBgColor.color = k_QMRGB(206, 230, 252);
        self.rightMsgTextColor.color = k_QMRGB(21, 21, 21);
        
        self.sdkTitleBarText = @"";
        self.leftTitleBtnText = @"";
        self.leftTitleBtnImgUrl = @"";
                
    }
    
    self.isHiddenEvaluateBtn = YES;
}

- (NSString *)themes:(NSDictionary *)dict valueForKey:(NSString *)key {
    if ([dict.allKeys containsObject:key]) {
        NSString *value = dict[key];
        if ([value isKindOfClass:NSNull.class]) {
            return @"";
        }
        return value;
    }
    return @"";
}

- (void)setAddViewValueFromOther:(QMThemeManager *)model {
    self.isHiddenFileBtn = model.isHiddenFileBtn;
    self.isHiddenPictureBtn = model.isHiddenPictureBtn;
    self.isHiddenEvaluateBtn = model.isHiddenEvaluateBtn;
    self.isHiddenQuestionBtn = model.isHiddenQuestionBtn;
    self.isHiddenVideoBtn = model.isHiddenVideoBtn;
    self.isHiddenCameraBtn = model.isHiddenCameraBtn;
}

- (void)showEvaluateBtn {
    self.isHiddenEvaluateBtn = NO;
}


@end

@implementation QMIconModel

@end

@interface QMColorModel ()
@property (nonatomic, assign) NSUInteger red;
@property (nonatomic, assign) NSUInteger green;
@property (nonatomic, assign) NSUInteger blue;
@property (nonatomic, assign) NSUInteger alpha;

@end

@implementation QMColorModel

- (instancetype)init {
    if (self = [super init]) {
        self.red = 255;
        self.blue = 255;
        self.green = 255;
        self.alpha = 255;
        self.hasBeenSetColor = NO;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    QMColorModel *model = [QMColorModel new];
    model.color = self.color;
    model.hasBeenSetColor = YES;
    return model;
}

- (void)setHexColor:(NSString *)hexColor {
    self.hasBeenSetColor = YES;
    NSString *hex = @"";
    if (hexColor.length == 6) {
        // "ffffff"
        hex = hexColor;
    } else if (hexColor.length == 7) {
        // "#ffffff"
        hex = [hexColor substringFromIndex:1];
    } else if (hexColor.length == 8) {
        if ([hexColor hasPrefix:@"0x"]) {
            // "0xffffaa"
            hex = [hexColor substringFromIndex:2];
        } else {
            // "ffffffaa"
            hex = hexColor;
        }
    } else if (hexColor.length == 9) {
        // "#ffffffaa"
        hex = [hexColor substringFromIndex:1];
    }
    
    self.red = strtol([hex substringWithRange:NSMakeRange(0, 2)].UTF8String, 0, 16);
    self.green = strtol([hex substringWithRange:NSMakeRange(2, 2)].UTF8String, 0, 16);
    self.blue = strtol([hex substringWithRange:NSMakeRange(4, 2)].UTF8String, 0, 16);
    if (hex.length == 8) {
        self.alpha = strtol([hex substringWithRange:NSMakeRange(6, 2)].UTF8String, 0, 16);
    }
    
    
}

- (NSString *)hexColor {
    NSString *hex = [NSString stringWithFormat:@"#%02lx%02lx%02lx%02lx",(long)self.red, (long)self.green, (long)self.blue, (long)self.alpha];
    return hex;
}

- (void)setColor:(UIColor *)color {
    if (color == nil) {
        return;
    }
    self.hasBeenSetColor = YES;
    NSString *rgbValue = [NSString stringWithFormat:@"%@", color];
    NSArray *rgbArr = [rgbValue componentsSeparatedByString:@" "];
    self.red = [[rgbArr objectAtIndex:1] doubleValue] * 255;
    self.green = [[rgbArr objectAtIndex:2] doubleValue] * 255;
    self.blue = [[rgbArr objectAtIndex:3] doubleValue] * 255;
    self.alpha = [[rgbArr objectAtIndex:4] doubleValue] * 255;

}

- (UIColor *)color {
    return [UIColor colorWithRed:self.red/255.0 green:self.green/255.0 blue:self.blue/255.0 alpha:self.alpha/255.0];
}

- (UIColor *)color:(CGFloat)alpha {
    return [UIColor colorWithRed:self.red/255.0 green:self.green/255.0 blue:self.blue/255.0 alpha:alpha];
}

@end
