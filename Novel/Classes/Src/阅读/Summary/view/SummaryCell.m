//
//  SummaryCell.m
//  Novel
//
//  Created by th on 2017/3/9.
//  Copyright © 2017年 th. All rights reserved.
//

#import "SummaryCell.h"

@interface SummaryCell()

@property (nonatomic, strong) UIButton *iconView;

@property (nonatomic, strong) YYControl *iconV;

@property (nonatomic, strong) YYControl *rightView;

@property (nonatomic, strong) YYLabel *titleLabel;

@property (nonatomic, strong) YYLabel *chapterLabel;

@property (nonatomic, strong) YYLabel *selabel;

@end

@implementation SummaryCell

//static NSString *ID = @"summaryCellID";

+ (instancetype)cellWithTalbeView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    
    SummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (void)setupUI {
    
    //mode_juhe
    
    _iconView = [[UIButton alloc] init];
    _iconView.titleLabel.font = FONT_SIZE(14);
    
    [self.contentView addSubview:_iconView];
    
    _iconV = [YYControl new];
    _iconV.hidden = YES;
    [self.contentView addSubview:_iconV];
    
    _rightView = [[YYControl alloc] init];
    
    [self.contentView addSubview:_rightView];
    
    //title
    _titleLabel = [YYLabel new];
    
    _titleLabel.ignoreCommonProperties = YES;
    
    [self.contentView addSubview:_titleLabel];
    
    _chapterLabel = [YYLabel new];
    
    [self.contentView addSubview:_chapterLabel];
    
    _selabel = [YYLabel new];
    _selabel.hidden = YES;
    [self.contentView addSubview:_selabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    _iconView.backgroundColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.00];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    
    _iconView.backgroundColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.00];
    
}
- (void)setModel:(SummaryModel *)model {
    
    _model = model;
    
    UIImage *iconImage = [UIImage imageNamed:@"mode_juhe"];
    
    UIImage *rightImage = [UIImage imageNamed:@"cell_arrow_day"];
    
    _selabel.hidden = YES;
    
    //当前选择
    if (model.isSelect) {
        _selabel.hidden = NO;
        NSMutableAttributedString *selStr = [[NSMutableAttributedString alloc] initWithString:@"当前选择"];
        selStr.font = FONT_SIZE(14);
        selStr.color = kgrayColor;
        
        YYTextContainer *selContainer = [YYTextContainer containerWithSize:CGSizeMake(100, HUGE)];
        selContainer.maximumNumberOfRows = 1;
        
        YYTextLayout *selLayout = [YYTextLayout layoutWithContainer:selContainer text:selStr];
        
        _selabel.origin = CGPointMake(kScreenWidth - (selLayout.textBoundingSize.width + kCellX + rightImage.width + 15), (SummaryCellHeight - selLayout.textBoundingSize.height) * 0.5);
        _selabel.size = selLayout.textBoundingSize;
        
        _selabel.textLayout = selLayout;
    }
    
    _iconView.frame = CGRectMake(kCellX, (SummaryCellHeight - iconImage.height) * 0.5, iconImage.width, iconImage.width);
    _iconView.layer.cornerRadius = iconImage.width * 0.5;
    _iconView.backgroundColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.00];
    
    YYTextContainer *titleContainer = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - _iconView.maxX_pro - kSpaceX - kCellX - rightImage.width - _selabel.width - 20, HUGE)];
    titleContainer.maximumNumberOfRows = 1;
    
    
    [_iconView setTitle:[model.source substringToIndex:1] forState:UIControlStateNormal];
    
    //title
    NSString *time = NSStringFormat(@"   %@",[[DateTools shareDate] getUpdateStringWith:[DateTools dateFromString:model.updated dateformatter:kCustomDateFormat]]);
    NSString *title = NSStringFormat(@"%@%@",model.source ,time);
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:title];
    
    [titleText setFont:FONT_SIZE(14) range:NSMakeRange(0, model.source.length)];
    [titleText setFont:FONT_SIZE(10) range:NSMakeRange(model.source.length, time.length)];
    
    [titleText setColor:kBlackColor range:NSMakeRange(0, model.source.length)];
    [titleText setColor:kgrayColor range:NSMakeRange(model.source.length, time.length)];
    
    titleText.lineBreakMode = NSLineBreakByTruncatingTail;
    
    YYTextLayout *titleLayout = [YYTextLayout layoutWithContainer:titleContainer text:titleText];
    
    _titleLabel.origin = CGPointMake(_iconView.maxX_pro + kSpaceX, 20);
    
    _titleLabel.size = titleLayout.textBoundingSize;
    
    _titleLabel.textLayout = titleLayout;
    
    //chapterLabel;
    NSMutableAttributedString *chapterText = [[NSMutableAttributedString alloc] initWithString:model.lastChapter];
    chapterText.font = FONT_SIZE(14);
    chapterText.color = kgrayColor;
    chapterText.lineBreakMode = NSLineBreakByTruncatingTail;
    
    YYTextLayout *chapterLayout = [YYTextLayout layoutWithContainer:titleContainer text:chapterText];
    
    _chapterLabel.origin = CGPointMake(_titleLabel.x_pro, _titleLabel.maxY_pro + 5);
    _chapterLabel.size = chapterLayout.textBoundingSize;
    
    _chapterLabel.textLayout = chapterLayout;
    
    _rightView.frame = CGRectMake(kScreenWidth - kCellX - rightImage.width, (SummaryCellHeight - rightImage.height) * 0.5, rightImage.width, rightImage.height);
    
    _rightView.image = rightImage;
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kCellX, SummaryCellHeight - 0.5, kScreenWidth - kCellX*2, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.00];
    [self.contentView addSubview:lineView];
}


@end
