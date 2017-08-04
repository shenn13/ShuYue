//
//  ContentViewController.m
//  Novel
//
//  Created by th on 2017/2/19.
//  Copyright © 2017年 th. All rights reserved.
//

#import "ContentViewController.h"
#import "BatteryView.h"

@import GoogleMobileAds;

#define kRandomColor ([UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f])

@interface ContentViewController (){
    
    GADBannerView *_bannerView;
}


@property (nonatomic, strong) YYLabel *contentLabel;

@property (nonatomic, strong) YYLabel *titleLabel;

@property (nonatomic, strong) YYLabel *pageLabel;

@property (nonatomic, strong) BatteryView *batteryView;

@property (nonatomic, strong) YYLabel *timeLabel;

@end

@implementation ContentViewController


- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] initWithFrame:kReadingFrame];
        //        _contentLabel.backgroundColor = kLineColor;
        _contentLabel.font = FONT_SIZE(20);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [_contentLabel setTextVerticalAlignment:YYTextVerticalAlignmentTop];//居上对齐
        [self.view addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(kReadSpaceX, 0, kScreenWidth - kReadSpaceX*2, kReadSpaceY)];
        _titleLabel.font = FONT_SIZE(13);
        _titleLabel.textColor = kNormalColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (YYLabel *)pageLabel {
    if (!_pageLabel) {
        CGFloat w = 100;
        _pageLabel = [[YYLabel alloc] initWithFrame:CGRectMake(kScreenWidth - kReadSpaceX - w, kScreenHeight - kReadSpaceY, w, kReadSpaceY)];
        _pageLabel.font = FONT_SIZE(12);
        _pageLabel.textColor = kNormalColor;
        _pageLabel.textAlignment = NSTextAlignmentRight;
        
        [self.view addSubview:_pageLabel];
    }
    return _pageLabel;
}

- (BatteryView *)batteryView {
    if (!_batteryView) {
        _batteryView = [[BatteryView alloc] initWithFrame:CGRectMake(20, (kReadSpaceY - 10) * 0.5 + kScreenHeight - kReadSpaceY, 25, 10)];
        
        _batteryView.fillColor = [UIColor colorWithRed:0.35 green:0.31 blue:0.22 alpha:1.00];
        
        [self.view addSubview:_batteryView];
    }
    return _batteryView;
}

- (YYLabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[YYLabel alloc] initWithFrame:CGRectMake(45+kSpaceX, kScreenHeight - kReadSpaceY, 50, kReadSpaceY)];
        _timeLabel.font = FONT_SIZE(12);
        _timeLabel.textColor = kNormalColor;
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.view addSubview:_timeLabel];
    }
    return _timeLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self changeBgColorWithIndex:[ReadingManager shareReadingManager].bgColor];
    
    self.timeLabel.text = [[DateTools shareDate] getTimeString];
    
    [self changeOtherColor:[ReadingManager shareReadingManager].bgColor];
   
    
    NSData *imageData = [[NSUserDefaults standardUserDefaults] dataForKey:@"wall"];
    UIImage *image = [UIImage imageWithData:imageData];
    self.view.layer.contents = (__bridge id _Nullable)(image.CGImage);
//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBgColorWithNotifiction:) name:NotificationWithChangeBg object:nil];
//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBgSelectColorWithNotifiction:) name:NotificationWithChangeBgSelect object:nil];
    

}

- (void)changeBgColorWithNotifiction:(NSNotification *)sender {
    
    NSUInteger index = [[sender userInfo][NotificationWithChangeBg] integerValue];
    
    [self changeBgColorWithIndex:index];
}
- (void)changeBgSelectColorWithNotifiction:(NSNotification *)sender {
    
    NSUInteger index = [[sender userInfo][NotificationWithChangeBgSelect] integerValue];
    
    [self changeBgColorWithIndex:index];
}


/** 0-白色 1-黄色 2-淡绿色 3-淡黄色 4-淡紫色 */
- (void)changeBgColorWithIndex:(NSUInteger)index {
    
    NSArray *imgs = @[@"day_mode_bg", @"yellow_mode_bg", @"green_mode_bg", @"sheepskin_mode_bg", @"pink_mode_bg", @"coffee_mode_bg"];
    
    UIImage *bgImage = [UIImage imageNamed:imgs[index]];
    self.view.layer.contents = (__bridge id _Nullable)(bgImage.CGImage);
    
    [self changeOtherColor:index];
    
    self.batteryView.backgroundColor = [bgImage mostColor];
    
    [self.batteryView setNeedsDisplay];
}

- (void)changeOtherColor:(NSUInteger)index {
    if ([ReadingManager shareReadingManager].bgColor == 5) {
        
        NSMutableAttributedString *text = (NSMutableAttributedString *)self.contentLabel.attributedText;
        text.color = KWhiteColor;
        
        self.contentLabel.attributedText = text;
        
        self.titleLabel.textColor = KWhiteColor;
        self.timeLabel.textColor = KWhiteColor;
        self.pageLabel.textColor = KWhiteColor;
        
    } else {
        
        NSMutableAttributedString *text = (NSMutableAttributedString *)self.contentLabel.attributedText;
        text.color = kBlackColor;
        
        self.contentLabel.attributedText = text;
        
        self.titleLabel.textColor = kNormalColor;
        self.timeLabel.textColor = kNormalColor;
        self.pageLabel.textColor = kNormalColor;
    }
}


- (void)setBookModel:(BookChapterModel *)bookModel {
    
    _bookModel = bookModel;
    
    self.titleLabel.text = bookModel.title;
}
    
- (void)setPage:(NSUInteger)page {
    
    _page = page;
    
    self.contentLabel.attributedText = [_bookModel getStringWithpage:page];
    
    self.pageLabel.text = [NSString stringWithFormat:@"%zd/%zd",page+1,_bookModel.pageCount];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

