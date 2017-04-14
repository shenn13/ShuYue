//
//  ThemeVCCell.m
//  Novel
//
//  Created by shen on 17/3/29.
//  Copyright © 2017年 th. All rights reserved.
//

#import "ThemeVCCell.h"

@implementation ThemeVCCell
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self){
        
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [kLineColor CGColor];
        self.layer.borderWidth = 1.0f;
        
        [self addSubviews];
        
    }else{
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    return self;
}

-(void)addSubviews{
    
    _imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
    _imageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_imageView];
    
    
    _titleName = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.height - 30, self.contentView.width, 20)];
    _titleName.font = [UIFont systemFontOfSize:16];
    _titleName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleName];
}
@end
