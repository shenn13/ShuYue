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

@property (nonatomic, strong) UIView *bottomView;

/** 源label */
@property (nonatomic, strong) YYLabel *sourceLabel;

/** 标题 */
@property (nonatomic, strong) YYLabel *titleLabel;


@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    
    //头部
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, -menuTopH, kScreenWidth, menuTopH)];
    
    _topView.backgroundColor = KNavigationBarColor;
    
    [self.view addSubview:_topView];
    
    CGFloat statusBarH = 20;
    
    CGFloat middleH = 44;
    
    CGFloat sourceH = menuTopH - statusBarH - middleH;
    
    //添加书签  以后完善
    UIButton *sourceButton = [[UIButton alloc] initWithFrame:CGRectMake(kCellX, statusBarH, 80, 1)];
    [sourceButton setTitle:@"" forState:UIControlStateNormal];
    [sourceButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    sourceButton.titleLabel.font = FONT_SIZE(14);
    [_topView addSubview:sourceButton];
    sourceButton.tag = 3;
    [sourceButton addTarget:self action:@selector(menuTapWithButton:) forControlEvents:UIControlEventTouchDown];
    
    //取消
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - kCellX - 50, statusBarH, 50, middleH)];
    [cancelButton setImage:[UIImage imageNamed:@"sm_exit"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"sm_exit_selected"] forState:UIControlStateSelected];
    [_topView addSubview:cancelButton];
    cancelButton.tag = 4;
    [cancelButton addTarget:self action:@selector(menuTapWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //标题
    _titleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(sourceButton.maxX_pro+kCellX, statusBarH, kScreenWidth - (sourceButton.maxX_pro + kCellX) * 2, middleH)];
    _titleLabel.font = FONT_SIZE(16);
    _titleLabel.textColor = KWhiteColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_titleLabel];
    
    
    //原网页
    _sourceLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, statusBarH + middleH, kScreenWidth, sourceH)];
    _sourceLabel.backgroundColor = KNavigationBarColor;
    _sourceLabel.textColor = kgrayColor;
    _sourceLabel.font = FONT_SIZE(12);
    _sourceLabel.numberOfLines = 1;
    _sourceLabel.textAlignment = NSTextAlignmentCenter;
    _sourceLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [_topView addSubview:_sourceLabel];
    
    
    //下部
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, menuBottomH)];
    _bottomView.backgroundColor = KNavigationBarColor;
    [self.view addSubview:_bottomView];
    
    
    
    NSArray *images = @[@"mode_juhe",  @"directory",@"feedback"];
    NSArray *titles = @[@"换源",  @"目录", @"好评"];
    CGFloat w = _bottomView.width / images.count;

    for (int i = 0; i < images.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * w, 0, w, menuBottomH)];
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        UIImage *image = [UIImage imageNamed:images[i]];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
    
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

- (void)setBookTitle:(NSString *)bookTitle {
    _bookTitle = bookTitle;
    _titleLabel.text = bookTitle;
}

- (void)setLink:(NSString *)link {
    _link = link;
    
    _sourceLabel.text = link;
}

- (void)menuTapWithButton:(UIButton *)button {

    if (self.menuTap) {
        self.menuTap (button.tag);
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
