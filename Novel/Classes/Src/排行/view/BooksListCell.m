//
//  BooksListCell.m
//  Novel
//
//  Created by th on 2017/2/8.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BooksListCell.h"

@implementation BooksListContainer

- (YYLabel *)_yyLabel
{
    YYLabel *yy = [YYLabel new];
    yy.displaysAsynchronously = YES;
    yy.ignoreCommonProperties = YES;
    yy.fadeOnHighlight = NO;
    yy.fadeOnAsynchronouslyDisplay = NO;
    
    return yy;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height ==0) {
        frame.size.width = kScreenWidth;
        frame.size.height = 0;
    }
    
    self = [super initWithFrame:frame];
    
    //cover
    _coverView = [YYAnimatedImageView new];
    
    [self addSubview:_coverView];
    
    //otherLabel
    _titleLabel = [self _yyLabel];
    
    _authorAndCatLabel = [self _yyLabel];
    
    _shortIntroLabel = [self _yyLabel];
    
    _followerAndRetentionLabel = [self _yyLabel];
    
    [self addSubview:_titleLabel];
    [self addSubview:_authorAndCatLabel];
    [self addSubview:_shortIntroLabel];
    [self addSubview:_followerAndRetentionLabel];
    
    //underline
    _lineView = [UIView new];
    
    _lineView.backgroundColor = kLineColor;
    
    [self addSubview:_lineView];
    
    self.hidden = YES;
    
    return self;
}

- (void)setLayout:(BooksListLayout *)layout {
    if (layout.contentHeight > 0) {
        self.hidden = NO;
        self.height = layout.height;
        
        //cover
        _coverView.size = CGSizeMake(kPicWidth_cell, kPicHeight_cell);
        _coverView.origin = CGPointMake(kCellX, (layout.height - kPicHeight_cell)*0.5);
        
        
        [_coverView setImageWithURL:[NSURL URLWithString:layout.model.cover] placeholder:[UIImage imageNamed:@"default_book_cover"]];
       
        
        //label's spacex
        CGFloat spaceX = _coverView.maxX_pro + kCellX;
        
        //title
        _titleLabel.size = layout.titleLayout.textBoundingSize;
        _titleLabel.origin = CGPointMake(spaceX, kCellY);
        _titleLabel.textLayout = layout.titleLayout;
        
        
        //authorAndCat
        _authorAndCatLabel.size = layout.authorAndCatLayout.textBoundingSize;
        _authorAndCatLabel.origin = CGPointMake(spaceX, _titleLabel.maxY_pro + kTextInterval);
        _authorAndCatLabel.textLayout = layout.authorAndCatLayout;
        
        
        //shortIntro
        _shortIntroLabel.size = layout.shortIntroLayout.textBoundingSize;
        _shortIntroLabel.origin = CGPointMake(spaceX, _authorAndCatLabel.maxY_pro + kTextInterval);
        _shortIntroLabel.textLayout = layout.shortIntroLayout;
        
        //_followerAndRetention
        _followerAndRetentionLabel.size = layout.followerAndRetentionLayout.textBoundingSize;
        _followerAndRetentionLabel.origin = CGPointMake(spaceX, _shortIntroLabel.maxY_pro + kTextInterval);
        _followerAndRetentionLabel.textLayout = layout.followerAndRetentionLayout;
        
        //underline
        _lineView.size = CGSizeMake(kScreenWidth - kCellX, 0.5);
        _lineView.origin = CGPointMake(kCellX, layout.height - 0.5);
        
        
    } else {
        self.hidden = YES;
    }
}

@end

@implementation BooksListCell

- (void)setupUI {
    
    //初始化对象
    _container = [BooksListContainer new];
    
    [self.contentView addSubview:_container];
}

- (void)setLayout:(BooksListLayout *)layout {
    
    self.height = layout.height;
    
    self.contentView.height = layout.height;
    
    _container.layout = layout;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
