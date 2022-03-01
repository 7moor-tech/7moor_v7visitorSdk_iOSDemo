//
//  QMSatisfactionModel.h
//  NewDemo
//
//  Created by lishuijiao on 2021/6/1.
//

#import <Foundation/Foundation.h>
@class QMSatisfactionRadio;

NS_ASSUME_NONNULL_BEGIN

@interface QMSatisfactionModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *thank;

@property (nonatomic, copy) NSString *radioTagText;

@property (nonatomic, copy) NSArray<QMSatisfactionRadio *> *radios;

@end


@interface QMSatisfactionRadio : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSArray *reason;

@property (nonatomic, copy) NSString *defaultName;

@property (nonatomic, copy) NSString *proposalStatus;

@end

NS_ASSUME_NONNULL_END
