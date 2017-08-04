//
//  AboutVC.m
//  Novel
//
//  Created by shen on 17/3/28.
//  Copyright © 2017年 th. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"APP说明";
    [self aboutAPP];
}

-(void)aboutAPP{
    
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
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(header.frame)+ 10 ,kScreenWidth - 40, 160)];
    textView.text = @"百万部玄幻、武侠、言情、都市、穿越、宫斗、历史、军事、热门、网络、经典小说样样俱全任你阅读。\n1. 自动跟踪最新章节，更新无延迟。\n2. 智能阅读自动翻页、保证阅读流畅。\n3. 包身瘦小，省电省流量。\n4. 专业小编推荐，热门新书不断。";
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textView];
    
    static CGFloat maxHeight = 160.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height >= maxHeight){
        size.height = maxHeight;
        textView.scrollEnabled = YES;   // 允许滚动
    }
    else{
        textView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height );
    
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
