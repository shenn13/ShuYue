//
//  RecommendCell.m
//  Novel
//
//  Created by th on 2017/2/14.
//  Copyright © 2017年 th. All rights reserved.
//

#import "RecommendCell.h"

@interface RecommendCell()

@property (nonatomic,strong) YYLabel *titleLabel;

@property (nonatomic, strong) YYAnimatedImageView *coverView;

@end

@implementation RecommendCell

- (YYAnimatedImageView *)coverView {
    if (!_coverView) {
        _coverView = [YYAnimatedImageView new];
    }
    return _coverView;
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.font = FONT_SIZE(13);
        _titleLabel.textColor = kBlackColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.coverView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setModel:(BooksListItemModel *)model {
    _model = model;
    
    self.coverView.frame = CGRectMake(0, 0, coverW, coverH);
    
    [_coverView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",statics_URL,model.cover]] placeholder:[UIImage imageNamed:@"default_book_cover"]];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.title];
    text.font = _titleLabel.font;
    text.color = _titleLabel.textColor;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(coverW, HUGE)];
    container.maximumNumberOfRows = 1;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
    
    _titleLabel.size = layout.textBoundingSize;
    _titleLabel.origin = CGPointMake(0, _coverView.maxY_pro + RlineSpace);
    
    _titleLabel.textLayout = layout;
    
    if ([self.delegate respondsToSelector:@selector(RecommendCellDelegateWithHeieght:)]) {
        [self.delegate RecommendCellDelegateWithHeieght:_titleLabel.maxY_pro];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
