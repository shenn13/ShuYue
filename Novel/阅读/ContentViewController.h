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

@interface ContentViewController : BaseViewController

@property (nonatomic, strong) BookChapterModel *bookModel;

/** 第n章 */
@property (nonatomic, assign) NSUInteger chapter;

/** 第几页 */
@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, strong) YYLabel *contentLabel;

@property (nonatomic, strong) YYLabel *titleLabl;

@property (nonatomic, strong) YYLabel *pageLabel;

@end
