//
//  BookDetailController.m
//  Novel
//
//  Created by th on 2017/2/10.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BookDetailController.h"
#import "BookDetailView.h"
#import "BooksListController.h"
#import "ReadViewController.h"

@import GoogleMobileAds;

@interface BookDetailController()<BookDetailViewDelegate,GADBannerViewDelegate,GADInterstitialDelegate>

@property (nonatomic, strong) BookDetailView *bookDetailView;

//插页广告
@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation BookDetailController

- (void)dealloc {
    //哪里创建通知，哪里移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _bookDetailView.recommentView.delegate = nil;
    _bookDetailView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"书籍详情";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"返回"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:nil];
    
    _bookDetailView = [BookDetailView new];
    
    _bookDetailView.hidden = YES;
    
    _bookDetailView.delegate = self;
    
    _bookDetailView.size = CGSizeMake(kScreenWidth, _bookDetailView.height);
    
    self.tableView.tableHeaderView = _bookDetailView;
    
    self.view.backgroundColor = KWhiteColor;
    
    //显示广告**********************************************
    [self setInterstitial];
    //*****************************************************
}

//点击空白页面刷新
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self onLoadDataByRequest];
}

- (void)onLoadDataByRequest {
    
    @weakify(self);
    
    [HUD showProgressCircleNoValue:nil inView:self.view];
    
    [httpUtil GET:NSStringFormat(@"%@/book/%@",SERVERCE_HOST,_id) parameters:nil success:^(id responseObject) {
        
        BookDetailModel *model = [BookDetailModel modelWithDictionary:responseObject];
        
        weak_self.bookDetailView.shorIntro = weak_self.shorIntro;
        
        weak_self.bookDetailView.model = model;
        
    } failure:^(NSError *error) {
        [self showEmptyWithStr:[error localizedDescription]];
    }];
    
}

#pragma mark - BookDetailViewDelegate - 布局
- (void)bookDetailViewHeight:(CGFloat)height {
    
    self.tableView.emptyDataSetDelegate = nil;
    self.tableView.emptyDataSetSource = nil;
    
    _bookDetailView.size = CGSizeMake(kScreenWidth, height);
    
    [self.tableView reloadData];
    
    self.bookDetailView.hidden = NO;
    
    [HUD hide];
}


#pragma mark - BookDetailViewDelegate - 单击了推荐书籍
- (void)didClickWithRecommendBookModel:(BooksListItemModel *)model {
    
    BookDetailController *vc = [BookDetailController new];
    
    vc.id = model._id;
    vc.shorIntro = model.shortIntro;;
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - BookDetailViewDelegate - 单击了推荐书籍的更多
- (void)didClickMoreBooks {
    
    BooksListController *vc = [BooksListController new];
    vc.title = @"你可能感兴趣";
    vc.id = _id;
    vc.booklist_type = bookslist_more;
//    vc.books = books;
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - BookDetailViewDelegate - 点击阅读按钮
- (void)didClickReading {
    ReadViewController *vc = [ReadViewController new];
    vc.bookId = self.bookDetailView.model._id;
    vc.bookTitle = self.bookDetailView.model.title;
    
    BOOL res = [SQLiteTool isTableOK:self.bookDetailView.model._id];
    
    if (res) {//已加入书架
        BookShelfModel *model = [SQLiteTool getBookWithTableName:kShelfPath];
        vc.summaryId = model.summaryId;
    }
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 点击了追加更新
- (void)didClickAddShelf {
    
//    加入书架，包含id,coverURL,title, lastChapter, updated, chapter，page
    
    BOOL res = [SQLiteTool isTableOK:self.bookDetailView.model._id];
    
    if (res) { //存在，则删除
        
        [SQLiteTool deleteTableName:self.bookDetailView.model._id indatabasePath:kShelfPath];
        
        [self.bookDetailView.afterBtn setTitle:@"+ 追更新" forState:UIControlStateNormal];
        [self.bookDetailView.readingBtn setTitle:@"开始阅读" forState:UIControlStateNormal];
        
    } else { //不存在，则添加
        BookShelfModel *model = [BookShelfModel new];
        model.id = _id;
        model.coverURL = NSStringFormat(@"%@%@",statics_URL,self.bookDetailView.model.cover);
        model.title = self.bookDetailView.model.title;
        model.lastChapter = self.bookDetailView.model.lastChapter;
        model.updated = self.bookDetailView.model.updated;
        model.status = @"1";
        model.chapter = @"0";
        model.page = @"0";
        model.summaryId = @"";
        
        [SQLiteTool addShelfWithModel:model];
        
        [self.bookDetailView.afterBtn setTitle:@"- 不追了" forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBookShelf" object:nil];
}
//初始化插页广告
- (void)setInterstitial {
    
    self.interstitial = [self createNewInterstitial];
}
//这个部分是因为多次调用 所以封装成一个方法
- (GADInterstitial *)createNewInterstitial {
    
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:AdMob_CID];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

#pragma mark - GADInterstitialDelegate -
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    }else{
        NSLog(@"not ready~~~~");
    }
}
//分配失败重新分配
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    [self setInterstitial];
}

#pragma mark - UITableViewDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
