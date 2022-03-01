//
//  QMAssociationInputView.m
//  NewDemo
//
//  Created by lishuijiao on 2021/6/8.
//

#import "QMAssociationInputView.h"

@interface QMAssociationInputView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation QMAssociationInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        [self addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(300).priorityLow();
            make.left.right.equalTo(self);
            make.height.mas_lessThanOrEqualTo(QM_kScreenHeight - 300);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(dataSource.count * 50);
    }];
    
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.estimatedRowHeight = 50;
        [_tableView registerClass:[QMAssociationInputCell class] forCellReuseIdentifier:NSStringFromClass([QMAssociationInputCell class])];
    }
    return _tableView;
}


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMAssociationInputCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QMAssociationInputCell.class) forIndexPath:indexPath];
    [cell setText:self.dataSource[indexPath.row] withSelectText:self.keyword];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (self.associationBlock) {
        self.associationBlock(self.dataSource[indexPath.row]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end



@interface QMAssociationInputCell ()

@property (nonatomic, strong) UILabel *questionLabel;

@end

@implementation QMAssociationInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.questionLabel];
        self.questionLabel.frame = CGRectMake(15, 15, self.frame.size.width - 30, 20);
    }
    return self;
}

- (UILabel *)questionLabel {
    if (!_questionLabel) {
        _questionLabel = [[UILabel alloc] init];
        _questionLabel.text = @"";
        _questionLabel.font = [UIFont systemFontOfSize:15];
        _questionLabel.textColor = [UIColor colorWithHexString:QMColor_666666_text];
    }
    return _questionLabel;
}

- (void)setText:(NSString *)text withSelectText:(NSString *)selectText {
    
    NSAttributedString *attrStr = [NSAttributedString colorAttributeString:text
                                                          sourceSringColor:[UIColor colorWithHexString:QMColor_666666_text] sourceFont:[UIFont systemFontOfSize:15]
                                                              keyWordArray:@[selectText]
                                                              keyWordColor:[UIColor colorWithHexString:QMColor_News_Custom]
                                                               keyWordFont:[UIFont systemFontOfSize:15]];
    
    self.questionLabel.attributedText = attrStr;
}

@end
