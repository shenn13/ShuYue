//
//  ContentViewController.m
//  Novel
//
//  Created by th on 2017/2/19.
//  Copyright © 2017年 th. All rights reserved.
//

#import "ContentViewController.h"
#define kRandomColor ([UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f])

@interface ContentViewController ()

@end

@implementation ContentViewController


- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] initWithFrame:kReadingFrame];
        _contentLabel.font = FONT_SIZE(kReadFont);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [_contentLabel setTextVerticalAlignment:YYTextVerticalAlignmentTop];//居上对齐
        [self.view addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (YYLabel *)titleLabl {
    if (!_titleLabl) {
        _titleLabl = [[YYLabel alloc] initWithFrame:CGRectMake(kReadSpaceX, 0, kScreenWidth - kReadSpaceX*2, kReadSpaceY)];
        _titleLabl.font = FONT_SIZE(13);
        _titleLabl.textColor = kNormalColor;
        _titleLabl.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_titleLabl];
    }
    return _titleLabl;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    NSData *imageData = [[NSUserDefaults standardUserDefaults] dataForKey:@"wall"];
    UIImage *image = [UIImage imageWithData:imageData];
    self.view.layer.contents = (__bridge id _Nullable)(image.CGImage);

}


- (void)setBookModel:(BookChapterModel *)bookModel {
    
    _bookModel = bookModel;
    self.titleLabl.text = bookModel.title;
}


- (void)setPage:(NSUInteger)page {
    
    _page = page;
    self.contentLabel.attributedText = [_bookModel getStringWithpage:page];
    self.pageLabel.text = [NSString stringWithFormat:@"%lu/%ld",page+1,(long)_bookModel.pageCount];
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

