//
//  SummaryViewController.m
//  Novel
//
//  Created by shen on 17/3/28.
//  Copyright © 2017年 th. All rights reserved.
//
#define topH 44+20
#define bottomH 44

#import "SummaryViewController.h"
#import "SummaryCell.h"

@interface SummaryViewController ()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) NSArray *datas;

@end

@implementation SummaryViewController

- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (void)setupView {
    
    [self.navigationController setNavigationBarHidden:YES];

    self.tableView.backgroundColor = [UIColor whiteColor];
    
    @weakify(self);
    
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    CGFloat statusBarH = 20;
    
    CGFloat middleH = topH - statusBarH;
    
    _topView = [UIView new];
    _topView.backgroundColor = KNavigationBarColor;
    
    [self.tableView addSubview:_topView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-topH);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(weak_self.tableView.width, topH));
    }];
    
    // 将topView移到最顶层，防止被其他view挡住
    [self.tableView bringSubviewToFront:_topView];
    
    // 设置tableView的向下偏移topH
    self.tableView.contentInset = UIEdgeInsetsMake(topH, 0, 0, 0);
    
    CGFloat rightW = [@"到顶部" sizeForFont:FONT_SIZE(14) size:CGSizeMake(kScreenWidth, middleH) mode:NSLineBreakByWordWrapping].width+10;
    
    //返回
     UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - kSpaceX - rightW, statusBarH, rightW, middleH)];
    
    [rightButton setImage:[UIImage imageNamed:@"sm_exit"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"sm_exit_selected"] forState:UIControlStateSelected];
    [_topView addSubview:rightButton];
    
    [rightButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchDown];
    //标题
    CGFloat titleLeftX = kScreenWidth - rightButton.x_pro + 6;
    CGFloat titleW = kScreenWidth - titleLeftX*2;
    YYLabel *titleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(titleLeftX , statusBarH, titleW, middleH)];
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = KWhiteColor;
    titleLabel.font = FONT_BOLD_SIZE(16);
    titleLabel.text = @"选择来源";
    
    [_topView addSubview:titleLabel];
    
}

- (void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    @weakify(self);
    CGFloat offset = self.tableView.contentOffset.y;
    [weak_self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        // 此处如果有navigationBar的高度，应加上
        make.top.mas_equalTo(offset + 0);
    }];
}

#pragma mark - 设置状态栏为白色字体
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //默认的值是黑色的
}


- (void)onLoadDataByRequest {
    
    [MBProgressHUD showActivityMessageInView:nil];
    
    @weakify(self);
    
    [Http GET:NSStringFormat(@"%@/toc?book=%@&view=summary",SERVERCE_HOST, _bookId) parameters:nil success:^(id responseObject) {
        
        NSArray *response = [NSArray modelArrayWithClass:[SummaryModel class] json:responseObject];
        
        NSMutableArray *datas = @[].mutableCopy;
        
        SummaryModel *model = [SummaryModel new];
        model._id = @"";
        model.source = @"自动选择";
        [datas addObject:model];
        
        if (_summaryId.length == 0) {
            model.isSelect = YES;
        }
        
        for (SummaryModel *model in response) {
            if (!model.starting) {
                
                if (weak_self.summaryId.length > 0 && [model._id isEqualToString:weak_self.summaryId]) {
                    model.isSelect = YES;
                }
                
                [datas addObject:model];
            }
        }
        
        weak_self.datas = datas;
        
        [MBProgressHUD hideHUD];
        
        [weak_self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:[error localizedDescription]];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SummaryCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SummaryCell *cell = [SummaryCell cellWithTalbeView:tableView indexPath:indexPath];
    cell.row = indexPath.row;
    cell.model = _datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SummaryModel *selectModel = [SummaryModel new];
    for (SummaryModel *model in _datas) {
        if (model.isSelect) {
            selectModel = model;
        }
    }
    
    NSUInteger index = [_datas indexOfObject:selectModel];
    @weakify(self);
    if (index != indexPath.row) {
        [self dismissViewControllerAnimated:YES completion:^{
            
            if (self.summarySelect) {
                SummaryModel *model = _datas[indexPath.row];
                model.isSelect = YES;
                selectModel.isSelect = NO;
                self.summarySelect (model._id);
            }
            [weak_self.tableView reloadData];
        }];
    } else {
        [MBProgressHUD showWarnMessage:@"请选择其他源哦！"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
