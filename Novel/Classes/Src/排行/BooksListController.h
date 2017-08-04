//
//  BooksListController.h
//  Novel
//
//  Created by th on 2017/2/6.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, bookslist_Type) {
    bookslist_rank = 1999,
    bookslist_more,
    booksList_search,
};

@interface BooksListController : BaseTableViewController

@property (nonatomic, assign) bookslist_Type booklist_type;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, strong) NSArray *books;

@property (nonatomic, copy) NSString *search;

@end
