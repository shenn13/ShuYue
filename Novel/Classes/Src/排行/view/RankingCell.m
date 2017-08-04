//
//  RankingCell.m
//  Novel
//
//  Created by th on 2017/2/5.
//  Copyright © 2017年 th. All rights reserved.
//

#import "RankingCell.h"

@implementation RankingCellLayout

- (void)dealloc {
    NSLog(@"%@ 这个类被强暴了",NSStringFromClass([self class]));
    
}

- (instancetype)initWithLayout:(RankingDeModel *)model {
    if (!model) return nil;
    
    self = [super init];
    
    _model = model;
    
    [self _layout];
    
    return self;
}

- (void)_layout {
    
    _height = RankCellHeight;
    
    _contentHeight = 0;
    
    _titleTextLayout = nil;
    
    [self _layoutTitle];
}

- (void)_layoutTitle {
    if (_model.title.length == 0) {
        _titleTextLayout = nil;
    } else {
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_model.title];
        text.font = FONT_SIZE(RankTitleFont);
        text.color = kBlackColor;
        
        CGSize maxSize = CGSizeMake(kScreenWidth - kCellX*2 - RankCoverWidth - kSpaceX, HUGE);
        
        YYTextContainer *container = [YYTextContainer containerWithSize:maxSize];
        
        _titleTextLayout = [YYTextLayout layoutWithContainer:container text:text];
        
        _contentHeight += _height;//这里没特殊要求
    }
}


@end

@implementation RankListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = 1;
    }
    self = [super initWithFrame:frame];
    
    //cover
    _coverView = [YYAnimatedImageView new];
    
    [self addSubview:_coverView];
    
    //title
    _titleLabel = [YYLabel new];
    
    //是否异步
    _titleLabel.displaysAsynchronously = YES;
    
    //忽视共同属性(例如 text, font, textColor, attributedText...) only use "textLayout" 取绘制
    _titleLabel.ignoreCommonProperties = YES;
    
    _titleLabel.fadeOnHighlight = NO;
    
    _titleLabel.fadeOnAsynchronouslyDisplay = NO;
    
    [self addSubview:_titleLabel];
    
    //underline
    _lineView = [UIView new];
    
    _lineView.backgroundColor = kLineColor;
    
    [self addSubview:_lineView];
    
    self.hidden = YES;
    
    return self;
}

- (void)setLayout:(RankingCellLayout *)layout {
    
    if (layout.contentHeight > 0) {
        
        self.hidden = NO;
        
        self.height = RankCellHeight;
        
        //cover
        _coverView.size = CGSizeMake(RankCoverWidth, RankCoverWidth);
        
        _coverView.origin = CGPointMake(kCellX, (self.size.height - RankCoverWidth) * 0.5);
        
        
        if (layout.model.cover && !layout.model.collapse) {
            
            [_coverView setImageWithURL:[NSURL URLWithString:layout.model.cover] placeholder:[UIImage imageNamed:@"default_book_cover"]];
            
        } else if (layout.model.isMoreItem) {
            _coverView.image = [UIImage imageNamed:@"ranking_other"];
        } else {
            _coverView.image = nil;
        }
        
        
        //title
        CGSize titleSize = layout.titleTextLayout.textBoundingSize;
        _titleLabel.size = titleSize;
        
        _titleLabel.origin = CGPointMake(self.coverView.maxX_pro + kSpaceX, (self.size.height - titleSize.height) * 0.5);
        
        _titleLabel.textLayout = layout.titleTextLayout;
        
        //underline
        _lineView.size = CGSizeMake(kScreenWidth - kCellX, 0.5);
        
        _lineView.origin = CGPointMake(kCellX, RankCellHeight - 0.5);
        
    } else {
        
        self.hidden = YES;
        
    }
}

@end

@implementation RankingCell

- (void)setupUI {
    
    //初始化对象
    _containerView = [RankListView new];
    
    [self.contentView addSubview:_containerView];
}

/** 设置布局 */
- (void)setLayout:(RankingCellLayout *)layout {
    
    self.height = layout.height;
    
    self.contentView.height = layout.height;
    
    _containerView.layout = layout;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

