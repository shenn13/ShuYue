//
//  SetingView.m
//  Novel
//
//  Created by xth on 2017/5/25.
//  Copyright © 2017年 th. All rights reserved.
//

#import "SetingView.h"

@interface SetingView ()

@property (nonatomic, strong) UIButton *lastButton;

@property (nonatomic, strong) UIButton *firstButton;

@property (nonatomic, assign) CGFloat height;

@end

@implementation SetingView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        
        [self settingUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBgButtonSelectWithNotification:) name:NotificationWithChangeBgSelect object:nil];
    }
    
    return self;
}

- (void)changeBgButtonSelectWithNotification:(NSNotification *)sender {
    
    NSUInteger index = [[sender userInfo][NotificationWithChangeBgSelect] integerValue];
    
    if (index == 0) {
        //白天选中第一个白色按钮
        [_firstButton setImage:[UIImage imageNamed:@"setting_theme_selected"] forState:0];
        
    } else {
        
        //黑夜都不要选中
        [_firstButton setImage:nil forState:0];
        [_lastButton setImage:nil forState:0];
    }
    
}

- (void)settingUI {
    
//    setting_font_smaller_normal
    
    
    UIImage *sImg = [UIImage imageNamed:@"setting_font_smaller_normal"];
    
    UIImage *bImg = [UIImage imageNamed:@"setting_font_bigger"];
    
    CGFloat space = 20;
    
    if (IS_IPHONE_6) {
        
        space += 10;
        
    } else if (IS_IPHONE_6P) {
        
        space += 20;
    }
    
    CGFloat x = (self.width - space - sImg.width - bImg.width) * 0.5;
    
    CGFloat y = kSpaceX;
    
    
    UIButton *sButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, sImg.width, sImg.height)];
    [sButton setImage:sImg forState:0];
    [self addSubview:sButton];
    
    UIButton *bButton = [[UIButton alloc] initWithFrame:CGRectMake(sButton.maxX_pro + space, y, bImg.width, bImg.height)];
    [bButton setImage:bImg forState:0];
    [self addSubview:bButton];
    
    
    [sButton addTarget:self action:@selector(smaller) forControlEvents:UIControlEventTouchUpInside];
    [bButton addTarget:self action:@selector(bigger) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSArray *colors = @[UIColorHex(#D9D9D9), UIColorHex(#B4AE99), UIColorHex(#B7E1B9), UIColorHex(#F9E7C0), UIColorHex(#FFCDE0)];
    
    CGFloat btnW = (self.width - 20 * (colors.count + 1)) / colors.count;
    
    CGFloat btnX = 20;
    
    for (int i = 0; i < colors.count; i++) {
        
        if (i != 0) {
            btnX += 20;
        }
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, bButton.maxY_pro + kSpaceX, btnW, btnW)];
        
        btn.tag = i;
        
        btn.backgroundColor = colors[i];
        
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = btnW / 2;
        
        [self addSubview:btn];
        
        btnX = btn.maxX_pro;
        
        if ([ReadingManager shareReadingManager].bgColor == i) {
            
            _lastButton = btn;
            [btn setImage:[UIImage imageNamed:@"setting_theme_selected"] forState:0];
        }
        
        if (i == 0) {
            _firstButton = btn;
        }
        
        [btn addTarget:self action:@selector(tagWithbgButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _height = btn.maxY_pro + kSpaceX;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self.delegate respondsToSelector:@selector(refreshWithSetingView:height:)]) {
        [self.delegate refreshWithSetingView:self height:_height];
    }
}

- (void)tagWithbgButton:(UIButton *)sender {
    
    if ([ReadingManager shareReadingManager].bgColor == sender.tag) return;
    
    [_lastButton setImage:nil forState:0];
    
    [sender setImage:[UIImage imageNamed:@"setting_theme_selected"] forState:0];
    
    _lastButton = sender;
    
    [ReadingManager shareReadingManager].bgColor = sender.tag;
    
    //没有存档
    BookSettingModel *model = [BookSettingModel decodeModelWithKey:[BookSettingModel className]];
    
    model.bgColor = sender.tag;
    
    [BookSettingModel encodeModel:model key:[BookSettingModel className]];
    
    NSLog(@"tag:%ld",sender.tag);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationWithChangeBg object:nil userInfo:@{NotificationWithChangeBg:NSStringFormat(@"%ld", (long)sender.tag)}];
}


- (void)smaller {
    if (_changeSmallerFontBlock) {
        _changeSmallerFontBlock();
    }
}

- (void)bigger {
    if (_changeBiggerFontBlock) {
        _changeBiggerFontBlock();
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
