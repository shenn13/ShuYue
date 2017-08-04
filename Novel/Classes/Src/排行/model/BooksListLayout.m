//
//  BooksListLayout.m
//  Novel
//
//  Created by th on 2017/2/8.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BooksListLayout.h"

@implementation BooksListLayout

- (instancetype)initWithLayout:(BooksListItemModel *)model {
    
    if (!model) return nil;
    
    self = [super init];
    
    _model = model;
    
    [self _layout];
    
    return self;
}

- (void)_layout {
    
    _height = 0;
    
    _contentHeight = 0;
    
    [self _layoutTitle];
    
    [self _layoutAuthorAndCat];
    
    [self _layoutShortIntro];
    
    [self _layoutFollowerAndRetention];
    
    _height += (_contentHeight+kCellY*2);
}


/** 标题 */
- (void)_layoutTitle {
    if (_model.title.length == 0) {
        _titleLayout = nil;
    } else {
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_model.title];
        text.font = FONT_BOLD_SIZE(BooksListTitleFont);
        text.color = kNormalColor;
        
        CGSize maxSize = CGSizeMake(kScreenWidth - kCellX*3 - kPicWidth_cell, kMaxTextHeight);
        
        YYTextContainer *container = [YYTextContainer containerWithSize:maxSize];
        
        container.maximumNumberOfRows = 1;
        
        _titleLayout = [YYTextLayout layoutWithContainer:container text:text];
        
        _contentHeight += _titleLayout.textBoundingSize.height;
    }
}

/** 读者 | 类型 */
- (void)_layoutAuthorAndCat {
    if (_model.author.length == 0 && _model.cat.length == 0) {
        _authorAndCatLayout = nil;
    } else {
        
        NSString *authorAndCat = nil;
        
        if (_model.cat.length == 0) {
            authorAndCat = [NSString stringWithFormat:@"%@",_model.author];
        } else {
            authorAndCat = [NSString stringWithFormat:@"%@ | %@",_model.author,_model.cat];
        }
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:authorAndCat];
        text.font = FONT_SIZE(BooksListOtherFont);
        text.color = BooksListGray;
        
        CGSize maxSize = CGSizeMake(kScreenWidth - kCellX*3 - kPicWidth_cell, kMaxTextHeight);
        
        YYTextContainer *container = [YYTextContainer containerWithSize:maxSize];
        
        container.maximumNumberOfRows = 1;
        
        _authorAndCatLayout = [YYTextLayout layoutWithContainer:container text:text];
        
        _contentHeight += (_authorAndCatLayout.textBoundingSize.height + kTextInterval);
    }
}

/** 简介 */
- (void)_layoutShortIntro {
    if (_model.shortIntro.length == 0) {
        _shortIntroLayout = nil;
    } else {
        
        // 创建属性字符串
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_model.shortIntro];
        text.font = FONT_BOLD_SIZE(BooksListOtherFont);
        text.color = BooksListGray;
        text.lineBreakMode = NSLineBreakByTruncatingTail;
        
        // 创建文本容器
        
        CGSize maxSize = CGSizeMake(kScreenWidth - kCellX*3 - kPicWidth_cell, HUGE);
        
        YYTextContainer *container = [YYTextContainer containerWithSize:maxSize];
        
        container.maximumNumberOfRows = 1;
        
        // 生成排版结果
        _shortIntroLayout  = [YYTextLayout layoutWithContainer:container text:text];
        
        _contentHeight += (_shortIntroLayout.textBoundingSize.height + kTextInterval);
    }
}

/** n人在追 | n%读者保留 */
- (void)_layoutFollowerAndRetention {
    if (_model.latelyFollower.length == 0 && _model.retentionRatio.length == 0) {
        _followerAndRetentionLayout = nil;
    } else {
        NSString *followerAndRetention = nil;
        
        if (_model.retentionRatio == 0) {
            followerAndRetention = [NSString stringWithFormat:@"%@人在追",_model.latelyFollower];
        } else {
            followerAndRetention = [NSString stringWithFormat:@"%@人在追 | %@%@读者存留",_model.latelyFollower,_model.retentionRatio,@"%"];
        }
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:followerAndRetention];
        text.font = FONT_SIZE(BooksListOtherFont);
        text.color = BooksListNormalColor;
        
        CGSize maxSize = CGSizeMake(kScreenWidth - kCellX*3 - kPicWidth_cell, kMaxTextHeight);
        
        YYTextContainer *container = [YYTextContainer containerWithSize:maxSize];
        container.maximumNumberOfRows = 1;
        
        _followerAndRetentionLayout = [YYTextLayout layoutWithContainer:container text:text];
        
        _contentHeight += (_followerAndRetentionLayout.textBoundingSize.height + kTextInterval);
    }
}




@end
