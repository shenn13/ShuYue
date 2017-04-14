//
//  BookDetailView.h
//  Novel
//
//  Created by th on 2017/2/12.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSAutoresizeLabelFlow.h"
#import "BookDetailModel.h"
#import "RecommendView.h"

@protocol BookDetailViewDelegate  <NSObject>

- (void)bookDetailViewHeight:(CGFloat)height;

- (void)didClickWithRecommendBookModel:(BooksListItemModel *)model;

- (void)didClickMoreBooks;

/** 添加/移除书架 */
- (void)didClickAddShelf;

/** 阅读 */
- (void)didClickReading;

@end

@interface BookDetailView : UIView<MSSAutoresizeLabelFlowDelegate>

@property (nonatomic, assign) CGFloat height;

/** 推荐书籍RecommendView */
@property (nonatomic, strong) RecommendView *recommentView;

/** after update */
@property (nonatomic, strong) UIButton *afterBtn;

/** read */
@property (nonatomic, strong) UIButton *readingBtn;

@property (nonatomic, weak) id<BookDetailViewDelegate> delegate;

@property (nonatomic, strong) BookDetailModel *model;

@property (nonatomic, copy) NSString *shorIntro;

@end
