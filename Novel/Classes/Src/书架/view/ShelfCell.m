//
//  ShelfCell.m
//  Novel
//
//  Created by th on 2017/3/6.
//  Copyright © 2017年 th. All rights reserved.
//

#import "ShelfCell.h"

@interface ShelfCell()

@property (nonatomic, strong) YYAnimatedImageView *coverView;

@property (nonatomic, strong) YYLabel *titleLabel;

@property (nonatomic, strong) YYLabel *chapterLabel;

@property (nonatomic, strong) YYAnimatedImageView *updateView;

@end

@implementation ShelfCell

static NSString *ID = @"shelfCellID";

+ (instancetype)cellWithTalbeView:(UITableView *)tableView {
    
    ShelfCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ShelfCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        //设置选中背景颜色
        cell.selectionStyle = UITableViewCellSelectionStyleGray ;
    }
    return cell;
}

- (void)setupUI {
    
    self.height = ShelfCellHeight;
    
    self.contentView.height = ShelfCellHeight;
    
    _coverView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(kCellX, (ShelfCellHeight - ShelfCoverH) * 0.5, ShelfCoverW, ShelfCoverH)];
    
    [self.contentView addSubview:_coverView];
    
    _titleLabel = [YYLabel new];
    
    [self.contentView addSubview:_titleLabel];
    
    _chapterLabel = [YYLabel new];
    
    [self.contentView addSubview:_chapterLabel];
    
    
    _updateView = [YYAnimatedImageView new];
    _updateView.hidden = YES;
    [self.contentView addSubview:_updateView];
    
}


//长按
- (void)handleLongPressGuesture:(UILongPressGestureRecognizer *)guesture {
    
    self.CellLongPress (guesture);
}

- (void)setModel:(BookShelfModel *)model {
    
    _model = model;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGuesture:)];
    
    [self.contentView addGestureRecognizer:longPress];
    
    //cover
    [_coverView setImageWithURL:[NSURL URLWithString:model.coverURL] placeholder:[UIImage imageNamed:@"default_book_cover"]];
    
    //title
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:model.title];
    title.font = FONT_SIZE(16);
    title.lineBreakMode = NSLineBreakByTruncatingTail;
    
    UIImage *updateImage = [UIImage imageNamed:@"update_image"];
    
    //titleLabel要给更新图片留出位置,5为间隔
    CGFloat titleMaxW = kScreenWidth - _coverView.maxX_pro - ShelfCoverRx - kCellX - updateImage.width - 5;
    
    CGSize maxSize = CGSizeMake(titleMaxW, HUGE);
    
    YYTextContainer *container = [YYTextContainer containerWithSize:maxSize];
    
    container.maximumNumberOfRows = 1;//限制一行
    
    YYTextLayout *titleLayout = [YYTextLayout layoutWithContainer:container text:title];
    
    _titleLabel.origin = CGPointMake(_coverView.maxX_pro + ShelfCoverRx, _coverView.y_pro);
    
    _titleLabel.size = titleLayout.textBoundingSize;
    
    _titleLabel.textLayout = titleLayout;
    
    //updateView status=0 -->NO 不显示  status=1 -->YES 显示
    if (1 == [model.status integerValue]) {
        _updateView.hidden = NO;
        _updateView.origin = CGPointMake(_titleLabel.maxX_pro + 5, _titleLabel.y_pro + fabs((titleLayout.textBoundingSize.height - updateImage.height) * 0.5));
        _updateView.size = updateImage.size;
        _updateView.image = updateImage;
    } else {
        _updateView.hidden = YES;
    }
    
    
    //chapterLabel;
    
    //剩下的高度
    CGFloat lastH = ShelfCoverH - titleLayout.textBoundingSize.height;
    
    NSString *chapterStr = NSStringFormat(@"%@%@",[[[DateTools shareDate] getUpdateStringWith:[DateTools dateFromString:model.updated dateformatter:kCustomDateFormat]] stringByAppendingString:@"更新"],model.lastChapter);
    
    NSMutableAttributedString *chapterText = [[NSMutableAttributedString alloc] initWithString:chapterStr];
    chapterText.font = FONT_SIZE(12);
    chapterText.color = kgrayColor;
    chapterText.lineBreakMode = NSLineBreakByTruncatingTail;
    
    YYTextContainer *chapterC = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - _titleLabel.x_pro - kCellX, HUGE)];
    chapterC.maximumNumberOfRows = 1;
    
    YYTextLayout *chapterLayout = [YYTextLayout layoutWithContainer:chapterC text:chapterText];
    
    _chapterLabel.origin = CGPointMake(_titleLabel.x_pro, fabs((lastH - chapterLayout.textBoundingSize.height) * 0.5 ) + _titleLabel.maxY_pro);
    
    _chapterLabel.size = chapterLayout.textBoundingSize;
    
    _chapterLabel.textLayout = chapterLayout;
    
    //添加线条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kCellX, ShelfCellHeight - 0.5 , kScreenWidth - kCellX*2, 0.5)];
    line.backgroundColor = kLineColor;
    
    [self.contentView addSubview:line];
}

- (void)setRow:(NSInteger)row {
    _row = row;
    
    if (0 == row) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kCellX, 0.5 , kScreenWidth - kCellX*2, 0.5)];
        line.backgroundColor = kLineColor;
        
        [self.contentView addSubview:line];
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
