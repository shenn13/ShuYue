//
//  RecommendCell.h
//  Novel
//
//  Created by th on 2017/2/14.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BooksListModel.h"

#define coverW 60
#define coverH 80
#define RlineSpace 5
#define RlabelH 20

#define recomentItemW coverW
#define recomentItemH coverH+RlabelH

@protocol RecommendCellDelegate <NSObject>

- (void)RecommendCellDelegateWithHeieght:(CGFloat)height;

@end

@interface RecommendCell : UICollectionViewCell

@property (nonatomic, strong) BooksListItemModel *model;

@property (nonatomic, weak) id<RecommendCellDelegate> delegate;

@end
