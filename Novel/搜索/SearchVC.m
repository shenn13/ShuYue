//
//  SearchVC.m
//  Novel
//
//  Created by th on 2017/2/2.
//  Copyright © 2017年 th. All rights reserved.
//

#import "SearchVC.h"
#import "MSSAutoresizeLabelFlow.h"
#import "BooksListController.h"

@interface SearchVC ()<MSSAutoresizeLabelFlowDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *tags;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) MSSAutoresizeLabelFlow *tagsView;

@end

@implementation SearchVC

- (void)dealloc {
    NSLog(@"%@销毁了",NSStringFromClass([self class]));
}

- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = @[].mutableCopy;
        [_tags addObjectsFromArray:@[@"辰东",@"我吃西红柿",@"唐家三少",@"天蚕土豆",@"耳根",@"烟雨江南",@"梦入神机",@"骷髅精灵",@"完美世界",@"大主宰",@"斗破苍穹",@"斗罗大陆",@"如果蜗牛有爱情",@"极品家丁",@"择天记",@"神墓",@"遮天",@"太古神王",@"帝霸",@"校花的贴身高手",@"武动乾坤"]];
    }
    return _tags;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"热门搜索";
    
    [self setupUI];
    
}

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    _topView.backgroundColor = KWhiteColor;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入你要查询的小说或作者";
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    [_topView addSubview:_searchBar];
    
    
    YYLabel *everyLabel = [[YYLabel alloc] initWithFrame:CGRectMake(10, _searchBar.maxY_pro, 120, 40)];
    everyLabel.font = FONT_SIZE(16);
    everyLabel.text = @"热门搜索:";
    [_topView addSubview:everyLabel];
    
    UIButton *replaceButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 100, _searchBar.maxY_pro, 100, 40)];
    [replaceButton setImage:[UIImage imageNamed:@"search_refresh"] forState:UIControlStateNormal];
    [replaceButton setTitle:@"换一批" forState:UIControlStateNormal];
    [replaceButton setTitleColor:kgrayColor forState:UIControlStateNormal];
    replaceButton.titleLabel.font = FONT_SIZE(14);
    
    replaceButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -replaceButton.titleLabel.width + 10);
    
    [replaceButton addTarget:self action:@selector(replaceAtion) forControlEvents:UIControlEventTouchDown];
    [_topView addSubview:replaceButton];

    
    @weakify(self);
    _tagsView = [[MSSAutoresizeLabelFlow alloc] initWithFrame:CGRectMake(0, everyLabel.maxY_pro , kScreenWidth, 50) titles:[self tagArray] selectedHandler:^(NSUInteger index, NSString *title) {
        [weak_self saerchWithText:title];
    }];

    _tagsView.delegate = self;
    [_topView addSubview:_tagsView];
    
    self.tableView.tableHeaderView = _topView;
}


- (void)autoLabelHeight:(CGFloat)height {
    _topView.size = CGSizeMake(kScreenWidth, _tagsView.maxY_pro);
}

//换一批
- (void)replaceAtion {
    [_tagsView reloadAllWithTitles:[self tagArray]];
}

//获取一个随机整数，范围在[from,to]，包括from，包括to
-(int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (NSArray *)tagArray {
    
    NSMutableSet *randomSet = [[NSMutableSet alloc] init];
    while (randomSet.count < [self getRandomNumber:3 to:10]) {
        
        int r = arc4random() % [self.tags count];
        [randomSet addObject:[self.tags objectAtIndex:r]];
    }
    return [randomSet allObjects];
}


//开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    @weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        [weak_self.searchBar setShowsCancelButton:YES];
        for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *cancelBtn = (UIButton *)view;
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                [cancelBtn setTintColor:[UIColor whiteColor]];
            }
        }
    }];
}

//结束编辑
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    
}

//搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [_searchBar endEditing:YES];
    
    if (_searchBar.text.length > 0) {
        [self saerchWithText:_searchBar.text];
    }
}

- (void)saerchWithText:(NSString *)text {
    BooksListController *vc = [BooksListController new];
    vc.search = text;
    vc.booklist_type = booksList_search;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    @weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        [weak_self.searchBar setShowsCancelButton:NO];
        [weak_self.searchBar endEditing:YES];

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
