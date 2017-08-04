//
//  SetingView.h
//  Novel
//
//  Created by xth on 2017/5/25.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SetingView;

@protocol SetingViewDelegate <NSObject>

- (void)refreshWithSetingView:(SetingView *)settingView height:(CGFloat)height;

@end

@interface SetingView : UIView

@property (nonatomic, copy) void(^changeSmallerFontBlock)();

@property (nonatomic, copy) void(^changeBiggerFontBlock)();

@property (nonatomic, weak) id<SetingViewDelegate> delegate;

@end
