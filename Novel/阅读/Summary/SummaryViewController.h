//
//  SummaryViewController.h
//  Novel
//
//  Created by shen on 17/3/28.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseViewController.h"

@interface SummaryViewController : BaseTableViewController

@property (nonatomic, copy) void(^summarySelect)(NSString *);

/** book's id */
@property (nonatomic, copy) NSString *bookId;

/** summary's id */
@property (nonatomic, copy) NSString *summaryId;

@end
