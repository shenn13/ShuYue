//
//  MenuViewController.m
//  Novel
//
//  Created by th on 2017/2/27.
//  Copyright © 2017年 th. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) UIView *topView;

/** 源label */
@property (nonatomic, strong) YYLabel *sourceLabel;

/** 标题 */
@property (nonatomic, strong) YYLabel *titleLabel;

/** 夜间和白天的按钮 */
@property (nonatomic, strong) UIButton *statusButton;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatusWithNotificaiton:) name:NotificationWithChangeBg object:nil];
    
    [self setupUI];
}

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    //头部
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, -menuTopH, kScreenWidth, menuTopH)];
    
    _topView.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1.00];
    
    [self.view addSubview:_topView];
    
    CGFloat statusBarH = 20;
    
    CGFloat middleH = 44;
    
    CGFloat sourceH = menuTopH - statusBarH - middleH;
    
    
    //换源
    UIButton *sourceButton = [[UIButton alloc] initWithFrame:CGRectMake(kCellX, statusBarH, 50, middleH)];
    
    [sourceButton setTitle:@"换源" forState:UIControlStateNormal];
    
    [sourceButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    
    sourceButton.titleLabel.font = FONT_SIZE(16);
    
    
    [_topView addSubview:sourceButton];
    
    sourceButton.tag = 5;
    
    [sourceButton addTarget:self action:@selector(menuTapWithButton:) forControlEvents:UIControlEventTouchDown];
    
    //取消
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - kCellX - 50, statusBarH, 50, middleH)];
    
    [cancelButton setImage:[UIImage imageNamed:@"sm_exit"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"sm_exit_selected"] forState:UIControlStateSelected];
    
    
    [_topView addSubview:cancelButton];
    
    cancelButton.tag = 6;
    
    [cancelButton addTarget:self action:@selector(menuTapWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //标题
    _titleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(sourceButton.maxX_pro+kCellX, statusBarH, kScreenWidth - (sourceButton.maxX_pro + kCellX) * 2, middleH)];
    
    _titleLabel.font = FONT_SIZE(16);
    _titleLabel.textColor = KWhiteColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_topView addSubview:_titleLabel];
    
    
    //原网页
    _sourceLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, statusBarH + middleH, kScreenWidth, sourceH)];
    
    _sourceLabel.backgroundColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.16 alpha:1.00];
    
    _sourceLabel.textColor = kgrayColor;
    
    _sourceLabel.font = FONT_SIZE(12);
    
    _sourceLabel.numberOfLines = 1;
    
    _sourceLabel.textAlignment = NSTextAlignmentCenter;
    
    _sourceLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    [_topView addSubview:_sourceLabel];
    
    
    //下部
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, menuBottomH)];
    
    _bottomView.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.10 alpha:1.00];
    
    [self.view addSubview:_bottomView];
    
    
    
    NSArray *images = @[@"night_mode", @"feedback", @"directory", @"reading_setting"];
    
    NSArray *titles = @[@"夜间", @"好评", @"目录", @"设置"];
    
    CGFloat w = _bottomView.width / images.count;
    
    
    for (int i = 0; i < images.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * w, 0, w, menuBottomH)];
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        UIImage *image = [UIImage imageNamed:images[i]];
        
        [btn setImage:image forState:UIControlStateNormal];
        
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        
        if (i == 0) {
            _statusButton = btn;
            if ([ReadingManager shareReadingManager].bgColor != 5) {
                [btn setImage:[UIImage imageNamed:@"day_mode"] forState:0];
                [btn setTitle:@"白天" forState:UIControlStateNormal];
            }
        }
        
        
        CGSize imageSize = btn.imageView.frame.size;
        CGSize titleSize = btn.titleLabel.frame.size;
        
        //上 左 下 右  理解内边距
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height - 2, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height - 2, 0, 0, -titleSize.width);
        
        [_bottomView addSubview:btn];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(menuTapWithButton:) forControlEvents:UIControlEventTouchDown];
    }
    
}

/** 0-白色 1-黄色 2-淡绿色 3-淡黄色 4-淡紫色 5-黑色 */
- (void)changeStatusWithNotificaiton:(NSNotification *)sender {
    
    NSUInteger index = [[sender userInfo][NotificationWithChangeBg] integerValue];
    
    if ([ReadingManager shareReadingManager].bgColor == index) return;
    
    if (index != 5) {
        [_statusButton setImage:[UIImage imageNamed:@"day_mode"] forState:0];
        [_statusButton setTitle:@"白天" forState:UIControlStateNormal];
    } else {
        [_statusButton setImage:[UIImage imageNamed:@"night_mode"] forState:0];
        [_statusButton setTitle:@"夜间" forState:UIControlStateNormal];
    }
}


- (void)setBookTitle:(NSString *)bookTitle {
    _bookTitle = bookTitle;
    
    _titleLabel.text = bookTitle;
}

- (void)setLink:(NSString *)link {
    _link = link;
    
    _sourceLabel.text = link;
}

- (void)menuTapWithButton:(UIButton *)button {
    
    if (button.tag == 0) {  //点击白天或者黑夜的时候
        if ([ReadingManager shareReadingManager].bgColor != 5) {
            [_statusButton setImage:[UIImage imageNamed:@"night_mode"] forState:0];
            [_statusButton setTitle:@"夜间" forState:UIControlStateNormal];
            
            [ReadingManager shareReadingManager].bgColor = 5;
            
            BookSettingModel *md = [BookSettingModel decodeModelWithKey:[BookSettingModel className]];
            md.bgColor = 5;
            [BookSettingModel encodeModel:md key:[BookSettingModel className]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationWithChangeBgSelect object:nil userInfo:@{NotificationWithChangeBgSelect:NSStringFormat(@"%d", 5)}];
            
        } else {
            [_statusButton setImage:[UIImage imageNamed:@"day_mode"] forState:0];
            [_statusButton setTitle:@"白天" forState:UIControlStateNormal];
            
            [ReadingManager shareReadingManager].bgColor = 0;
            
            BookSettingModel *md = [BookSettingModel decodeModelWithKey:[BookSettingModel className]];
            md.bgColor = 0;
            [BookSettingModel encodeModel:md key:[BookSettingModel className]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationWithChangeBgSelect object:nil userInfo:@{NotificationWithChangeBgSelect:NSStringFormat(@"%d", 0)}];
        }
    } else {
        if (self.menuTap) {
            self.menuTap (button.tag);
        }
    }
}

- (void)showMenuViewWithDuration:(CGFloat)duration completion:(void(^)())completion  {
    
    self.view.hidden = NO;
    
    @weakify(self);
    [UIView animateWithDuration:duration animations:^{
        
        completion ();
        
        weak_self.topView.origin = CGPointMake(0, 0);
        
        weak_self.bottomView.origin = CGPointMake(0, kScreenHeight - menuBottomH);
        
    } completion:^(BOOL finished) {
//        if (finished) {
//            
//            completion ();
//        }
    }];
}
- (void)hideMenuViewWithDuration:(CGFloat)duration completion:(void(^)())completion {
    
    @weakify(self);
    [UIView animateWithDuration:duration animations:^{
        
        completion ();
        
        weak_self.topView.origin = CGPointMake(0, -menuTopH);
        
        weak_self.bottomView.origin = CGPointMake(0, kScreenHeight);
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            weak_self.view.hidden = YES;
        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
