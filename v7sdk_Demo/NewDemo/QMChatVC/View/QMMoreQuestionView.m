//
//  QMMoreQuestionView.m
//  NewDemo
//
//  Created by ZCZ on 2021/6/9.
//

#import "QMMoreQuestionView.h"

@interface QMMoreQuestionView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *rootView;
@property (nonatomic, strong) UILabel *titiLab;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, copy) void(^selectItem)(NSString *);

@end

@implementation QMMoreQuestionView

+ (instancetype)sharedView {
    QMMoreQuestionView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:567];
    if (!view) {
        view = [[QMMoreQuestionView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        view.tag = 567;
        view.backgroundColor = k_qm_RGBA(31, 31, 31, 0.4);
        [view setupSubviews];
    }
    
    return view;
}

- (void)setupSubviews {
     self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 600*kScale6)];
    self.bgView.backgroundColor = k_QMRGB(245, 245, 245);
    [self addSubview:self.bgView];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"tip_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-10);
        make.width.height.mas_equalTo(30);
        make.top.mas_equalTo(5);
    }];
    
    
    [self.bgView addSubview:self.titiLab];
    [self.titiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.bgView);
        make.height.mas_equalTo(40).priorityHigh();
    }];
    
    [self.bgView addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgView);
        make.top.equalTo(self.titiLab.mas_bottom);
    }];
    
}

- (void)closeAction {
    [self hidden];
}

- (void)show:(NSDictionary *)dict completion:(void (^)(NSString * _Nonnull))completion {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.selectItem = completion;
    self.titiLab.text = dict[@"name"];
    self.datas = dict[@"list"];
    
    CGRect frame = self.bgView.frame;
    frame.origin.y = self.bounds.size.height - 600*kScale6;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame = frame;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
    }
    
    NSString *name = self.datas[indexPath.row];
    
    cell.textLabel.text = name;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:14];
    if ([cell.contentView viewWithTag:211] == nil) {
        UIView *line = [UIView new];
        line.tag = 211;
        [cell.contentView addSubview:line];
        line.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
            make.right.equalTo(cell.contentView).offset(-15);
            make.bottom.equalTo(cell.contentView).offset(-0.5);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    
    [self hidden];
    NSString *name = self.datas[indexPath.row];
    if (self.selectItem) {
        self.selectItem(name);
    }
}






- (void)hidden {
    CGRect frame = self.bgView.frame;
    frame.origin.y = self.bounds.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (UILabel *)titiLab {
    if (!_titiLab) {
        _titiLab = [UILabel new];
        _titiLab.font = [UIFont fontWithName:QM_PingFangSC_Med size:16];
        _titiLab.textColor = k_QMRGB(21, 21, 21);
    }
    return _titiLab;
}

- (UITableView *)rootView {
    if (!_rootView) {
        _rootView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _rootView.estimatedRowHeight = 60;
        _rootView.rowHeight = UITableViewAutomaticDimension;
        _rootView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rootView.tableFooterView = [UIView new];
        _rootView.dataSource = self;
        _rootView.delegate = self;
    }
    return _rootView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
