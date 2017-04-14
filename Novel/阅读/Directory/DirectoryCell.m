//
//  DirectoryCell.m
//  Novel
//
//  Created by th on 2017/3/1.
//  Copyright © 2017年 th. All rights reserved.
//

#define leftX 20

#import "DirectoryCell.h"

@interface DirectoryCell()

@property (nonatomic, strong) UIImageView *priView;

@property (nonatomic, strong) YYLabel *titleLabel;

@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation DirectoryCell

static NSString *ID = @"directoryID";

+ (instancetype)cellWithTalbeView:(UITableView *)tableView {
    
    DirectoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DirectoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        //设置选中背景颜色
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.00];
    }
    return cell;
}

- (void)setupUI {
    
    _priView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"directory_not_previewed"]];
    
    _priView.frame = CGRectMake(leftX, (self.height - _priView.image.height)*0.5, _priView.image.width, _priView.image.height);
    
    [self.contentView addSubview:_priView];
    
    _titleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(_priView.maxX_pro + 6, 0, self.width - (_priView.maxX_pro + 6)*2, self.height)];
    
    _titleLabel.displaysAsynchronously = YES;
    
    _titleLabel.font = FONT_SIZE(14);
    
    _titleLabel.textColor = kNormalColor;
    
    [self.contentView addSubview:_titleLabel];
    
    
    _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow_day"]];
    
    _arrowView.frame = CGRectMake(_titleLabel.maxX_pro + 6, (self.height - _arrowView.image.height)*0.5, _arrowView.image.width, _arrowView.image.height);
    
    [self.contentView addSubview:_arrowView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_titleLabel.x_pro, self.height-0.5, _titleLabel.width, 0.5)];
    
    lineView.backgroundColor = kLineColor;
    
    [self.contentView addSubview:lineView];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    _priView.image = [UIImage imageNamed:@"directory_not_previewed"];
    _titleLabel.text = title;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    if ([ReadingManager shareReadingManager].chapter == index) {
        _priView.image = [UIImage imageNamed:@"bookDirectory_selected"];
    }
}

@end
