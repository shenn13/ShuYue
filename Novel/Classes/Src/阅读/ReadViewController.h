//
//  ReadViewController.h
//  Novel
//
//  Created by th on 2017/3/5.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseViewController.h"

@interface ReadViewController : BaseViewController

/** book's id */
@property (nonatomic, copy) NSString *bookId;

/** summary's id */
@property (nonatomic, copy) NSString *summaryId;

/** novel's title */
@property (nonatomic, copy) NSString *bookTitle;

@end
