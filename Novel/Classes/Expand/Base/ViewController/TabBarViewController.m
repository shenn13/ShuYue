//
//  TabBarViewController.m
//  Novel
//
//  Created by shen on 17/3/28.
//  Copyright © 2017年 th. All rights reserved.
//


#import "TabBarViewController.h"
#import "BaseNavigationViewController.h"
#import "UIImage+Extension.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:80.0/255 green:80.0/255 blue:80.0/255 alpha:1]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
    [self.tabBar setBarTintColor:KNavigationBarColor];
    [self addSubViewsControllers];
    [self customTabbarItem];
    
}


-(void)addSubViewsControllers{
    NSArray *classControllers = @[@"BookshelfVC",@"RankingVC",@"SearchVC",@"MyCenterVC"];
    NSMutableArray *conArr = [NSMutableArray array];
    
    for (int i = 0; i < classControllers.count; i ++) {
        Class cts = NSClassFromString(classControllers[i]);
        
        UIViewController *vc = [[cts alloc] init];
        BaseNavigationViewController *naVC = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        
        naVC.fd_fullscreenPopGestureRecognizer.enabled = YES;
        [conArr addObject:naVC];
    }
    self.viewControllers = conArr;
}


-(void)customTabbarItem{
    
    NSArray *titles = @[@"我的书架",@"小说排行",@"热门搜索",@"设置中心"];
    
    NSArray *normalImages = @[@"tabbar_home_default", @"tabbar_municipios_default", @"tabbar_tools_default", @"tabbar_mine_default"];
    //    NSArray *selectImages = @[@"tabbar_home_select", @"tabbar_municipios_select", @"tabbar_tools_select", @"tabbar_mine_select"];
    
    for (int i = 0; i < titles.count; i++) {
        
        UIViewController *vc = self.viewControllers[i];
        
        UIImage *normalImage = [UIImage imageWithOriginalImageName:normalImages[i]];
        //        UIImage *selectImage = [UIImage imageWithOriginalImageName:selectImages[i]];
        
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:normalImage selectedImage:nil];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
