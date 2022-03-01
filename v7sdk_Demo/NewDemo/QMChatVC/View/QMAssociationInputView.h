//
//  QMAssociationInputView.h
//  NewDemo
//
//  Created by lishuijiao on 2021/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AssociationBlock)(NSString *text);

@interface QMAssociationInputView : UIView

@property (nonatomic, copy) AssociationBlock associationBlock;

@property (nonatomic, copy) NSArray *dataSource;

@property (nonatomic, copy) NSString *keyword;

@end


@interface QMAssociationInputCell : UITableViewCell

- (void)setText:(NSString *)text withSelectText:(NSString *)selectText;

@end

NS_ASSUME_NONNULL_END
