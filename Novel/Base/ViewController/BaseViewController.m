//
//  ViewController4.m
//  测试
//
//  Created by 李李善 on 16/7/30.
//  Copyright © 2016年 李李善. All rights reserved.
//

#pragma mark - UIViewController

#import "BaseViewController.h"

@interface BaseViewController (){
    BOOL _isLoad;
}
@end

@implementation BaseViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]postNotificationName:notiDealloc object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated{//更新视图信息。
    [super viewWillAppear:animated];
    @weakify(self);
    if (NO==_isLoad) {
        dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT), ^{
             [weak_self onLoadViewByWillAppear];
        });
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];//执行行为，比如运行动画效果。
     @weakify(self);
    if (NO==_isLoad) {
        _isLoad = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
              [weak_self onLoadAnimatedByDidAppear];
        });
    }
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

    _isLoad = NO;
    
   [self onLoadDataByRequest];
    
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
    
    self.view.backgroundColor = KWhiteColor;
    
     [self customNavigationItem];
}


//自定制当前视图控制器的navigationItem
-(void)customNavigationItem{
    
    UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backimage"] style:UIBarButtonItemStylePlain target:self action:@selector(popDoBack)];
    self.navigationItem.leftBarButtonItem =  backbtn;
}

-(void)popDoBack{
    if (_isPresent) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}


-(void)oDealloc{
//    NSLog(@"%@--自己释放了",NSStringFromClass([self class]));
}


/** < 加载动画 > */
-(void)onLoadAnimatedByDidAppear{
    
}

/** < 加载视图 > */
-(void)onLoadViewByWillAppear{
    
}

/** < 网络请求 > */
-(void)onLoadDataByRequest{
    
    
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
{
    BOOL _isLoad;
}
@end

@implementation BaseTableViewController

- (void)dealloc{

    [[NSNotificationCenter defaultCenter]postNotificationName:notiDealloc object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    UIView *wrapView = self.tableView.subviews.firstObject;

    if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
        for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
        
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
    
    @weakify(self);
    if (NO ==_isLoad) {
        dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT), ^{
            [weak_self onLoadViewByWillAppear];
        });
        
    }
}

/**
 视图已完全过渡到屏幕上时调用
 */
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];//执行行为，比如运行动画效果。
    
    @weakify(self);
    if (NO==_isLoad) {
        _isLoad = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weak_self onLoadAnimatedByDidAppear];
        });
    }
}

/**
 在视图加载后被调用
 */
- (void)viewDidLoad {//自定义视图。
    [super viewDidLoad];
    
    [self setupTalbeView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(oDealloc) name:notiDealloc object:nil];

    _isLoad = NO;
    
    [self onLoadDataByRequest];
    
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
    
    self.view.backgroundColor = KWhiteColor;
}

-(void)oDealloc{
//    NSLog(@"%@--自己释放了",NSStringFromClass([self class]));
}


/** < 加载动画 > */
-(void)onLoadAnimatedByDidAppear{
    
}

/** < 加载视图 > */
-(void)onLoadViewByWillAppear{
    
}

/** < 网络请求 > */
-(void)onLoadDataByRequest{
    
    
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
{
    BOOL _isLoad;
}
@end
@implementation BaseCollectionViewController
- (void)dealloc{

    [[NSNotificationCenter defaultCenter]postNotificationName:notiDealloc object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated{//更新视图信息。
    [super viewWillAppear:animated];
    if (NO==_isLoad) {
        dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT), ^{
            [self onLoadViewByWillAppear];
        });
        
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];//执行行为，比如运行动画效果。
    if (NO==_isLoad) {
        _isLoad = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self onLoadAnimatedByDidAppear];
        });
    }
}


- (void)viewDidLoad {//自定义视图。
   
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(oDealloc) name:notiDealloc object:nil];
    _isLoad = NO;
    [self onLoadDataByRequest];
    
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
    
    self.view.backgroundColor = KWhiteColor;
}

-(void)oDealloc{
//   NSLog(@"%@--自己释放了",NSStringFromClass([self class]));
}


/** < 加载动画 > */
-(void)onLoadAnimatedByDidAppear{
    
}

/** < 加载视图 > */
-(void)onLoadViewByWillAppear{
    
}

/** < 网络请求 > */
-(void)onLoadDataByRequest{
    
    
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
