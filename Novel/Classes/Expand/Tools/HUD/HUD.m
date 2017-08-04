//
//  HUD.m
//  geliwuliu
//
//  Created by th on 2017/5/5.
//  Copyright © 2017年 th. All rights reserved.
//

#import "HUD.h"

@implementation HUD

+ (instancetype)shareInstance{
    
    static HUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HUD alloc] init];
    });
    
    return instance;
}

+ (void)show:(NSString *)msg inView:(UIView *)view mode:(HudProgressMode)myMode{
    [self show:msg inView:view mode:myMode customImgView:nil];
}

+ (void)show:(NSString *)msg inView:(UIView *)view mode:(HudProgressMode)myMode customImgView:(UIImageView *)customImgView{
    //如果已有弹框，先消失
    if ([HUD shareInstance].hud != nil) {
        [[HUD shareInstance].hud hideAnimated:YES];
        [HUD shareInstance].hud = nil;
    }
    
    //4\4s屏幕避免键盘存在时遮挡
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [view endEditing:YES];
    }
    
    [HUD shareInstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    //这里设置是否显示遮罩层
    //[YJProgressHUD shareInstance].hud.dimBackground = YES;    //是否显示透明背景
    
    //是否设置黑色背景，这两句配合使用
    [HUD shareInstance].hud.bezelView.color = [UIColor blackColor];
    [HUD shareInstance].hud.contentColor = [UIColor whiteColor];
    
    [[HUD shareInstance].hud setMargin:10];
    [[HUD shareInstance].hud setRemoveFromSuperViewOnHide:YES];
    [HUD shareInstance].hud.detailsLabel.text = msg;
    
    [HUD shareInstance].hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    
    
    switch ((NSInteger)myMode) {
        case HudProgressModeOnlyText: //仅文字
            [HUD shareInstance].hud.mode = MBProgressHUDModeText;
            break;
            
        case HudProgressModeLoading: //系统菊花
            [HUD shareInstance].hud.mode = MBProgressHUDModeIndeterminate;
            break;
            
        case HudProgressModeCircle:{ //环形
            
            //设置白色背景，
            [HUD shareInstance].hud.bezelView.color = kWhiteColor;
            [HUD shareInstance].hud.contentColor = kNormalColor;
            
            [[HUD shareInstance].hud setMargin:10];
            
            [HUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"londingProgress"]];
            CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            animation.toValue = [NSNumber numberWithFloat:M_PI*2];
            animation.duration = 1.0;
            animation.removedOnCompletion = NO;
            animation.repeatCount = INFINITY;
            animation.fillMode = kCAFillModeForwards;
            [img.layer addAnimation:animation forKey:nil];
            [HUD shareInstance].hud.customView = img;
            
            
            break;
        }
        case HudProgressModeCustomerImage://自定义图片
            [HUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            [HUD shareInstance].hud.customView = customImgView;
            break;
            
        case HudProgressModeCustomAnimation://自定义加载动画（序列帧实现）
            //这里设置动画的背景色
            [HUD shareInstance].hud.bezelView.color = [UIColor yellowColor];
            
            
            [HUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            [HUD shareInstance].hud.customView = customImgView;
            
            break;
            
        case HudProgressModeSuccess://成功
            [HUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            [HUD shareInstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
            break;
            
        default:
            break;
    }
    
    
    
}


+ (void)hide{
    if ([HUD shareInstance].hud != nil) {
        [[HUD shareInstance].hud hideAnimated:YES];
    }
}


+ (void)showMessage:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:HudProgressModeOnlyText];
    [[HUD shareInstance].hud hideAnimated:YES afterDelay:HUDAfterDelayTime];
}



+ (void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay{
    [self show:msg inView:view mode:HudProgressModeOnlyText];
    [[HUD shareInstance].hud hideAnimated:YES afterDelay:delay];
}

+ (void)showSuccess:(NSString *)msg inview:(UIView *)view{
    [self show:msg inView:view mode:HudProgressModeSuccess];
    [[HUD shareInstance].hud hideAnimated:YES afterDelay:HUDAfterDelayTime];
    
}

+ (void)showMsgWithImage:(NSString *)msg imageName:(NSString *)imageName inview:(UIView *)view{
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self show:msg inView:view mode:HudProgressModeCustomerImage customImgView:img];
    [[HUD shareInstance].hud hideAnimated:YES afterDelay:HUDAfterDelayTime];
}


+ (void)showProgress:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:HudProgressModeLoading];
}

+ (MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.detailsLabel.text = msg;
    return hud;
    
    
}

+ (void)showProgressCircleNoValue:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:HudProgressModeCircle];
    
}


+(void)showMsgWithoutView:(NSString *)msg{
    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    [self show:msg inView:view mode:HudProgressModeOnlyText];
    [[HUD shareInstance].hud hideAnimated:YES afterDelay:HUDAfterDelayTime];
    
}

+ (void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view{
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [self show:msg inView:view mode:HudProgressModeCustomAnimation customImgView:showImageView];
}



+ (void)showSuccessWithTitle:(NSString *)title {
    
    [[HUD shareInstance] showSuccessWithTitle:title];
}

- (void)showSuccessWithTitle:(NSString *)title {
    
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:title imageName:@"成功"];
    
    [alertView showAlertView];
}

+ (void)showAgreenWithTitle:(NSString *)title cancelString:(NSString *)cancelString sureString:(NSString *)sureString tapWithSure:(void(^)())tapWithSure {
    
    [[HUD shareInstance] showAgreenWithTitle:title cancelString:cancelString sureString:sureString tapWithSure:^{
        tapWithSure();
    }];
}

- (void)showAgreenWithTitle:(NSString *)title cancelString:(NSString *)cancelString sureString:(NSString *)sureString tapWithSure:(void(^)())tapWithSure {
    
    AgreeAlertView *alertView = [[AgreeAlertView alloc] initWithTitle:title cancelString:cancelString sureString:sureString];
    
    [alertView showAlertView];
    
    alertView.sureBlock = ^{
        
        tapWithSure();
    };
    
}

@end
