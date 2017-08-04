//
//  BaseViewController.m
//  Novel
//
//  Created by xth on 2017/7/15.
//  Copyright © 2017年 th. All rights reserved.
//

#pragma mark - UIViewController

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)dealloc {
    //    NSLog(@"%@ 这个类被强暴了",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter]postNotificationName:notiDealloc object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
 在info.plist文件中 View controller-based status bar appearance
 -> YES，则控制器对状态栏设置的优先级高于application
 -> NO，则以application为准，控制器设置状态栏-(UIStatusBarStyle)preferredStatusBarStyle是无效的的根本不会被调用
 */

- (void)requestSuccessWithResponeObj:(id)responseObject modelClass:(id)clas alertStr:(NSString *)alertStr isAlert:(BOOL)isAlert complete:(void (^)(id obj))complete {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [HUD hide];
    [SVProgressHUD dismiss];
    
    if ([responseObject[@"code"] integerValue] == 100) {
        
        id responseObj = nil;
        
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            responseObj =[clas modelWithDictionary:responseObject[@"data"]];
        } else if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            responseObj = [NSArray modelArrayWithClass:clas json:responseObject[@"data"]];
        }
        
        if (responseObj) {
            
            complete(responseObj);
            
        } else {
            if (isAlert) {
                NSString *msg = [responseObject[@"message"] length] > 0 ? responseObject[@"message"] : alertStr;
                [HUD showMessage:msg inView:self.view];
            }
        }
        
    } else {
        if (isAlert) {
            NSString *msg = [responseObject[@"message"] length] > 0 ? responseObject[@"message"] : alertStr;
            [HUD showMessage:msg inView:self.view];
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)initializeWithTableViewFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (!_tableView) {
        _tableView = [[BaseTableView alloc] initWithFrame:frame style:style];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.emptyDataSetDelegate = self;
        //        _tableView.emptyDataSetSource = self;
        
        [self.view addSubview:_tableView];
    }
}

- (void)showEmptyWithStr:(NSString *)str {
    [HUD hide];
    [SVProgressHUD dismiss];
    if (self.tableView) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.page == 0 || self.page == 1) {
            self.tableView.emptyDataSetDelegate = self;
            self.tableView.emptyDataSetSource = self;
        }
        
        self.view.backgroundColor = kWhiteColor;
        
        [self.tableView reloadData];
        
        if (str.length > 0) {
            [HUD showMessage:str inView:self.view];
        }
    }
}

- (void)go2Back{
    if (self.navigationController) {
        if ([self.navigationController viewControllers].count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated { //更新视图信息。
    [super viewWillAppear:animated];
    
    NSUInteger vcNum = [self.navigationController viewControllers].count;
    
    if (vcNum != 1) {
        [[self addLeftBarButtonItemImageName:@"backTo" title:nil titleColor:nil] addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];//执行行为，比如运行动画效果。
    
}


- (BOOL)shouldAutorotate{
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskAll;
}
- (void)viewDidLoad {//自定义视图。
    [super viewDidLoad];
    
    _page = 0;
    
    //  [self.navigationController fullScreenInteractiveTransitionEnable:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(oDealloc) name:notiDealloc object:nil];
    
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = KNavigationBarColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17]
                                                                      }];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = KbackgroundColor;
    
    [self onLoadViewByViewDidLoad];
    
    [self onLoadDataByRequest];
}

-(void)oDealloc{
    //    NSLog(@"%@--自己释放了",NSStringFromClass([self class]));
}


/** < 加载视图 > */
-(void)onLoadViewByViewDidLoad{
    
}

/** < 网络请求 > */
-(void)onLoadDataByRequest{
    
    
}


#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"blankPage"];
}

//返回空白页标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"没有数据";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: kNormalColor,
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// 返回可以点击的按钮 上面带文字
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    UIImage *refreshImage = [UIImage imageNamed:@"blankRefresh"];
    
    NSMutableAttributedString *textTest = [[NSMutableAttributedString alloc] initWithString:@" 点击页面刷新"];
    textTest.font = FONT_SIZE(12);
    
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(100, 100)];
    container.maximumNumberOfRows = 1;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:textTest];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    
    attachment.bounds = CGRectMake(0, -(layout.textBoundingSize.height - refreshImage.height) * 0.5, refreshImage.width, refreshImage.height);
    attachment.image = refreshImage;
    
    NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *strMatt = [[NSMutableAttributedString alloc] initWithString:@" 点击页面刷新"];
    strMatt.font = FONT_SIZE(12);
    strMatt.color = kLightGrayColor;
    
    [strMatt insertAttributedString:strAtt atIndex:0];
    
    return strMatt;
}
//点击空白页面刷新
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    NSLog(@"点击刷新页面");
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


#pragma mark - UITableViewController

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)dealloc
{
    //    NSLog(@"%@ 这个类被强暴了",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter]postNotificationName:notiDealloc object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)go2Back{
    if (self.navigationController) {
        if ([self.navigationController viewControllers].count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)showEmptyWithStr:(NSString *)str {
    [HUD hide];
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.view.backgroundColor = kWhiteColor;
    
    [self.tableView reloadData];
    
    if (str.length > 0) {
        [HUD showMessage:str inView:self.view];
    }
}

- (void)requestSuccessWithResponeObj:(id)responseObject modelClass:(id)clas alertStr:(NSString *)alertStr isAlert:(BOOL)isAlert complete:(void (^)(id obj))complete {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [HUD hide];
    [SVProgressHUD dismiss];
    
    if ([responseObject[@"code"] integerValue] == 100) {
        
        id responseObj = nil;
        
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            responseObj =[clas modelWithDictionary:responseObject[@"data"]];
        } else if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            responseObj = [NSArray modelArrayWithClass:clas json:responseObject[@"data"]];
        }
        
        if (responseObj) {
            
            complete(responseObj);
            
        } else {
            if (isAlert) {
                NSString *msg = [responseObject[@"message"] length] > 0 ? responseObject[@"message"] : alertStr;
                [HUD showMessage:msg inView:self.view];
            }
        }
        
    } else {
        if (isAlert) {
            NSString *msg = [responseObject[@"message"] length] > 0 ? responseObject[@"message"] : alertStr;
            [HUD showMessage:msg inView:self.view];
        }
    }
}

