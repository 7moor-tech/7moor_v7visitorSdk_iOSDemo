//
//  moorV7SDK.h
//  moorV7SDK
//
//  Created by lishuijiao on 2021/1/5.
//

#import <Foundation/Foundation.h>

//! Project version number for moorV7SDK.
FOUNDATION_EXPORT double moorV7SDKVersionNumber;

//! Project version string for moorV7SDK.
FOUNDATION_EXPORT const unsigned char moorV7SDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <MoorV7SDK/PublicHeader.h>

#import <MoorV7SDK/QMConnect.h>
#import <MoorV7SDK/QMClient.h>
#import <MoorV7SDK/QMClientModel.h>
#import <MoorV7SDK/QMMessageDelegate.h>
#import <MoorV7SDK/QMErrorCode.h>
#import <MoorV7SDK/QMAgentInformation.h>
#import <MoorV7SDK/QMMessageModel.h>
#import <MoorV7SDK/QMChatFileTextAttachment.h>



/**
 *  满意度评价按钮
 */
#define CUSTOM_SATISFACTION_STATUS @"customSatisfactionStaus"

/**
 *  转人工按钮
 */
#define CUSTOM_MANUALBTN_STATUS @"customManualBtnStatus"

/**
 *  机器人联想输入
 */
#define CUSTOM_ASSOCIATIONSINPUT_STATUS @"customAssociationInputStatus"

/**
 *  已读刷新
 */
#define CUSTOM_MESSAGERELOAD_STATUS @"customMessageAlreadReload"
/**
 *  撤回消息通知
 */
#define CUSTOM_MESSAGEWITHDRAW_STATUS @"customMessageWithdrawMessage"
