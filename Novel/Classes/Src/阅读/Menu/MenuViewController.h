//
//  MenuViewController.h
//  Novel
//
//  Created by th on 2017/2/27.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseViewController.h"
#define menuTopH 90
#define menuBottomH 55

@interface MenuViewController : BaseViewController


/**
 弹出MenuView

 @param duration 持续时间
 @param completion 完成block
 */
- (void)showMenuViewWithDuration:(CGFloat)duration completion:(void(^)())completion;

/**
隐藏MenuView
 
 @param duration 持续时间
 @param completion 完成block
 */
- (void)hideMenuViewWithDuration:(CGFloat)duration completion:(void(^)())completion;


@property (nonatomic, copy) void(^menuTap)(NSInteger);

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *bookTitle;

@property (nonatomic, strong) UIView *bottomView;

@end
