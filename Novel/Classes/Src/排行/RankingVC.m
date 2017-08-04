//
//  RankingVC.m
//  小说
//
//  Created by xth on 16/8/16.
//  Copyright © 2016年 xth. All rights reserved.
//

#import "RankingVC.h"
#import "RankingModel.h"
#import "RankingCell.h"

#import "BooksListMainController.h"
#import "BooksListController.h"

@interface RankingVC()

/** 排行榜数组 */
@property (nonatomic, strong) NSArray *layouts;

/** 男生☞别人家的排行榜 */
@property (nonatomic, strong) NSArray *maleMoreArr;

/** 女生☞别人家的排行榜 */
@property (nonatomic, strong) NSArray *femaleMoreArr;

/** 是否已经展开 */
@property (nonatomic, assign) BOOL is_maleShow;

/** 是否已经展开 */
@property (nonatomic, assign) BOOL is_femaleShow;

@end

@implementation RankingVC

- (instancetype)initWithStyle:(UITableViewStyle)style {
    //设置UITableViewStyleGrouped样式
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.title = @"排行榜";
    
    @weakify(self);
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        [weak_self onLoadDataByRequestWithFirst:NO];
    }];
}

//点击空白页面刷新
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self onLoadDataByRequestWithFirst:YES];
}

#pragma mark - 网络请求

