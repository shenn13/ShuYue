//
//  UIViewController+Tool.m
//  geliwuliu
//
//  Created by th on 2017/4/24.
//  Copyright © 2017年 th. All rights reserved.
//

#import "UIViewController+Tool.h"

@implementation UIViewController (Tool)

- (UIButton *)addLeftBarButtonItemImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color {
    
    // 初始化一个返回按钮
    UIImage *backImage = [UIImage imageNamed:imageName];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    if (title.length > 0) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",title]];
        text.font = leftBtn.titleLabel.font;
        
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - backImage.width - kSpaceX, HUGE)];
        container.maximumNumberOfRows = 1;
        
        YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:text];
        
        leftBtn.origin = CGPointMake(0, 0);
        
        leftBtn.size = CGSizeMake(backImage.width + textLayout.textBoundingSize.width, backImage.height);
        
        [leftBtn setTitle:title forState:0];
        
        [leftBtn setTitleColor:color forState:0];
        
    } else {
        
        leftBtn.frame = CGRectMake(0, 0, backImage.width, backImage.height);
    }
    
    [leftBtn setImage:backImage forState:UIControlStateNormal];
    
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    //创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = -5;
    //将两个BarButtonItem都返回给NavigationItem
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
    
    return leftBtn;
}


- (UIButton *)addRightBarButtonItemImageName:(NSString *)imageName width:(CGFloat)width {
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    if (!width) {
        width = image.size.width;
    }
    float height = [image InProportionAtWidth:width];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    [button setBackgroundImage:image forState:0];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    return button;
}

- (UIBarButtonItem *)addRightBarButtonItemTitle:(NSString *)title {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:nil];
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = item;
    
    return item;
    
}

@end
