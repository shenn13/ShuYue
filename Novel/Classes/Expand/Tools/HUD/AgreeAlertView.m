//
//  AgreeAlertView.m
//  geliwuliu
//
//  Created by xth on 2017/5/26.
//  Copyright © 2017年 th. All rights reserved.
//

#import "AgreeAlertView.h"

///alertView  宽
#define AlertW kScreenWidth * 0.7

@interface AgreeAlertView ()

@property (nonatomic, strong) UIView *alertView;


@end

@implementation AgreeAlertView

- (instancetype)initWithTitle:(NSString *)title cancelString:(NSString *)cancelString sureString:(NSString *)sureString {
    
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        
        
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AlertW, 100)];
        _alertView.backgroundColor = kWhiteColor;
        _alertView.layer.position = self.center;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AlertW, 40)];
        titleLabel.font = FONT_SIZE(16);
        titleLabel.textColor = kNormalColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        
        [_alertView addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.maxY_pro, AlertW, 1)];
        lineView.backgroundColor = kLineColor;
        [_alertView addSubview:lineView];
        
        YYTextView *textView = [[YYTextView alloc] initWithFrame:CGRectMake(5, lineView.maxY_pro + 8, AlertW - 16, 80)];
        textView.font = FONT_SIZE(14);
        textView.textColor = kgrayColor;
        [_alertView addSubview:textView];
        
        textView.text = @"商品交付时由第三方物流承运商仔细检查商品，商品完好交付给第三方物流商时后，格利食品网不对商品在运输过程中发生的商品遗失、损毁、延迟送达、误送、未送达或未能提供资料负任何责任。格利食品网不承担上述运输过程所产生的赔偿责任。";
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, textView.maxY_pro + 8, AlertW/2, 40)];
        [cancelBtn setTitleColor:kWhiteColor forState:0];
        cancelBtn.backgroundColor = UIColorHex(#999999);
        cancelBtn.titleLabel.font = FONT_SIZE(16);
        [cancelBtn setTitle:cancelString forState:0];
        [_alertView addSubview:cancelBtn];
        
        cancelBtn.tag = 0;
        
        [cancelBtn addTarget:self action:@selector(dissMissViewWithButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelBtn.maxX_pro, cancelBtn.y_pro, cancelBtn.width_pro, cancelBtn.height_pro)];
        [sureBtn setTitleColor:kWhiteColor forState:0];
        sureBtn.backgroundColor = KNavigationBarColor;
        sureBtn.titleLabel.font = FONT_SIZE(16);
        [sureBtn setTitle:sureString forState:0];
        [_alertView addSubview:sureBtn];
        
        sureBtn.tag = 1;
        
        [sureBtn addTarget:self action:@selector(dissMissViewWithButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _alertView.frame = CGRectMake(0, 0, AlertW, sureBtn.maxY_pro);
        _alertView.layer.position = self.center;
        
        [self addSubview:_alertView];
    }
    
    return self;
}

#pragma mark - 弹出
- (void)showAlertView {
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [self createShowAnimation];
}

- (void)createShowAnimation {
    
    _alertView.layer.position = self.center;
    _alertView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:nil];
    
}

- (void)dissMissViewWithButton:(UIButton *)sender {
    
    if (sender.tag == 1 && _sureBlock) {
        _sureBlock();
    }
    
    [self removeFromSuperview];
}

@end