- (void)onLoadDataByRequest {
    [self onLoadDataByRequestWithFirst:YES];
}
- (void)onLoadDataByRequestWithFirst:(BOOL)first {
    @weakify(self);
    
    if (first) {
        [HUD showProgressCircleNoValue:nil inView:self.view];
    }
    
    [httpUtil GET:NSStringFormat(@"%@/ranking/gender",SERVERCE_HOST) parameters:@{@"timestamp":[DateTools getTimeInterval],@"platform":@"ios"} success:^(id responseObject) {
        
        weak_self.layouts = nil;
        weak_self.maleMoreArr = nil;
        weak_self.femaleMoreArr = nil;
        
        weak_self.is_maleShow = NO;
        weak_self.is_femaleShow = NO;
        
        NSMutableArray *maleArr = @[].mutableCopy;
        
        NSMutableArray *maleMoreArr = @[].mutableCopy;
        
        NSMutableArray *femaleArr = @[].mutableCopy;
        
        NSMutableArray *femaleMoreArr = @[].mutableCopy;
        
        RankingModel *model = [RankingModel modelWithDictionary:responseObject];
        
        for (RankingDeModel *m in model.male) {
            if (!m.collapse) {
                m.cover = [NSString stringWithFormat:@"%@%@",statics_URL,m.cover];
                RankingCellLayout *laout = [[RankingCellLayout alloc] initWithLayout:m];
                [maleArr addObject:laout];
            } else {
                m.cover = nil;
                RankingCellLayout *laout = [[RankingCellLayout alloc] initWithLayout:m];
                [maleMoreArr addObject:laout];
            }
        }
        for (RankingDeModel *m in model.female) {
            if (!m.collapse) {
                m.cover = [NSString stringWithFormat:@"%@%@",statics_URL,m.cover];
                RankingCellLayout *laout = [[RankingCellLayout alloc] initWithLayout:m];
                [femaleArr addObject:laout];
            } else {
                m.cover = nil;
                RankingCellLayout *laout = [[RankingCellLayout alloc] initWithLayout:m];
                [femaleMoreArr addObject:laout];
            }
        }
        
        RankingCellLayout *laout1 = [[RankingCellLayout alloc] initWithLayout:[RankingDeModel modelWithTitle:@"别人家的排行榜"]];
        
        [maleArr addObject:laout1];
        
        RankingCellLayout *laout2 = [[RankingCellLayout alloc] initWithLayout:[RankingDeModel modelWithTitle:@"别人家的排行榜"]];
        
        [femaleArr addObject:laout2];
        
        weak_self.layouts = @[maleArr, femaleArr];
        
        weak_self.maleMoreArr = maleMoreArr.copy;
        
        weak_self.femaleMoreArr = femaleMoreArr.copy;
        
        [weak_self.tableView.mj_header endRefreshing];
        
        [weak_self.tableView reloadData];
        
        [HUD hide];
        
    } failure:^(NSError *error) {
        [self showEmptyWithStr:[error localizedDescription]];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.layouts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.layouts[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cellId";
    
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[RankingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    [cell setLayout:_layouts[indexPath.section][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return RankCellHeight;//这里没有特别需求，固定高度
    return ((RankingCellLayout *)_layouts[indexPath.section][indexPath.row]).height;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RankingCellLayout *layout = _layouts[indexPath.section][indexPath.row];
    
    if (layout.model.isMoreItem) {
        
        NSInteger count = ((NSArray *)_layouts[indexPath.section]).count;
        
        if (indexPath.section == 0 && _is_maleShow==NO) {
            
            _is_maleShow = YES;
            
            [self updateTableViewWithDatasCount:count arrayForMore:_maleMoreArr indexPath:indexPath tableViewOperationType:kCellInsert_type];
            
        } else if (indexPath.section == 0 && _is_maleShow==YES) {
            
            _is_maleShow = NO;
            
            [self updateTableViewWithDatasCount:count arrayForMore:_maleMoreArr indexPath:indexPath tableViewOperationType:kCellDelete_type];
            
        } else if (indexPath.section == 1 && _is_femaleShow==NO) {
            
            _is_femaleShow = YES;
            
            [self updateTableViewWithDatasCount:count arrayForMore:_femaleMoreArr indexPath:indexPath tableViewOperationType:kCellInsert_type];
            
        } else if (indexPath.section == 1 && _is_femaleShow==YES) {
            _is_femaleShow = NO;
            
            [self updateTableViewWithDatasCount:count arrayForMore:_femaleMoreArr indexPath:indexPath tableViewOperationType:kCellDelete_type];
        }
    } else {
        
        @weakify(self);
        void (^pushVC)(BOOL) = ^(BOOL collapse) {
            if (collapse == false) {
                BooksListMainController *vc = [BooksListMainController new];
                vc.title = layout.model.title;
                vc.id = layout.model._id;
                vc.monthRank = layout.model.monthRank;
                vc.totalRank = layout.model.totalRank;
                vc.booklist_type = bookslist_rank;
                vc.hidesBottomBarWhenPushed = YES;
                [weak_self.navigationController pushViewController:vc animated:YES];
            } else {
                BooksListController *vc = [BooksListController new];
                vc.title = layout.model.title;
                vc.id = layout.model._id;
                vc.booklist_type = bookslist_rank;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        pushVC(layout.model.collapse);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateTableViewWithDatasCount:(NSInteger)count arrayForMore:(NSArray *)moreArray indexPath:(NSIndexPath *)indexPath tableViewOperationType:(kTableViewOperation)type {
    
    switch (type) {
        case kCellInsert_type:
        {
            [_layouts[indexPath.section] addObjectsFromArray:moreArray];
            
            NSMutableArray *array = @[].mutableCopy;
            
            for (int i = 0; i < moreArray.count; i ++) {
                [array addObject:[NSIndexPath indexPathForRow:count + i inSection:indexPath.section]];
            }
            
            [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
            
        case kCellDelete_type:
        {
            [_layouts[indexPath.section] removeObjectsInArray:moreArray];
            
            NSMutableArray *array = @[].mutableCopy;
            
            for (int i = (int)(count - moreArray.count); i < count ; i ++) {
                
                [array addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            }
            
            [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
            
        default:
            break;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
    view.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(kCellX, 0, kScreenWidth - kCellX, 44)];
    
    label.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.00];
    
    label.font = FONT_SIZE(12);
    
    if (section == 0) {
        label.text = @"男生";
    } else {
        label.text = @"女生";
    }
    
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

@end
