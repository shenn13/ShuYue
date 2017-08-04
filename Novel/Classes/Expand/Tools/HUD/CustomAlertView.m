//
//  CustomAlertView.m
//  geliwuliu
//
//  Created by th on 2017/5/8.
//  Copyright © 2017年 th. All rights reserved.
//

#import "CustomAlertView.h"

///alertView  宽
#define AlertW 250
///各个栏目之间的距离
#define XLSpace 40

@interface CustomAlertView()

//弹窗
@property (nonatomic,retain) UIView *alertView;

//图片
@property (nonatomic, retain) UIImageView *iconView;

//title
@property (nonatomic,retain) YYLabel *titleLbl;
//确认按钮
@property (nonatomic,retain) UIButton *sureBtn;

//横线线
@property (nonatomic,retain) UIView *lineView;

@end

@implementation CustomAlertView


- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 5.0;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, 100);
        
        //图片和标题之间的距离
        CGFloat space = 8;
        
        //icon
        UIImage *iconImage = [UIImage imageNamed:imageName];
        
        self.iconView = [[UIImageView alloc] init];
        
        [self.alertView addSubview:self.iconView];
        
        
        //title
        self.titleLbl = [YYLabel new];
        self.titleLbl.ignoreCommonProperties = YES;
        
        [self.alertView addSubview:self.titleLbl];
        
        NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:title];
        titleText.font = FONT_SIZE(16);
        titleText.color = kBlackColor;
        
        YYTextContainer *tContainer = [YYTextContainer containerWithSize:CGSizeMake(self.alertView.width_pro - iconImage.width - space, HUGE)];
        tContainer.maximumNumberOfRows = 1;
        
        YYTextLayout *tLayout = [YYTextLayout layoutWithContainer:tContainer text:titleText];
        
        
        //设置frame
        CGFloat w = iconImage.width + space + tLayout.textBoundingSize.width;
        
        self.iconView.frame = CGRectMake((self.alertView.width_pro - w) * 0.5, XLSpace, iconImage.width, iconImage.height);
        
        self.iconView.image = iconImage;
        
        if (iconImage.height - tLayout.textBoundingSize.height >= 0) {
            self.titleLbl.origin = CGPointMake(self.iconView.maxX_pro + space, self.iconView.y_pro + (iconImage.height - tLayout.textBoundingSize.height) * 0.5);
        } else {
            self.titleLbl.origin = CGPointMake(self.iconView.maxX_pro + space, self.iconView.y_pro - (iconImage.height - tLayout.textBoundingSize.height) * 0.5);
        }
        
        self.titleLbl.size = tLayout.textBoundingSize;
        
        self.titleLbl.textLayout = tLayout;
        
        
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = self.titleLbl ? CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame) + XLSpace, AlertW, 1):CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame) + XLSpace, AlertW, 1);
        self.lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        [self.alertView addSubview:self.lineView];
        
        
        
        //只有确定按钮
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.sureBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 40);
        [self.sureBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateNormal];
        [self.sureBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateSelected];
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        self.sureBtn.tag = 2;
        [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.sureBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0, 5.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.sureBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        self.sureBtn.layer.mask = maskLayer;
        
        [self.alertView addSubview:self.sureBtn];
        
        //计算高度
        CGFloat alertHeight = title ? CGRectGetMaxY(self.sureBtn.frame):CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertHeight);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
        
    }
    
    return self;
}

#pragma mark - 弹出 -
- (void)showAlertView {
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation {
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.80, 0.80);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 回调 -设置只有2  -- > 确定才回调
- (void)buttonEvent:(UIButton *)sender {
    if (sender.tag == 2) {
        if (self.resultIndex) {
            self.resultIndex(sender.tag);
        }
    }
    [self removeFromSuperview];
}

-(UILabel *)GetAdaptiveLable:(CGRect)rect AndText:(NSString *)contentStr andIsTitle:(BOOL)isTitle {
    
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:rect];
    contentLbl.numberOfLines = 0;
    contentLbl.text = contentStr;
    contentLbl.textAlignment = NSTextAlignmentCenter;
    if (isTitle) {
        contentLbl.font = [UIFont boldSystemFontOfSize:16.0];
    }else{
        contentLbl.font = [UIFont systemFontOfSize:14.0];
    }
    
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
    mParaStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [mParaStyle setLineSpacing:3.0];
    [mAttrStr addAttribute:NSParagraphStyleAttributeName value:mParaStyle range:NSMakeRange(0,[contentStr length])];
    [contentLbl setAttributedText:mAttrStr];
    [contentLbl sizeToFit];
    
    return contentLbl;
}

-(UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
