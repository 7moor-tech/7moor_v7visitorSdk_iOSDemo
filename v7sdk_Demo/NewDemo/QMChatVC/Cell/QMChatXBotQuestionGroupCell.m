//
//  QMChatXBotQuestionGroupCell.m
//  NewDemo
//
//  Created by ZCZ on 2021/5/25.
//

#import "QMChatXBotQuestionGroupCell.h"
#import "QMSegmentView.h"
#import "UIImage+Color.h"

@interface QMChatXBotQuestionGroupCell ()
    
@property (nonatomic, strong) QMQuestionListView *rootView;


@end

@implementation QMChatXBotQuestionGroupCell


- (void)setupSubviews {
    self.backgroundColor = UIColor.clearColor;
    self.rootView = [QMQuestionListView new];
    self.rootView.backgroundColor = UIColor.whiteColor;
    self.rootView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12*kScale6);
        make.right.equalTo(self.contentView).offset(-12*kScale6);
        make.top.equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(5*44 + 100 + 40);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    

}

- (void)setShowAllAction:(void (^)(NSDictionary *))showAllAction {
    _showAllAction = showAllAction;
    self.rootView.showAllAction = showAllAction;
    __weak typeof(self)wSelf = self;
    self.rootView.upCellConstraint = ^{
        if (wSelf.upCellConstraint) {
            wSelf.upCellConstraint(nil);
        }
    };
    
    self.rootView.sendText = self.sendText;
}



- (void)setCellData:(QMChatMessage *)model {
    NSDictionary *dict = model.commonQuestionsGroup.firstObject;
    if (dict) {
        NSArray *list = dict[@"list"];
        NSInteger count = list.count > 5 ? 5 : list.count;
        [self.rootView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(count*44 + 100 + 40);
        }];
    }

    NSURL *url = [NSURL URLWithString:model.commonQuestionsImg ? : @""];
    [self.rootView.loginImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"qm_question"]];
    self.rootView.commonQuestionsGroup = model.commonQuestionsGroup;
}


- (void)setupGestureRecognizer {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@interface QMQuestionListView () <SegmentViewDelegate, UITableViewDataSource, UITableViewDelegate>
// 常见问题点击事件列表
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, assign) BOOL showAll;
@property (nonatomic, assign) NSInteger lastIndex;
// 分组切换
@property (nonatomic, strong) QMSegmentView *segment;
// 打开更多
@property (nonatomic, strong) UIButton *showAllBtn;
@end

@implementation QMQuestionListView

- (instancetype)init {
    if (self = [super init]) {
        self.clipsToBounds = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    self.loginImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qm_question"]];
    self.loginImage.contentMode = UIViewContentModeScaleAspectFill;
    self.loginImage.backgroundColor = QMThemeManager.shared.mainColorModel.color;
    [self addSubview:self.loginImage];
    
    [self.loginImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(160);
    }];
    
    self.segment = [QMSegmentView new];
    self.segment.vernierHeight = 2.0;
    self.segment.titleSelectedFont = [UIFont fontWithName:QM_PingFangTC_Sem size:16];
    self.segment.titleNomalFont = [UIFont fontWithName:QM_PingFangTC_Sem size:16];
    self.segment.titleSelectedColor = QMThemeManager.shared.mainColorModel.color;
    self.segment.titleSelectedColor = QMThemeManager.shared.mainColorModel.color;
    self.segment.delegate = self;
//    segment.titles = @[@"机票问题",@"酒店问题",@"会员问题"];
    [self addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.loginImage.mas_bottom).offset(4);
        make.height.mas_equalTo(46);
    }];
    
    [self addSubview:self.listView];
    
    int count = 5;
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.segment.mas_bottom);
        make.height.mas_equalTo(44*count);
    }];
    
    
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showBtn setTitle:@"查看更多"
             forState:UIControlStateNormal];
    if (QMThemeManager.shared.mainColorModel.hasBeenSetColor) {
        [showBtn setTitleColor:QMThemeManager.shared.mainColorModel.color forState:UIControlStateNormal];
    } else {
        [showBtn setTitleColor:k_QMRGB(0, 129, 255)
                      forState:UIControlStateNormal];
    }
    [showBtn setTitleColor:k_qm_RGBA(0, 80, 255, 0.7)
                  forState:UIControlStateHighlighted];
    [showBtn setBackgroundImage:[UIImage imageFromColor:UIColor.whiteColor]
                       forState:UIControlStateNormal];
    [showBtn setBackgroundImage:[UIImage imageFromColor:k_QMRGB(220, 220, 220)]
                       forState:UIControlStateHighlighted];


    showBtn.titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:13];
    [showBtn addTarget:self action:@selector(showAllAction:) forControlEvents:UIControlEventTouchUpInside];
    self.showAllBtn = showBtn;
    [self addSubview:showBtn];

    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listView.mas_bottom);
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(40);
    }];

    _lastIndex = 0;
}

