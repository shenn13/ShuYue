//
//  BooksListMainController.h
//  Novel
//
//  Created by th on 2017/2/6.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseScrollView.h"
#import "BooksListController.h"

@interface BooksListMainController : BaseViewController

/** 榜id */
@property (nonatomic, copy) NSString *id;
/** 月榜id */
@property (nonatomic, copy) NSString *monthRank;
/** 总榜id */
@property (nonatomic, copy) NSString *totalRank;

@property (nonatomic, assign) bookslist_Type booklist_type;

@end