- (void)setupTalbeView {
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.edgesForExtendedLayout = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.delaysContentTouches = NO;
    
    self.tableView.canCancelContentTouches = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //    [self.tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
    //                               UIViewAutoresizingFlexibleTopMargin|
    //                               UIViewAutoresizingFlexibleLeftMargin|
    //                               UIViewAutoresizingFlexibleRightMargin|
    //                               UIViewAutoresizingFlexibleBottomMargin)];
    
    //    self.tableView.emptyDataSetSource = self;
    //    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableFooterView = [UIView new];
    
    // Remove touch delay (since iOS 8)
    UIView *wrapView = self.tableView.subviews.firstObject;
    // UITableViewWrapperView
    if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
        for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
            // UIScrollViewDelayedTouchesBeganGestureRecognizer
            if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) {
                gesture.enabled = NO;
                break;
            }
        }
    }
}

/**
 视图即将可见时调用
 */
- (void)viewWillAppear:(BOOL)animated{//更新视图信息。
    
    [super viewWillAppear:animated];
    
    NSUInteger vcNum = [self.navigationController viewControllers].count;
    
    if (vcNum != 1) {
        [[self addLeftBarButtonItemImageName:@"backTo" title:nil titleColor:nil] addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 视图已完全过渡到屏幕上时调用
 */
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];//执行行为，比如运行动画效果。
}

/**
 在视图加载后被调用
 */
- (void)viewDidLoad {//自定义视图。
    [super viewDidLoad];
    
    [self setupTalbeView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(oDealloc) name:notiDealloc object:nil];
    
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = KNavigationBarColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17]
                                                                      }];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = KbackgroundColor;
    
    [self onLoadViewByViewDidLoad];
    
    [self onLoadDataByRequest];
}

-(void)oDealloc{
    //    NSLog(@"%@--自己释放了",NSStringFromClass([self class]));
}

/** < 加载视图 > */
-(void)onLoadViewByViewDidLoad{
    
}

/** < 网络请求 > */
-(void)onLoadDataByRequest{
    
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"blankPage"];
}

//返回空白页标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"没有数据";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: kNormalColor,
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//返回按钮
//- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//
//    return [UIImage imageNamed:@"刷新-(1)"];
//}

// 返回可以点击的按钮 上面带文字
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    UIImage *refreshImage = [UIImage imageNamed:@"blankRefresh"];
    
    NSMutableAttributedString *textTest = [[NSMutableAttributedString alloc] initWithString:@" 点击页面刷新"];
    textTest.font = FONT_SIZE(12);
    
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(100, 100)];
    container.maximumNumberOfRows = 1;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:textTest];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    
    attachment.bounds = CGRectMake(0, -(layout.textBoundingSize.height - refreshImage.height) * 0.5, refreshImage.width, refreshImage.height);
    attachment.image = refreshImage;
    
    NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *strMatt = [[NSMutableAttributedString alloc] initWithString:@" 点击页面刷新"];
    strMatt.font = FONT_SIZE(12);
    strMatt.color = kLightGrayColor;
    
    [strMatt insertAttributedString:strAtt atIndex:0];
    
    return strMatt;
}
//点击空白页面刷新
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    NSLog(@"点击刷新页面");
}

//点击按钮刷新页面
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
//    // Do something
//    NSLog(@"点击空白刷新页面22");
//}
//返回背景颜色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIColor whiteColor];
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

#pragma mark - UICollectionViewController

@interface BaseCollectionViewController ()


@end

@implementation BaseCollectionViewController

- (void)dealloc {
    //    NSLog(@"%@ 这个类被强暴了",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter]postNotificationName:notiDealloc object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//- (NSString *)deallocDescription{
//
//    return @"BaseCollectionVC释放内存了!!";
//}
//-(void)_init{
//   [BaseCollectionViewController RP_toggleSwizzDealloc];
//}

- (void)go2Back {
    if (self.navigationController) {
        if ([self.navigationController viewControllers].count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated{//更新视图信息。
    [super viewWillAppear:animated];
    
    NSUInteger vcNum = [self.navigationController viewControllers].count;
    
    if (vcNum != 1) {
        [[self addLeftBarButtonItemImageName:@"backTo" title:nil titleColor:nil] addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];//执行行为，比如运行动画效果。
}


- (void)viewDidLoad {//自定义视图。
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(oDealloc) name:notiDealloc object:nil];
    //    [self _init];
    //    __weak BaseCollectionViewController *vc = self;
    //    [vc RP_toggleSwizzDealloc];
    
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //[self.navigationController fullScreenInteractiveTransitionEnable:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = KNavigationBarColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17]
                                                                      }];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = KbackgroundColor;
    
    [self onLoadViewByViewDidLoad];
    
    [self onLoadDataByRequest];
}

-(void)oDealloc{
    //   NSLog(@"%@--自己释放了",NSStringFromClass([self class]));
}

/** < 加载视图 > */
-(void)onLoadViewByViewDidLoad{
    
}

/** < 网络请求 > */
-(void)onLoadDataByRequest{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

@end
