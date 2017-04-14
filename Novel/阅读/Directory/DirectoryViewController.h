//
//  DirectoryViewController.h
//  Novel
//
//  Created by th on 2017/3/1.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseViewController.h"

@interface DirectoryViewController : BaseTableViewController

@property (nonatomic, copy) void(^selectChapter)(NSInteger);

/** 换源时候如果遇到当前章节大于源章节总数的时候调用 */
@property (nonatomic, assign) BOOL isLast;

@property (nonatomic, assign) NSInteger chapter;

/** 刷新下界面 */
- (void)reloadDirectoryView;

@end
