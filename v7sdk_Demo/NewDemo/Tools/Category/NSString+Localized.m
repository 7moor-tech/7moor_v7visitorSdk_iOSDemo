//
//  NSString+Localized.m
//  newDemo
//
//  Created by ZCZ on 2021/2/24.
//

#import "NSString+Localized.h"

@implementation NSString (Localized)
- (NSString *)toLocalized {
//    NSString *langPath = [NSBundle mainBundle] pathForResource:<#(nullable NSString *)#> ofType:<#(nullable NSString *)#>
    
    return NSLocalizedString(self, "");
}

- (NSString *)getLanguageFromSystem {
    NSString *language = NSLocale.preferredLanguages.firstObject ? : @"zh";
    if ([language hasPrefix:@"en"]) {
        return @"en";
    } else if ([language hasPrefix:@"zh"]) {
        return @"zh-Hans";
    }
    return  @"zh-Hans";
}

@end
