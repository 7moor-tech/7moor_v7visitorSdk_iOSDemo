//
//  QMRoomUIModel.m
//  newDemo
//
//  Created by lishuijiao on 2021/2/2.
//

#import "QMRoomUIManager.h"

@implementation QMRoomUIManager

+ (instancetype)shared {
    static QMRoomUIManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [QMRoomUIManager new];
        
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
        NSString *hx = [NSUserDefaults.standardUserDefaults valueForKey:@"QM_k_Color"];
        if (hx.length > 5) {
            _naviColorModel.hexColor = hx;
        }
    }
    return self;
}

+ (void)setNavigationColor:(UIColor *)color {
    [[QMRoomUIManager shared].naviColorModel setColor:color];
}

- (void)saveNavColorToDoc {
    [NSUserDefaults.standardUserDefaults setValue:self.naviColorModel.hexColor forKey:@"QM_k_Color"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)setAddViewValueFromOther:(QMRoomUIManager *)model {
    self.isHiddenFileBtn = model.isHiddenFileBtn;
    self.isHiddenPictureBtn = model.isHiddenPictureBtn;
    self.isHiddenEvaluateBtn = model.isHiddenEvaluateBtn;
    self.isHiddenQuestionBtn = model.isHiddenQuestionBtn;
    self.isHiddenVideoBtn = model.isHiddenVideoBtn;
    self.isHiddenCameraBtn = model.isHiddenCameraBtn;
    self.isHiddenCardBtn = model.isHiddenCardBtn;
}

- (void)showEvaluateBtn {
    self.isHiddenEvaluateBtn = NO;
}

@end

@implementation QMIconModel

@end

@implementation QMColorModel

- (instancetype)init {
    if (self = [super init]) {
        self.red = 255;
        self.blue = 255;
        self.green = 255;
        self.alpha = 255;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    QMColorModel *model = [QMColorModel new];
    model.color = self.color;
    return model;
}

- (void)setHexColor:(NSString *)hexColor {
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


@end
