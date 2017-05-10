//
//  ReadViewController.m
//  Novel
//
//  Created by th on 2017/3/5.
//  Copyright © 2017年 th. All rights reserved.
//

#import "ReadViewController.h"
#import "KPageViewController.h"
#import "ContentViewController.h"
#import "MenuViewController.h"
#import "DirectoryViewController.h"
#import "SummaryViewController.h"

@interface ReadViewController() <KPageViewControllerDelegate, UIGestureRecognizerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) ReadingManager *manager;

@property (nonatomic, strong) KPageViewController *pageViewController;

@property (nonatomic, strong) ContentViewController *contentViewController;

@property (nonatomic, strong) MenuViewController *menuView;

@property (nonatomic, strong) DirectoryViewController *directoryVC;

@property (nonatomic, strong) SummaryViewController *summaryVC;

/** 判断菜单栏是否弹出 */
@property (nonatomic, assign) BOOL isMenu;

/** 判断是否是下一章，否即上一章 */
@property (nonatomic, assign) BOOL ispreChapter;

/** 是否更换源 */
@property (nonatomic, assign) BOOL isReplaceSummary;

/** 预下载n章 */
@property (nonatomic, assign) NSInteger downlownNumber;

@end

@interface ReadViewController ()

@end

@implementation ReadViewController

#pragma mark - 懒加载ReadingManager单例
- (ReadingManager *)manager {
    if (!_manager) {
        _manager = [ReadingManager shareReadingManager];
    }
    return _manager;
}

#pragma mark - 懒加载MenuViewController
- (MenuViewController *)menuView {
    if (!_menuView) {
        _menuView = [MenuViewController new];
        _menuView.view.frame = self.view.bounds;
        [self.view addSubview:_menuView.view];
        _menuView.view.hidden = YES;
        
        [_menuView.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KPageViewControllerTapWithMenu)]];
        
        @weakify(self);
        self.menuView.menuTap = ^(NSInteger tag) {
            switch (tag) {
                case 0: {
                    //换源
                    weak_self.summaryVC.bookId = weak_self.bookId;
                    weak_self.summaryVC.summaryId = weak_self.summaryId;
                    [weak_self presentViewController:weak_self.summaryVC animated:YES completion:nil];
        
                }
            
                    break;
                case 1: {
                    //目录
                    [weak_self.directoryVC reloadDirectoryView];
                    [weak_self presentViewController:weak_self.directoryVC animated:YES completion:nil];
                }
                    break;
                case 2: {
    
                    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"提示" message:@"觉得不错就给个好评吧" ];
                    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"稍后评论" handler:^(CKAlertAction *action) {
                        NSLog(@"点击了 %@ 按钮",action.title);
                    }];
                    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"好的,小意思" handler:^(CKAlertAction *action) {
                        
                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPCommentURL]];
                    }];
            
                    [alertVC addAction:cancel];
                    [alertVC addAction:sure];
                    
                    [weak_self presentViewController:alertVC animated:NO completion:nil];
                }
                    break;
                case 3: {
                 //添加书签 以后完善
                }
                    break;
                    
                case 4: {
                    
                    [SQLiteTool updateWithTableName:weak_self.bookId dict:@{@"chapter": @(weak_self.manager.chapter), @"page": @(weak_self.manager.page), @"status": @"0"}];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBookShelf" object:nil];
                    [weak_self dismissViewControllerAnimated:YES completion:nil];
                }
                    
                    break;
                    
                default:
                    break;
            }
        };
    }
    return _menuView;
}

#pragma mark - 懒加载DirectoryViewController

- (DirectoryViewController *)directoryVC {
    if (!_directoryVC) {
        
        _directoryVC = [DirectoryViewController new];
        
        @weakify(self);
        _directoryVC.selectChapter = ^(NSInteger chapter) {
            
            [MBProgressHUD showActivityMessageInWindow:nil];
            
            if (!weak_self.directoryVC.isLast) {
                [weak_self.menuView hideMenuViewWithDuration:0.1 completion:^{
                    weak_self.isMenu = NO;
                    [weak_self setStatusBarHidden:YES];
                    
                }];
            }
            
            weak_self.manager.chapter = chapter;
            weak_self.ispreChapter = NO;
            weak_self.isReplaceSummary = NO;
            weak_self.directoryVC.isLast = NO;
            
            weak_self.downlownNumber = 0;
            
            //异步请求章节
            
            [weak_self.manager updateWithChapterAsync:weak_self.manager.chapter ispreChapter:weak_self.ispreChapter completion:^{
                
                [weak_self.pageViewController setController:[weak_self updateWithChapter:weak_self.manager.chapter]];
                
                weak_self.downlownNumber = 0;
                //预下载
                [weak_self downlownChapter];
                
            } failure:^(NSString *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:error];
            }];
      
        };
    }
    return _directoryVC;
}