- (void)setCommonQuestionsGroup:(NSArray *)commonQuestionsGroup {
    _commonQuestionsGroup = commonQuestionsGroup;

    NSArray *titles = [commonQuestionsGroup valueForKeyPath:@"name"];
    self.segment.titles = titles;
    [self.listView reloadData];
}



- (void)setShowAllAction:(void (^)(NSDictionary *))showAllAction {
    _showAllAction = showAllAction;
}


- (void)showAllAction:(UIButton *)sender {
    
    if (self.showAllAction) {
        NSDictionary *dict = self.commonQuestionsGroup[self.lastIndex];
        self.showAllAction(dict);
    }
    
//    [self.listView reloadData];
}

#pragma mark - header点击切换
- (void)segmentViewDidSelectedItemAtIndex:(NSInteger)index {
  
    if (index != _lastIndex) {
        CATransition *ani = [CATransition animation];
        ani.type = kCATransitionPush;
        ani.duration = 0.25;
        if (index > _lastIndex) {
            ani.subtype = kCATransitionFromRight;
        } else {
            ani.subtype = kCATransitionFromLeft;
        }
        ani.removedOnCompletion = YES;
        ani.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        
        [self.listView.layer addAnimation:ani forKey:@"124"];
    }
    
    _lastIndex = index;
    
    
    //    {
    //切换数据源----
    //    }
    NSDictionary *dict = self.commonQuestionsGroup[self.lastIndex];
    NSArray *list = dict[@"list"];
    NSUInteger count = list.count;
    if (count <= 5) {
        self.showAllBtn.hidden = YES;
    } else {
        count = 5;
        self.showAllBtn.hidden = NO;
    }
    
    [self.listView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44*count);
    }];
    
    if (self.upCellConstraint) {
        self.upCellConstraint();
    }
    
    [self.listView reloadData];
}

#pragma mark - list-delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = self.commonQuestionsGroup[self.lastIndex];
    NSArray *list = dict[@"list"];
    return list.count > 5 ? 5 : list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
        cell.textLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:15];
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dottedline"]];
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell);
            make.left.equalTo(cell).offset(20);
            make.right.equalTo(cell).offset(-20);
            make.height.mas_equalTo(1);
        }];
    }
    NSDictionary *dict = self.commonQuestionsGroup[self.lastIndex];
    NSArray *list = dict[@"list"];
    cell.backgroundColor = UIColor.whiteColor;
    cell.textLabel.textColor = k_QMRGB(21, 21, 21);
    cell.textLabel.text = list[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    
    NSDictionary *dict = self.commonQuestionsGroup[self.lastIndex];
    NSArray *list = dict[@"list"];
    if (self.sendText) {
        self.sendText(list[indexPath.row]);
    }
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.tableFooterView = [UIView new];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.showsVerticalScrollIndicator = NO;
    }
    return _listView;
}

@end
