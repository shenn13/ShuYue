//
//  MyCenterVC.m
//  Novel
//
//  Created by shen on 17/3/28.
//  Copyright © 2017年 th. All rights reserved.
//

#import "MyCenterVC.h"
#import "AboutVC.h"
#import "ThenmeVC.h"

@interface MyCenterVC (){
    UILabel *_canchSizeLabel;
}

@end

@implementation MyCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem =  nil;
    self.title = @"设置中心";
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createMyView];
}

-(void)createMyView{
    
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 150)];
    header.backgroundColor = KNavigationBarColor;
    [self.view addSubview:header];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2, (header.height - 120)/2, 100, 100)];
    imageView.layer.cornerRadius = imageView.width/2;
    imageView.layer.masksToBounds = YES;
    
    imageView.image = [UIImage imageNamed:@"logoimage"];
    [header addSubview:imageView];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(imageView.frame)+ 5 , kScreenWidth,20)];
    label.text = [NSString stringWithFormat:@"版本号:%@(%@)",app_Version,app_build];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    [header addSubview:label];
    
    NSArray *picImageArr = @[@"loveimage",@"mycenter",@"pingfen"];
    NSArray *nameArr = @[@"更多主题",@"关于APP",@"为我评分"];
    for (int i = 0; i < picImageArr.count; i ++) {
        
        UIView *myBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(header.frame) + 57 * i, kScreenWidth, 55)];
        myBgView.tag = i;
        myBgView.userInteractionEnabled = YES;
        myBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:myBgView];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [myBgView addGestureRecognizer:singleTap];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 55, kScreenWidth, 2)];
        line.backgroundColor = kLineColor;
        [myBgView addSubview:line];
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 25, 25)];
        iconImage.image = [UIImage imageNamed:picImageArr[i]];
        [myBgView addSubview:iconImage];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 15, 125, 25)];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.text = nameArr[i];
        [myBgView addSubview:nameLabel];
        
        UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 15, 25, 25)];
        arrowImage.image = [UIImage imageNamed:@"about"];
        [myBgView addSubview:arrowImage];

    }
}
-(void)viewClick:(UITapGestureRecognizer*)gesture{
    
    UIView *v = (UIView*)gesture.view;
    switch (v.tag) {
        case 0:
             [self pushThemeViewController];
            break;
            
        case 1:
           [self pushAboutViewController];
            break;
        case 2:
            [self releaseInfo];
            break;
        case 3:
            
            break;
        default:
            break;
    }
}



-(void)pushAboutViewController{
    
    AboutVC *aboutVC = [[AboutVC alloc] init];
    aboutVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutVC animated:NO];
}
-(void)pushThemeViewController{
    
    ThenmeVC *themeVC = [[ThenmeVC alloc] init];
    themeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:themeVC animated:NO];
}


- (void)releaseInfo{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPCommentURL]];
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