#pragma mark - 懒加载summaryVC
- (SummaryViewController *)summaryVC {
    if (!_summaryVC) {
        _summaryVC = [SummaryViewController new];
        
        @weakify(self);
        _summaryVC.summarySelect = ^(NSString *id) {
            
            [weak_self.menuView hideMenuViewWithDuration:0.0001 completion:^{
                weak_self.isMenu = NO;
                [weak_self setNeedsStatusBarAppearanceUpdate]; //刷新状态栏
                
            }];
            
            //保存下进度
            [SQLiteTool updateWithTableName:weak_self.bookId dict:@{@"chapter": @(weak_self.manager.chapter), @"page": @(weak_self.manager.page), @"summaryId": id}];
          
            weak_self.summaryId = id;
            weak_self.isReplaceSummary = YES;
            
            [weak_self onLoadDataByRequest];
        };
    }
    return _summaryVC;
}
#pragma mark - 懒加载pageViewController
- (KPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [KPageViewController new];
        _pageViewController.delegate = self;
        [self.view addSubview:_pageViewController.view];
        [self addChildViewController:_pageViewController];
        
    }
    return _pageViewController;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    //在本界面直接退出程序需要存储
    _manager.isSave = YES;
    
    //预下载3章
    _manager.downlownNumber = 3;
    
    _downlownNumber = 0;
    
    //预缓存
    [self downlownChapter];
    
}



/*
 在info.plist文件中 View controller-based status bar appearance
 -> YES，则控制器对状态栏设置的优先级高于application
 -> NO，则以application为准，控制器设置状态栏prefersStatusBarHidden是无效的的根本不会被调用
 */
#pragma mark - 设置状态栏为白色字体
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //默认的值是黑色的
}

#pragma mark - 是否隐藏状态栏，隐藏导航栏  这里没用了 因为View controller-based status bar appearance NO
- (BOOL)prefersStatusBarHidden {
    return !_isMenu;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setStatusBarHidden:!_isMenu];
}
#pragma 状态栏隐藏或显示方法
- (void)setStatusBarHidden:(BOOL)hidden {
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - 开始网络请求
- (void)onLoadDataByRequest {
    
    [self pageViewController];
    
    [self.manager clear];
    
    _manager.bookId = _bookId;
    
    _manager.title = _bookTitle;
    
    _manager.autoSummaryId = _autoSummaryId;
    
    BookShelfModel *book = [SQLiteTool getBookWithTableName:_bookId];
    
    _manager.chapter = [book.chapter integerValue];
    _manager.page = [book.page integerValue];
    
    @weakify(self);
    
    void(^go2directoryVC)() = ^() {
        
        [MBProgressHUD hideHUD];
        weak_self.directoryVC.isLast = YES;
        weak_self.directoryVC.chapter = _manager.chapter;
        [weak_self.directoryVC reloadDirectoryView];
        [weak_self presentViewController:weak_self.directoryVC animated:YES completion:nil];
    };
    
    void(^updateWithChapter)() = ^() {
        
        [MBProgressHUD showActivityMessageInWindow:nil];
        
        //请求章节数组
        [weak_self.manager onloadChaptersWithId:weak_self.manager.summaryId completion:^{
            
            
            if (!weak_self.isReplaceSummary) {
                
                if (weak_self.manager.chapter <= weak_self.manager.chapters.count - 1) {
                    //异步请求章节
                    [weak_self.manager updateWithChapterAsync:weak_self.manager.chapter ispreChapter:weak_self.ispreChapter completion:^{
                        
                        weak_self.manager.page = [book.page integerValue];
                        
                        //初始化显示控制器
                        [weak_self.pageViewController setController:[weak_self updateWithChapter:weak_self.manager.chapter]];
                        
                    } failure:^(NSString *error) {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showTipMessageInWindow:error];
                    }];
                } else {
                    go2directoryVC();
                }
                
            } else {
                go2directoryVC();
            }
            
        } failure:^(NSString *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:error];
        }];
    };
    
    
    void(^onloadSummary)() = ^(){
        
        if (_summaryId.length > 0) { //有源id
            _manager.summaryId = _summaryId;
            updateWithChapter();
        } else {
            //用bookId请求拿到源id--自动选择
            [_manager updateWithSummary:_bookId completion:^{
                
                if (weak_self.manager.summaryId.length == 0) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"⚠️" message:@"当前书籍没有源更新!" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [weak_self dismissViewControllerAnimated:YES completion:nil];
                        
                    }]];
                    
                    [weak_self presentViewController:alert animated:YES completion:^{
                        [MBProgressHUD hideHUD];
                    }];
                } else {
                    updateWithChapter();
                }
                
            } failure:^(NSString *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:error];
            }];
        }
    };
    
    
    if ([Http isNetwork]) {//有网络

        onloadSummary();
        
    } else {//无网络
       
        if ([SQLiteTool isTableOK:_bookId] && _autoSummaryId.length > 0) { //已加入书架的
            
            _manager.summaryId = _autoSummaryId;
            updateWithChapter();
        } else {
            updateWithChapter();
        }
    }
}

