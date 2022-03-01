//
//  QMChatRoomViewController+QMChatQuickFAQ.m
//  NewDemo
//
//  Created by ZCZ on 2021/6/2.
//

#import "QMChatRoomViewController+QMChatQuickFAQ.h"
#import <objc/runtime.h>
#import "QMChatRoomViewController+ChatMessage.h"
#import "QMWebViewController.h"
static void *faq_view = &faq_view;
static void *faq_data = &faq_data;

// 增加排队数取消功能2021/9/10
static void *faq_numBgView = &faq_numBgView;
static void *faq_cancelBtn = &faq_cancelBtn;
static void *faq_information = &faq_information;

// 排队数-lishuijao 2021/6/15
static void *num_label = &num_label;

@interface QMChatRoomViewController ()

@property (nonatomic, strong) UICollectionView *faqView;
@property (nonatomic, strong) NSArray *faqData;
@property (nonatomic, strong) UIView *numBgView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) QMChatInformation *queueInformation;

@end

@implementation QMChatRoomViewController (QMChatQuickFAQ)

- (void)showQuickFAQ {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.faqData.count == 0) {
            [self closeQuickFAQ];
        } else {
            
            if (!self.faqView) {
                UICollectionViewFlowLayout *flowlayout = [UICollectionViewFlowLayout new];
                flowlayout.estimatedItemSize = CGSizeMake(80, 30);
                flowlayout.sectionInset = UIEdgeInsetsMake(10, 8, 10, 8);
                flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                flowlayout.minimumInteritemSpacing = 10;
                
                UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.chatTableView.frame.size.height, self.chatTableView.frame.size.width, 50) collectionViewLayout:flowlayout];
                collectionView.backgroundColor = k_QMRGB(245, 245, 245);
                collectionView.showsHorizontalScrollIndicator = NO;
                [collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell_id"];
                self.faqView = collectionView;
                
                self.faqView.dataSource = self;
                self.faqView.delegate = self;
            }
        }
        
        [self.faqView reloadData];
        
        if (![self.view.subviews containsObject:self.faqView]) {
            [self.view addSubview:self.faqView];
            [UIView animateWithDuration:0.3 animations:^{
                [self.chatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.chatInputView.mas_top).offset(-50);
                }];
                
                [self.faqView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.view);
                    make.height.mas_equalTo(50);
                    make.top.equalTo(self.chatTableView.mas_bottom);
                }];
                                
            } completion:^(BOOL finished) {
                NSInteger count = [self.chatTableView numberOfRowsInSection:0];
                if (count > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
                    [UIView performWithoutAnimation:^{
                        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    }];
                }
            }];
            
        }

    });
}

- (void)setupQuickFAQ:(NSArray *)bottomList {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.faqData = bottomList;
        if (self.isRobot) {
            [self showQuickFAQ];
        }
    });

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.faqData.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_id" forIndexPath:indexPath];
    
    UILabel *lab = (UILabel *)[cell viewWithTag:120];
    if (!lab) {
        lab = [UILabel new];
        lab.tag = 120;
        lab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:13];
        lab.textColor = k_QMRGB(21, 21, 21);
        [cell.contentView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.centerY.equalTo(cell.contentView);
        }];
        
    }
    
    NSDictionary *dict = self.faqData[indexPath.row];
    lab.text = dict[@"button"];
    
    cell.layer.cornerRadius = 15;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = QMThemeManager.shared.mainColorModel.color.CGColor;
    cell.backgroundColor = UIColor.whiteColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = k_QMRGB(238, 238, 238);
    cell.layer.borderWidth = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cell.backgroundColor = k_QMRGB(255, 255, 255);
        cell.layer.borderWidth = 1;
    });

    NSDictionary *dict = self.faqData[indexPath.row];
    NSString *title = dict[@"text"];
    NSString *type  = [NSString stringWithFormat:@"%@",dict[@"buttonType"] ?: @""];
    if ([type isEqualToString:@"2"] && title) {
        QMWebViewController *webVC = [QMWebViewController new];
        webVC.url = [NSURL URLWithString:title];
        [self.navigationController pushViewController:webVC animated:YES];
    } else {
        [self sendTextMessage:title];
    }
    
}


