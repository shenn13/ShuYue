//
//  RecommendView.h
//  Novel
//
//  Created by th on 2017/2/14.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendCell.h"

@protocol RecommendViewDelegate <NSObject>

- (void)RecommendViewDelegateSuccess;

- (void)didClickWithBookModel:(BooksListItemModel *)model;

@end

@interface RecommendView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

- (instancetype)initWithFrame:(CGRect)frame datas:(NSArray *)datas;

@property (nonatomic, weak) id<RecommendViewDelegate> delegate;

@end
