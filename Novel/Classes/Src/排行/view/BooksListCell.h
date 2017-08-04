//
//  BooksListCell.h
//  Novel
//
//  Created by th on 2017/2/8.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseCell.h"
#import "BooksListLayout.h"

@interface BooksListContainer : UIView

/** 图片 */
@property (nonatomic, strong) YYAnimatedImageView *coverView;

/** 作者 */
@property (nonatomic, strong) YYLabel *titleLabel;

/** 作者 | 类型 */
@property (nonatomic, strong) YYLabel *authorAndCatLabel;

/** 简介 */
@property (nonatomic, strong) YYLabel *shortIntroLabel;

/** n人在追 | n%读者留存 */
@property (nonatomic, strong) YYLabel *followerAndRetentionLabel;

/** underline */
@property (nonatomic, strong) UIView *lineView;


/** 布局属性 */
@property (nonatomic, strong) BooksListLayout *layout;

@end

#pragma mark - BooksListCell

@interface BooksListCell : BaseCell


/** 容器 */
@property (nonatomic, strong) BooksListContainer *container;

/** 设置布局 */
- (void)setLayout:(BooksListLayout *)layout;

@end
