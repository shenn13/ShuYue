//
//  BooksListMainController.m
//  Novel
//
//  Created by th on 2017/2/6.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BooksListMainController.h"
#import "BooksListModel.h"

static CGFloat const maxTitleScale = 1.2;

@interface BooksListMainController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate> {
    CGFloat w;
}

//@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) NSArray *layouts;

@property (nonatomic, strong) UIScrollView *titleScrollView;

@property (nonatomic, strong) BaseScrollView *containerScrollView;

@property (nonatomic, strong) UIView *underLine;

/** 选中按钮 */
@property (nonatomic, weak) UIButton *selTtitleButton;

/** 装载按钮的数组 */
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation BooksListMainController


- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTitleScrollView];
    [self setupContainerScrollView];
    [self addChildViewController];
    [self setupTitle];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.containerScrollView.contentSize = CGSizeMake(self.childViewControllers.count * kScreenWidth, 0);
    self.containerScrollView.pagingEnabled = YES;
    self.containerScrollView.showsHorizontalScrollIndicator = NO;
    self.containerScrollView.delegate = self;
    
    
    //underline
    _underLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleScrollView.height - 1, kScreenWidth / self.childViewControllers.count, 1)];
    
    _underLine.backgroundColor = kLineColor;
    
    [self.titleScrollView addSubview:_underLine];
}

#pragma mark - 设置头部标题栏
- (void)setupTitleScrollView {
    
    //判断是否存在导航控制器来判断y值
    CGFloat y = self.navigationController ? 0 : STATUS_BAR_HEIGHT;
    
    CGRect rect = CGRectMake(0, y + 64, kScreenWidth, NavigationBar_HEIGHT);
    
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    
    titleScrollView.backgroundColor = KWhiteColor;
    
    [self.view addSubview:titleScrollView];
    
    self.titleScrollView = titleScrollView;
}

#pragma mark - 设置ScrollView容器
- (void)setupContainerScrollView {
    
    CGFloat y = _titleScrollView.bottom;
    
    CGRect rect = CGRectMake(0, y, kScreenWidth, kScreenHeight -y);
    
    BaseScrollView *containerScrollView = [[BaseScrollView alloc] initWithFrame:rect];
    
    containerScrollView.backgroundColor = KWhiteColor;
    
    [self.view addSubview:containerScrollView];
    
    self.containerScrollView = containerScrollView;
}

#pragma mark - 添加子控制器
- (void)addChildViewController {
    
    BooksListController *week = [BooksListController new];
    week.title = @"周榜";
    week.id = _id;
    week.booklist_type = _booklist_type;
    [self addChildViewController:week];
    
    BooksListController *month = [BooksListController new];
    month.title = @"月榜";
    month.id = _monthRank;
    month.booklist_type = _booklist_type;
    [self addChildViewController:month];
    
    BooksListController *total = [BooksListController new];
    total.title = @"总榜";
    total.id = _totalRank;
    total.booklist_type = _booklist_type;
    [self addChildViewController:total];
}

#pragma mark - 设置TitleScrollView标题
- (void)setupTitle {
    
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat x = 0;
    w = kScreenWidth / count;
    
    for (int i = 0; i < count; i++) {
        
        UIViewController *vc = self.childViewControllers[i];
        
        x = i * w;
        
        CGRect rect = CGRectMake(x, 0, w, kTitleH);
        
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        
        btn.imageView.contentMode = UIViewContentModeScaleToFill;
        
        btn.tag = i;
        
        [btn setTitle:vc.title forState:UIControlStateNormal];
        
        btn.titleLabel.font = FONT_SIZE(14);
        
        [btn setTitleColor:kNormalColor forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
        
        [self.buttons addObject:btn];
        
        [self.titleScrollView addSubview:btn];
        
        if (i == 0) {
            [self click:btn];
        }
    }
    
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
}
// 按钮点击
- (void)click:(UIButton *)btn {
    [self selTitleBtn:btn];
    
    NSUInteger i = btn.tag;
    CGFloat x = i * kScreenWidth;
    
    [self setUpOneChildViewController:i];
    
    self.containerScrollView.contentOffset = CGPointMake(x, 0);
    
    @weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        weak_self.underLine.origin = CGPointMake(i * w, self.titleScrollView.height - 1);
    }];
}
// 选中按钮
- (void)selTitleBtn:(UIButton *)btn {
    
    self.selTtitleButton.transform = CGAffineTransformIdentity;
    
    btn.transform = CGAffineTransformMakeScale(maxTitleScale, maxTitleScale);
    
    self.selTtitleButton = btn;
    
    [self setupTitleCenter:btn];
}

- (void)setUpOneChildViewController:(NSUInteger)i {
    
    CGFloat x = i * kScreenWidth;
    
    UIViewController *vc = self.childViewControllers[i];
    
    if (vc.view.superview) {
        return;
    }
    
    vc.view.frame = CGRectMake(x, 0, kScreenWidth, self.containerScrollView.height);
    
    [self.containerScrollView addSubview:vc.view];
}

- (void)setupTitleCenter:(UIButton *)btn {
    
    CGFloat offset = btn.centerX - kScreenWidth * 0.5;
    
    if (offset < 0) {
        offset = 0;
    }
    
    CGFloat maxOffset = self.titleScrollView.contentSize.width - kScreenWidth;
    
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger i = self.containerScrollView.contentOffset.x / kScreenWidth;
    [self selTitleBtn:self.buttons[i]];
    [self setUpOneChildViewController:i];
}

// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger leftIndex = offsetX / kScreenWidth;
    NSInteger rightIndex = leftIndex + 1;
    
    //    NSLog(@"%zd,%zd",leftIndex,rightIndex);
    
    UIButton *leftButton = self.buttons[leftIndex];
    
    UIButton *rightButton = nil;
    if (rightIndex < self.buttons.count) {
        rightButton = self.buttons[rightIndex];
    }
    
    CGFloat scaleR = offsetX / kScreenWidth - leftIndex;
    
    CGFloat scaleL = 1 - scaleR;
    
    
    CGFloat transScale = maxTitleScale - 1;
    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    
    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);
    
    @weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        weak_self.underLine.origin = CGPointMake(leftButton.tag * w, self.titleScrollView.height - 1);
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