- (void)setFaqView:(UICollectionView *)faqView {
    objc_setAssociatedObject(self, &faq_view, faqView, OBJC_ASSOCIATION_RETAIN);
}

- (UICollectionView *)faqView {
    return objc_getAssociatedObject(self, &faq_view);
}

- (void)setFaqData:(NSArray *)faqData {
    objc_setAssociatedObject(self, &faq_data, faqData, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray *)faqData {
    return objc_getAssociatedObject(self, &faq_data);
}

- (void)setNumBgView:(UIView *)numBgView {
    objc_setAssociatedObject(self, &faq_numBgView, numBgView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)numBgView {
    return objc_getAssociatedObject(self, &faq_numBgView);
}

- (void)setCancelBtn:(UIButton *)cancelBtn {
    objc_setAssociatedObject(self, &faq_cancelBtn, cancelBtn, OBJC_ASSOCIATION_RETAIN);
}

- (UIButton *)cancelBtn {
    return objc_getAssociatedObject(self, &faq_cancelBtn);
}

- (void)setupQueueNum:(QMChatInformation *)inform {
    self.queueInformation = inform;
    if (self.faqData.count > 0) {
        [self.chatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.chatInputView.mas_top).offset(-100);
        }];

    } else {
        if (self.chatTableView.superview) {
            [self.chatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.chatInputView.mas_top).offset(-50);
            }];
        }
    }
    
    if (!self.numBgView) {
        self.numBgView = [UIView new];
        self.numBgView.backgroundColor = [UIColor colorWithHexString:QMColor_Main_Bg_Light];
    }
    
    if (![self.view.subviews containsObject:self.numBgView]) {
        [self.view addSubview:self.numBgView];
        [self.numBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view).priority(999);
            make.centerX.equalTo(self.view);
            make.height.mas_equalTo(50);
            make.top.equalTo(self.chatTableView.mas_bottom);
        }];
        
        if (self.faqView.superview) {
            [self.faqView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.height.mas_equalTo(50);
                make.top.equalTo(self.numBgView.mas_bottom);
            }];
        }
        
    }
    
    if (!self.numLabel) {
        self.numLabel = [[UILabel alloc] init];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.backgroundColor = [UIColor colorWithHexString:QMColor_Main_Bg_Light];

    }
    
    NSString *textStr = [NSString stringWithFormat:@"您当前排在第%@位，请稍后~", inform.number];
    if (inform.queueTips.length > 0) {
        textStr = [inform.queueTips stringByReplacingOccurrencesOfString:@"{num}" withString:inform.number.stringValue];
    }
    self.numLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:12];
    NSAttributedString *attrStr = [NSAttributedString colorAttributeString:textStr
                                                          sourceSringColor:[UIColor colorWithHexString:QMColor_999999_text] sourceFont:[UIFont systemFontOfSize:12]
                                                              keyWordArray:@[[inform.number stringValue]]
                                                              keyWordColor:[UIColor colorWithHexString:QMColor_News_Custom]
                                                               keyWordFont:[UIFont systemFontOfSize:12]];
    self.numLabel.attributedText = attrStr;

    
    if (![self.numBgView.subviews containsObject:self.numLabel]) {
        [self.numBgView addSubview:self.numLabel];
        
    }
    
    if (inform.isShowCancelQueue) {
        CGFloat cancelBtn_w = 16 + 12 + 4.5;
        
        if (!self.cancelBtn) {
            self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancelQueue"]];
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            iconView.userInteractionEnabled = YES;
            iconView.backgroundColor = QMThemeManager.shared.mainColorModel.color;
            [self.cancelBtn addSubview:iconView];
            
            UILabel *lab = [UILabel new];
            lab.text = @"退出排队".toLocalized;
            lab.tag = 301;
            lab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:10];
            lab.textColor = [UIColor colorWithHexString:@"#151515"];
            [self.cancelBtn addSubview:lab];
            
            CGFloat w = [lab sizeThatFits:CGSizeMake(150, 25)].width;
            
            self.cancelBtn.layer.cornerRadius = 25/2.0;
            self.cancelBtn.layer.borderWidth = 1;
            self.cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
            
            [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.cancelBtn).offset(8);
                make.height.width.mas_equalTo(12);
                make.centerY.equalTo(self.cancelBtn);
            }];
            
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(iconView.mas_right).offset(4.5);
                make.height.equalTo(self.cancelBtn);
                make.right.equalTo(self.cancelBtn).offset(-8);
                make.width.mas_equalTo(w);
                make.centerY.equalTo(self.cancelBtn);
            }];
            
            cancelBtn_w += w;
        }
        
        if (![self.numBgView.subviews containsObject:self.cancelBtn]) {
            [self.numBgView addSubview:self.cancelBtn];
            self.cancelBtn.layer.borderWidth = 1;

        }
        
        [self.numLabel sizeToFit];
        CGFloat off_centerX = -(cancelBtn_w + 6)/2;
 
        [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(self.numBgView);
            make.centerY.equalTo(self.numBgView);
            make.centerX.equalTo(self.numBgView).offset(off_centerX);
        }];
        
        [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.numLabel.mas_right).offset(6);
            make.centerY.equalTo(self.numBgView);
            make.right.lessThanOrEqualTo(self.numBgView);
            make.width.mas_equalTo(cancelBtn_w).priorityHigh();
            make.height.mas_equalTo(25);
        }];
    } else {
        [self.cancelBtn removeFromSuperview];
        self.cancelBtn = nil;
        [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(self.numBgView);
            make.right.lessThanOrEqualTo(self.numBgView);
            make.centerY.equalTo(self.numBgView);
            make.centerX.equalTo(self.numBgView);
        }];
    }
    

}

