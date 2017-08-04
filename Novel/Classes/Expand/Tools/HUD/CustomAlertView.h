//
//  CustomAlertView.h
//  geliwuliu
//
//  Created by th on 2017/5/8.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertResult)(NSInteger index);

@interface CustomAlertView : UIView

@property (nonatomic,copy) AlertResult resultIndex;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;

- (void)showAlertView;

@end
