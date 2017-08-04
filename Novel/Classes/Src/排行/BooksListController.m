//
//  BooksListController.m
//  Novel
//
//  Created by th on 2017/2/6.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BooksListController.h"
#import "BooksListModel.h"
#import "BooksListCell.h"
#import "BookDetailController.h"

@interface BooksListController ()

@property (nonatomic, strong) NSArray *layouts;

@end

@implementation BooksListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (_booklist_type == bookslist_rank) {
        @weakify(self);
        self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
            [weak_self onLoadDataByRequestWithFirst:NO];
        }];
    }
    
    self.view.backgroundColor = KWhiteColor;
}

//点击空白页面刷新
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self onLoadDataByRequestWithFirst:YES];
}


- (void)onLoadDataByRequest {
    [self onLoadDataByRequestWithFirst:YES];
}

- (void)onLoadDataByRequestWithFirst:(BOOL)first {
    @weakify(self);
    
    if (first) {
        [HUD showProgressCircleNoValue:nil inView:self.view];
    }
    
    switch (_booklist_type) {
            
            //排行
        case bookslist_rank:
        {
            [httpUtil GET:NSStringFormat(@"%@/ranking/%@",SERVERCE_HOST,_id) parameters:nil success:^(id responseObject) {
                
                BooksListModel *model = [BooksListModel modelWithDictionary:responseObject[@"ranking"]];
                
                _layouts = nil;
                
                NSMutableArray *layouts = @[].mutableCopy;
                
                for (BooksListItemModel *m in model.books) {
                    m.cover = [NSString stringWithFormat:@"%@%@",statics_URL,m.cover];
                    
                    BooksListLayout *layout = [[BooksListLayout alloc] initWithLayout:m];
                    
                    [layouts addObject:layout];
                }
                
                weak_self.layouts = layouts;
                
                [self.tableView.mj_header endRefreshing];
                
                [weak_self.tableView reloadData];
                
                [HUD hide];
                
            } failure:^(NSError *error) {
                [self showEmptyWithStr:[error localizedDescription]];
            }];
        }
            break;
            
            //更多
        case bookslist_more:
        {
            //    /book/51d11e782de6405c45000068/recommend
            
            [httpUtil GET:NSStringFormat(@"%@/book/%@/recommend",SERVERCE_HOST,_id) parameters:nil success:^(id responseObject) {
                
                NSMutableArray *layouts = @[].mutableCopy;
                
                BooksListModel *model = [BooksListModel modelWithDictionary:responseObject];
                
                for (BooksListItemModel *m in model.books) {
                    m.cover = [NSString stringWithFormat:@"%@%@",statics_URL,m.cover];
                    
                    BooksListLayout *layout = [[BooksListLayout alloc] initWithLayout:m];
                    
                    [layouts addObject:layout];
                }
                
                weak_self.layouts = layouts;
                
                [weak_self.tableView reloadData];
                
                [HUD hide];
                
            } failure:^(NSError *error) {
                [self showEmptyWithStr:[error localizedDescription]];
            }];
            
        }
            break;
            
            //搜索
        case booksList_search:
        {
            [httpUtil GET:NSStringFormat(@"%@/book/fuzzy-search?query=%@&start=0&limit=100",SERVERCE_HOST,[NSString encodeToPercentEscapeString:_search]) parameters:nil success:^(id responseObject) {
                
                NSMutableArray *layouts = @[].mutableCopy;
                
                BooksListModel *model = [BooksListModel modelWithDictionary:responseObject];
                
                for (BooksListItemModel *m in model.books) {
                    m.cover = [NSString stringWithFormat:@"%@%@",statics_URL,m.cover];
                    
                    BooksListLayout *layout = [[BooksListLayout alloc] initWithLayout:m];
                    
                    [layouts addObject:layout];
                }
                
                weak_self.layouts = layouts;
                
                [weak_self.tableView reloadData];
                
                [HUD hide];
                
            } failure:^(NSError *error) {
                [self showEmptyWithStr:[error localizedDescription]];
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"booksListId";
    BooksListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BooksListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    [cell setLayout:self.layouts[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((BooksListLayout *)self.layouts[indexPath.row]).height;
}

#pragma mark - tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BooksListItemModel *model = ((BooksListLayout *)_layouts[indexPath.row]).model;
    
    BookDetailController *vc = [BookDetailController new];
    
    vc.id = model._id;
    vc.shorIntro = model.shortIntro;
    
//    NSLog(@"---%@",model._id);
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
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
