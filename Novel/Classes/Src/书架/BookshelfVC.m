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
    
    self.navigationItem.title = @"我的书架";
    
    @weakify(self);
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        [weak_self updateWithChapter];
    }];
    
    if (self.datas.count > 0) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSelf:) name:@"reloadBookShelf" object:nil];
}

//弃用
- (void)setupFooter {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    footerView.backgroundColor = KWhiteColor;
    
    self.tableView.tableFooterView = footerView;
    
    CGFloat footerH = 44;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, footerView.height - footerH, kScreenWidth, footerH)];
    
    footer.backgroundColor = kLineColor;
    
    [footerView addSubview:footer];
    
    //没有图片，画个十字形
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(20, (footerH - 30) * 0.5, 25, 25)];
    
    addView.layer.borderWidth = 1;
    addView.layer.borderColor = kNormalColor.CGColor;
    addView.layer.cornerRadius = 25/2;
    
    [footer addSubview:addView];
    
    CGFloat lineW = 15;
    CGFloat space = 1;
    
    UIView *rowLine = [[UIView alloc] initWithFrame:CGRectMake((addView.width - lineW) * 0.5 , (addView.height - space) * 0.5, lineW, space)];
    
    rowLine.backgroundColor = kNormalColor;
    
    [addView addSubview:rowLine];
    
    UIView *colLine = [[UIView alloc] initWithFrame:CGRectMake((addView.width - space) * 0.5, (addView.height - lineW) * 0.5, space, lineW)];
    
    colLine.backgroundColor = kNormalColor;
    
    [addView addSubview:colLine];
    
    YYLabel *addLabel = [[YYLabel alloc] initWithFrame:CGRectMake(addView.maxX_pro + 15, addView.y_pro, footer.width - addView.maxX_pro - 15, addView.height)];
    
    addLabel.text = @"添加你喜欢的小说";
    
    [footer addSubview:addLabel];
    
    [footer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToRankingVC" object:nil];
    }]];
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
    
    [httpUtil GET:NSStringFormat(@"%@/book?view=updated&id=%@",SERVERCE_HOST,[BookShelfModel componentsJoineWithArrID:self.datas]) parameters:nil success:^(id responseObject) {
        
        NSArray *updates = [NSArray modelArrayWithClass:[BookShelfModel class] json:responseObject];
        
        [updates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BookShelfModel *m1 = weak_self.datas[idx];
            BookShelfModel *m2 = updates[idx];
            
            if (stop) {
                //status=0 -->NO 不显示  status=1 -->YES 显示
                if (![m1.lastChapter isEqualToString:m2.lastChapter]) { //有更新
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
            case UIGestureRecognizerStateBegan: //开始
            {
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
    vc.bookTitle = model.title;
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}


#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"blankPage"];
}

//返回空白页标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"没有书籍";
    
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
    
    NSMutableAttributedString *textTest = [[NSMutableAttributedString alloc] initWithString:@" 您还没有添加书籍，点击添加哦"];
    textTest.font = FONT_SIZE(12);
    
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(100, 100)];
    container.maximumNumberOfRows = 1;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:textTest];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    
    attachment.bounds = CGRectMake(0, -(layout.textBoundingSize.height - refreshImage.height) * 0.5, refreshImage.width, refreshImage.height);
    attachment.image = refreshImage;
    
    NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *strMatt = [[NSMutableAttributedString alloc] initWithString:@" 您还没有添加书籍，点击添加哦"];
    strMatt.font = FONT_SIZE(12);
    strMatt.color = kLightGrayColor;
    
    [strMatt insertAttributedString:strAtt atIndex:0];
    
    return strMatt;
}
//点击空白页面刷新
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToRankingVC" object:nil];
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