- (void)closeQuickFAQ {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.chatTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.faqView removeFromSuperview];
        
        if (CGRectGetHeight(self.numBgView.frame) > 0 && self.numBgView.superview) {
            [self.chatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.chatInputView.mas_top).offset(-50);
            }];
        }else {
            [self.chatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.chatInputView.mas_top);
            }];
        }
    });
}

- (void)closeQueueNum {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.chatTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.numBgView removeFromSuperview];
        
        if (self.faqData.count > 0 && self.faqView.superview) {
            
            [self.chatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.chatInputView.mas_top).offset(-50);
            }];
            
            if (self.faqView.superview) {
                
                [self.faqView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.view);
                    make.height.mas_equalTo(50);
                    make.top.equalTo(self.chatTableView.mas_bottom);
                }];
            }
        }else {
            
            [self.chatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.chatInputView.mas_top);
            }];
        }
    });
}

- (void)cancelAction:(UIButton *)sender {
    if (self.queueInformation) {
        
        [QMConnect sdkCancelQueue:self.queueInformation.sessionId completion:^(id  _Nonnull dict) {
            if ([dict[@"success"] intValue] == 1) {
                [self closeQueueNum];
                self.queueInformation = nil;
                NSDictionary *data = dict[@"data"];
                NSString *time = data[@"time"];
                if (![time isKindOfClass:[NSString class]] || time.length == 0) {
                    NSDate *date = [[NSDate alloc] init];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                    formatter.locale = locale;
                    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    time = [formatter stringFromDate:date];
                }

                NSString *content = [NSString stringWithFormat:@"%@ %@",time,@"访客已退出排队"];
                [QMConnect sendRemindMessage:content];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.cancelBtn removeFromSuperview];
                    self.cancelBtn = nil;
                });

                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [QMRemind showMessage:@"退出排队失败".toLocalized];
                });
            }
        } failure:^(NSError * err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [QMRemind showMessage:@"退出排队失败".toLocalized];
            });
        }];
    }
}

- (void)setNumLabel:(UILabel *)numLabel {
    objc_setAssociatedObject(self, &num_label, numLabel, OBJC_ASSOCIATION_RETAIN);
}

- (UILabel *)numLabel {
    return objc_getAssociatedObject(self, &num_label);
}

- (void)setQueueInformation:(QMChatInformation *)queueInformation {
    NSString *json = [queueInformation yy_modelToJSONString];
    objc_setAssociatedObject(self, &faq_information, json, OBJC_ASSOCIATION_RETAIN);
}

- (QMChatInformation *)queueInformation {
    NSString * json = objc_getAssociatedObject(self, &faq_information);
    QMChatInformation *model = [QMChatInformation yy_modelWithJSON:json];
    if ([model isKindOfClass:[QMChatInformation class]]) {
        return model;
    }
    return nil;
}

@end
