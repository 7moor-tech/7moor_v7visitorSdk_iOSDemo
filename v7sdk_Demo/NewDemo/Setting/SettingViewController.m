//
//  SettingViewController.m
//  newDemo
//
//  Created by ZCZ on 2021/3/1.
//

#import "SettingViewController.h"
#import "QMThemeManager.h"
#import "SettingCell.h"
#import "QMUIItem.h"
#import "SetColorView.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray <NSArray *>*keysArr;
@property (nonatomic, strong) UITableView *tabV;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
            
    [self defualtData];
    
    [self setupViews];
}

- (void)defualtData {
    self.keysArr = [NSMutableArray array];
    NSArray *items = @[
    @[@(SettModeNav).description,
      @(SettModeCustomer).description,
      @(SettModeLogout).description],
    @[
        @(SettModeVoice).description,
        @(SettModeEmj).description.description,
        @(SettModeExtend).description,
        @(SettModePic).description,
        @(SettModeVideo).description,
        @(SettModeFile).description,
        @(SettModeQuestion).description,
        @(SettModeEvaluate).description
    ]];
    for (NSArray *titles in items) {
        NSMutableArray *arr = [NSMutableArray array];
        for (id mode in titles) {
            QMUIItem *item = [QMUIItem new];
            item.color = [QMColorModel new];
            item.mode = [mode intValue];;
            
            switch (item.mode) {
                case SettModeNav:
                    item.color.hexColor = QMThemeManager.shared.naviColorModel.hexColor;
                    break;
                case SettModeCustomer:
                    item.color.color = QMThemeManager.shared.manualColor;
                    break;
                case SettModeLogout:
                    item.color.color = QMThemeManager.shared.logoutColor;
                    break;
                case SettModeEmj:
                    item.isHidden = QMThemeManager.shared.isHiddenFaceBtn;
                    break;
                case SettModeVoice:
                    item.isHidden = QMThemeManager.shared.isHiddenVoiceBtn;
                    break;
                case SettModeExtend:
                    item.isHidden = QMThemeManager.shared.isHiddenAddBtn;
                    break;
                case SettModePic:
                    item.isHidden = QMThemeManager.shared.isHiddenPictureBtn;
                    break;
                case SettModeVideo:
                    item.isHidden = QMThemeManager.shared.isHiddenVideoBtn;
                    break;
                case SettModeFile:
                    item.isHidden = QMThemeManager.shared.isHiddenFileBtn;
                    break;
                case SettModeQuestion:
                    item.isHidden = QMThemeManager.shared.isHiddenQuestionBtn;
                    break;
                case SettModeEvaluate:
                    item.isHidden = QMThemeManager.shared.isHiddenEvaluateBtn;

                    break;
                default:
                    break;
            }
            
            [arr addObject:item];
        }
        [self.keysArr addObject:arr];
    }


}

- (void)setupViews {
    [self.view addSubview:self.tabV];
    [self.tabV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)saveSetting {
    
}

#pragma mark - TableviewDataDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.keysArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keysArr[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cell_Id = @"cell_id";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Id];
    if (!cell) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_Id];
    }
    
    QMUIItem *item = self.keysArr[indexPath.section][indexPath.row];
    cell.model = item;
    __weak typeof(self)wSelf = self;
    cell.selectOn = ^(BOOL rel, SettMode mode) {
        [wSelf setHiddenAction:mode hidden:rel];
    };
    return cell;
    
}

- (void)setHiddenAction:(SettMode)mode hidden:(BOOL)hidden {
    switch (mode) {
        case SettModeEmj:
            QMThemeManager.shared.isHiddenFaceBtn = hidden;
            break;
        case SettModeVoice:
            QMThemeManager.shared.isHiddenVoiceBtn = hidden;
            break;
        case SettModeExtend:
            QMThemeManager.shared.isHiddenAddBtn = hidden;
            break;
        case SettModePic:
            QMThemeManager.shared.isHiddenPictureBtn = hidden;
            break;
        case SettModeFile:
            QMThemeManager.shared.isHiddenFileBtn = hidden;
            break;
        case SettModeVideo:
            QMThemeManager.shared.isHiddenVideoBtn = hidden;
            break;
        case SettModeQuestion:
            QMThemeManager.shared.isHiddenQuestionBtn = hidden;
            break;
        case SettModeEvaluate:
            QMThemeManager.shared.isHiddenEvaluateBtn = hidden;

            break;

        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUIItem *model = self.keysArr[indexPath.section][indexPath.row];
    if (model.mode == SettModeNav || model.mode == SettModeLogout || model.mode == SettModeCustomer) {
        __weak typeof(self)wSelf = self;
        [[SetColorView defuatView] showColorView: ^(UIColor *color) {
            [wSelf upDateCellColor:indexPath color:color];
        }];
    }
}

- (void)upDateCellColor:(NSIndexPath *)indexPath color:(UIColor *)color {
    QMUIItem *model = self.keysArr[indexPath.section][indexPath.row];
    model.color.color = color;
    if (model.mode == SettModeNav) {
        QMThemeManager.shared.naviColorModel.color = color;
        self.navigationController.navigationBar.barTintColor = color;
    } else if (model.mode == SettModeCustomer) {
        QMThemeManager.shared.manualColor = color;
    } else if (model.mode == SettModeLogout) {
        QMThemeManager.shared.logoutColor = color;
    }
    [self.tabV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [QMThemeManager shared].naviColorModel.color;
}

- (UITableView *)tabV {
    if (!_tabV) {
        _tabV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tabV.tableFooterView = [UIView new];
        _tabV.estimatedRowHeight = 50;
        _tabV.rowHeight = UITableViewAutomaticDimension;
        _tabV.delegate = self;
        _tabV.dataSource = self;
    }
    return _tabV;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


