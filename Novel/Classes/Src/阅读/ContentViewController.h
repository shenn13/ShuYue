//
//  ContentViewController.h
//  Novel
//
//  Created by th on 2017/2/19.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseViewController.h"
#import "ReadingManager.h"
#import "BookChapterModel.h"

@interface ContentViewController : UIViewController

@property (nonatomic, strong) BookChapterModel *bookModel;

/** 第n章 */
@property (nonatomic, assign) NSUInteger chapter;

/** 第几页 */
@property (nonatomic, assign) NSUInteger page;

@end
