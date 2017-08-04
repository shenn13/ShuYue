//
//  AgreeAlertView.h
//  geliwuliu
//
//  Created by xth on 2017/5/26.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreeAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title cancelString:(NSString *)cancelString sureString:(NSString *)sureString;

- (void)showAlertView;

@property (nonatomic, copy) void(^sureBlock)();

@end
