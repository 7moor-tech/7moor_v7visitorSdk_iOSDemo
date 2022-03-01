//
//  AppDelegate.m
//  newDemo
//
//  Created by lishuijiao on 2021/1/5.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "QMChatEmojiManger.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle style = [UITraitCollection currentTraitCollection].userInterfaceStyle;
        QMThemeManager.shared.qmDarkStyle = style == UIUserInterfaceStyleDark;
    }
    
    
    
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle style = [UITraitCollection currentTraitCollection].userInterfaceStyle;
        QMThemeManager.shared.qmDarkStyle = style == UIUserInterfaceStyleDark;
    }
}

@end