#pragma 弹出或隐藏菜单
- (void)KPageViewControllerTapWithMenu {
    
    @weakify(self);
    
    self.menuView.link = ((BookChapterModel *)_manager.chapters[_manager.chapter]).link;
    self.menuView.bookTitle = weak_self.bookTitle;
    
    if (self.isMenu) {
        [self.menuView hideMenuViewWithDuration:0.3 completion:^{
            weak_self.isMenu = NO;
            [weak_self setStatusBarHidden:YES];
        }];
        
    } else {
        [self.menuView showMenuViewWithDuration:0.3 completion:^{
            weak_self.isMenu = YES;
            [weak_self setStatusBarHidden:NO];
        }];
        
    }
}
#pragma mark - 切换结果
- (void)coverController:(KPageViewController * _Nonnull)coverController currentController:(UIViewController * _Nullable)currentController finish:(BOOL)isFinish {
    
    if (!isFinish) {//切换失败
        
    }
}

#pragma mark - 返回上一个控制器
- (UIViewController *)coverController:(KPageViewController *)coverController getAboveControllerWithCurrentController:(UIViewController *)currentController {
    
    if ( _manager.chapter == 0 && _manager.page == 0) {
        [MBProgressHUD showTipMessageInWindow:@"已经是第一页了!"];
        return nil;
    }
    
    ContentViewController *vc = (ContentViewController *)currentController;
    
    if (vc.page > 0) {
        
        _manager.page--;
        
    } else {
        
        _manager.chapter--;
        
        _downlownNumber--;
        
        _ispreChapter = YES;
    }
    return [self updateWithChapter:vc.chapter];
}


#pragma mark - 返回下一个控制器
- (UIViewController *)coverController:(KPageViewController *)coverController getBelowControllerWithCurrentController:(UIViewController *)currentController {
    
    if (_manager.page == [_manager.chapters.lastObject pageCount] - 1 && _manager.chapter == _manager.chapters.count - 1) {
        [MBProgressHUD showTipMessageInWindow:@"已经是最后一页了!"];
        return nil;
    }
    
    ContentViewController *vc = (ContentViewController *)currentController;
    
    if (vc.page >= [_manager.chapters[vc.chapter] pageCount] - 1) {
        
        _manager.page = 0;
        
        _manager.chapter++;
        
        _downlownNumber++;
        
        _ispreChapter = NO;
        
    } else {
        _manager.page++;
    }
    
    return [self updateWithChapter:vc.chapter];
}



- (ContentViewController *)updateWithChapter:(NSInteger)chapter {
    
    //    // 创建一个新的控制器类，并且分配给相应的数据
    ContentViewController *contentVC = [[ContentViewController alloc] init];
    
    @weakify(self);
    void(^parameterBlock)() = ^{
        
        contentVC.bookModel = weak_self.manager.chapters[weak_self.manager.chapter];
        
        contentVC.chapter = weak_self.manager.chapter;
        
        contentVC.page = weak_self.manager.page;
        
        [MBProgressHUD hideHUD];
    };
    
    if (chapter != _manager.chapter) {
        
        //异步请求章节
        [_manager updateWithChapterAsync:_manager.chapter ispreChapter:_ispreChapter completion:^{
            
            parameterBlock();
            //预下载
            [weak_self downlownChapter];
            
        } failure:^(NSString *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:error];
        }];
        
    } else {
        parameterBlock();
        
        [MBProgressHUD hideHUD];
    }
    
    return contentVC;
}


/**
 预缓存章节
 */
- (void)downlownChapter {
    //预缓存章节
    if (0 == _downlownNumber) {
        [self.manager downLoadChapterWithNumber:self.manager.downlownNumber];
    } else if (self.manager.downlownNumber == self.downlownNumber) {
        [self.manager downLoadChapterWithNumber:self.manager.downlownNumber];
    } else if (self.downlownNumber > self.manager.downlownNumber) {
        self.downlownNumber = 0;
    }
}

- (void)dealloc {
    
    [_manager clear];
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
