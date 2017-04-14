//
//  DirectoryViewController.m
//  Novel
//
//  Created by th on 2017/3/1.
//  Copyright © 2017年 th. All rights reserved.
//

#define topH 44+20
#define bottomH 44

#import "DirectoryViewController.h"
#import "DirectoryCell.h"

@interface DirectoryViewController ()

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) ReadingManager *manager;

/** 设置一开始就跳转到底部 */
@property (nonatomic, assign) BOOL isBottom;

@end

@implementation DirectoryViewController

- (void)dealloc {
    NSLog(@"%@释放了",NSStringFromClass([self class]));
}

#pragma mark - 懒加载ReadingManager单例
- (ReadingManager *)manager {
    if (!_manager) {
        _manager = [ReadingManager shareReadingManager];
    }
    return _manager;
}

#pragma mark - 设置状态栏颜色，这里没用到这个方法
- (void)setStatusBarBackgroundColor:(UIColor *)color {
   
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark - 设置状态栏为白色字体
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //默认的值是黑色的
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    
    _isBottom = YES;
    [_rightButton setTitle:@"到底部" forState:UIControlStateNormal];
}

- (void)setupView {
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    @weakify(self);
    
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    CGFloat statusBarH = 20;
    
    CGFloat middleH = topH - statusBarH;
    
    self.topView = [UIView new];
    self.topView.backgroundColor = KNavigationBarColor;
    [self.tableView addSubview:self.topView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-topH);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(weak_self.tableView.width, topH));
    }];
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = KNavigationBarColor;
    [self.tableView addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weak_self.tableView.height-bottomH);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(weak_self.tableView.width, bottomH));
    }];
    
    // 将topView移到最顶层，防止被其他view挡住
    [self.tableView bringSubviewToFront:self.topView];
    
    // 设置tableView的向下偏移topH
    self.tableView.contentInset = UIEdgeInsetsMake(topH, 0, bottomH, 0);
    
    
    CGFloat rightW = [@"到顶部" sizeForFont:FONT_SIZE(14) size:CGSizeMake(kScreenWidth, middleH) mode:NSLineBreakByWordWrapping].width+10;
    
    //到底/定部按钮
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - kSpaceX - rightW, statusBarH, rightW, middleH)];
    
    _rightButton.titleLabel.textColor = KWhiteColor;
    
    _rightButton.titleLabel.font = FONT_SIZE(14);
    
    [_topView addSubview:_rightButton];
    
    [_rightButton addTarget:self action:@selector(scrollToTopOrBottom) forControlEvents:UIControlEventTouchDown];
    
    
    //标题
    CGFloat titleLeftX = kScreenWidth - _rightButton.x_pro + 6;
    CGFloat titleW = kScreenWidth - titleLeftX*2;
    YYLabel *titleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(titleLeftX , statusBarH, titleW, middleH)];
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = KWhiteColor;
    titleLabel.font = FONT_BOLD_SIZE(16);
    titleLabel.text = self.manager.title;
    
    [_topView addSubview:titleLabel];
    
    //取消按钮
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake((self.tableView.width - bottomH)*0.5, 0, bottomH, bottomH)];
    
    [cancelButton setImage:[UIImage imageNamed:@"directory_close"] forState:UIControlStateNormal];
    
    [cancelButton setImage:[UIImage imageNamed:@"directory_close_pressed"] forState:UIControlStateHighlighted];
    
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:cancelButton];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    @weakify(self);
    CGFloat offset = self.tableView.contentOffset.y;
    [weak_self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        // 此处如果有navigationBar的高度，应加上
        make.top.mas_equalTo(offset + 0);
    }];
    [weak_self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        // 此处如果有navigationBar的高度，应加上
        make.bottom.mas_equalTo(weak_self.tableView.height+offset);
    }];
//    [self.tableView layoutIfNeeded];
}

- (void)cancelAction {
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.selectChapter && _isLast) {
            self.selectChapter (_manager.chapter);
        }
    }];
}

- (void)scrollToTopOrBottom {
    
    if (_isBottom) {
        [_rightButton setTitle:@"到顶部" forState:UIControlStateNormal];
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:self.manager.chapters.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        _isBottom = NO;
    } else {
        [_rightButton setTitle:@"到底部" forState:UIControlStateNormal];
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        _isBottom = YES;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.chapters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DirectoryCell *cell = [DirectoryCell cellWithTalbeView:tableView];
    
    cell.title = ((BookChapterModel *)self.manager.chapters[indexPath.row]).title;
    
    cell.index = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_manager.chapter != indexPath.row) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.selectChapter) {
                
                self.selectChapter (indexPath.row);
            }
        }];
        
    } else {
        [MBProgressHUD showWarnMessage:@"请选择其他章节哦!"];
    }
}

- (void)reloadDirectoryView {
    
    NSIndexPath *idxPath = nil;
    if (_chapter > self.manager.chapters.count - 1) {
        _manager.chapter = _manager.chapters.count - 1;
        idxPath = [NSIndexPath indexPathForRow:_manager.chapters.count - 1 inSection:0];
    } else {
        idxPath = [NSIndexPath indexPathForRow:_manager.chapter inSection:0];
    }
    [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
