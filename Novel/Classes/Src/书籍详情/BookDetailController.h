//
//  BookDetailController.h
//  Novel
//
//  Created by th on 2017/2/10.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseViewController.h"

@interface BookDetailController : BaseTableViewController

/** 书籍id */
@property (nonatomic, copy) NSString *id;

/** shorIntro */
@property (nonatomic, copy) NSString *shorIntro;

@end
