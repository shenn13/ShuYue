//
//  BookshelfVC.m
//  Novel
//
//  Created by th on 2017/2/2.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BookshelfVC.h"
#import "ShelfCell.h"
#import "ReadViewController.h"
#import "RankingVC.h"

@interface BookshelfVC ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation BookshelfVC

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [SQLiteTool getBooksShelf];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的书架";
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateWithChapter)];
    
    if (self.datas.count > 0) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSelf:) name:@"reloadBookShelf" object:nil];
}

#pragma mark - 接收通知，刷新界面
- (void)reloadSelf:(NSNotification *)sender {
    
    _datas = nil;
    
    [self datas];
    
    [self.tableView reloadData];
}

#pragma mark - 更新章节
- (void)updateWithChapter {
    
    @weakify(self);
    if (self.datas.count == 0) {
        [weak_self.tableView.mj_header endRefreshing];
        return;
    }
    [Http GET:NSStringFormat(@"%@/book?view=updated&id=%@",SERVERCE_HOST,[BookShelfModel componentsJoineWithArrID:self.datas]) parameters:nil success:^(id responseObject) {
        
        NSArray *updates = [NSArray modelArrayWithClass:[BookShelfModel class] json:responseObject];
        
        [updates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BookShelfModel *m1 = weak_self.datas[idx];
            BookShelfModel *m2 = updates[idx];
            
            if (stop) {
                if (![m1.lastChapter isEqualToString:m2.lastChapter]) {
                    m1.updated = m2.updated;
                    m1.lastChapter = m2.lastChapter;
                    m1.status = @"1";
                    [SQLiteTool updateWithTableName:m1.id dict:@{@"lastChapter":m2.lastChapter, @"updated":m1.updated, @"status":@"1"}];
                }
                
                [weak_self.tableView reloadData];
            }
        }];
        [weak_self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [weak_self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ShelfCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShelfCell *cell = [ShelfCell cellWithTalbeView:tableView];
    
    @weakify(self);
    
    cell.CellLongPress = ^(UILongPressGestureRecognizer *longPress) {
        switch (longPress.state) {
                
            case UIGestureRecognizerStateBegan: {
                
                BookShelfModel *model = self.datas[indexPath.row];
                
                CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:model.title message:@"删除所选书籍及缓存文件？" ];
                
                CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
                    NSLog(@"点击了 %@ 按钮",action.title);
                }];
                
                CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                    NSLog(@"点击了 %@ 按钮",action.title);
                    
                    if ([SQLiteTool deleteTableName:model.id indatabasePath:kShelfPath]) {
                        
                        //删除缓存的章节
                        [SQLiteTool deleteTableName:model.id indatabasePath:kChaptersPath];
                        
                        self.datas = nil;
                        
                        [self datas];
                        
                        [weak_self.tableView reloadData];
                        NSLog(@"%@--删除成功",model.title);
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"删除失败"];
                    }
                    
                }];
                
                [alertVC addAction:cancel];
                [alertVC addAction:sure];
                
                [self presentViewController:alertVC animated:NO completion:nil];
            }
                break;
            case UIGestureRecognizerStateChanged: //移动
                NSLog(@"移动");
                break;
            case UIGestureRecognizerStateEnded: //结束
                NSLog(@"结束");
                break;
                
            default:
                break;
        }
    };
    cell.row = indexPath.row;
    cell.model = self.datas[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BookShelfModel *model = self.datas[indexPath.row];
    ReadViewController *vc = [ReadViewController new];
    vc.bookId = model.id;
    vc.summaryId = model.summaryId;
    vc.autoSummaryId = model.autoSummaryId;
    vc.bookTitle = model.title;
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
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
