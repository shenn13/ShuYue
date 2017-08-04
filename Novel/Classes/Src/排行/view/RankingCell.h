//
//  RankingCell.h
//  Novel
//
//  Created by th on 2017/2/5.
//  Copyright © 2017年 th. All rights reserved.
//

#define RankCellHeight 50.0f //cell高度
#define RankCoverWidth 30.0f //cover宽高
#define  RankTitleFont 16 //字体大小

#import "BaseCell.h"
#import "RankingModel.h"

#pragma mark - RankingcellLayout

@interface RankingCellLayout : NSObject

/** cell's height */
@property (nonatomic, assign) CGFloat height;

/** 内容高度，0为没内容 */
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) RankingDeModel *model;

@property(nonatomic, strong) YYTextLayout *titleTextLayout;

/** 开始布局 */
- (instancetype)initWithLayout:(RankingDeModel *)model;

@end

#pragma mark - RankListView

@interface RankListView : UIView

/** cover image */
@property (nonatomic, strong) YYAnimatedImageView *coverView;

/** title label */
@property (nonatomic, strong) YYLabel *titleLabel;

/** underline */
@property (nonatomic, strong) UIView *lineView;

/** 布局属性 */
@property (nonatomic, strong) RankingCellLayout *layout;

@end

#pragma mark - RankingCell

@interface RankingCell : BaseCell

/** 容器 */
@property (nonatomic, strong) RankListView *containerView;

/** 设置布局 */
- (void)setLayout:(RankingCellLayout *)layout;

@end
