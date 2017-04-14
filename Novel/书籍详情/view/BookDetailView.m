//
//  BookDetailView.m
//  Novel
//
//  Created by th on 2017/2/12.
//  Copyright © 2017年 th. All rights reserved.
//

#define leftX 20.0f

#import "BookDetailView.h"

@interface BookDetailView()<RecommendViewDelegate>

/** cover */
@property (nonatomic, strong) YYAnimatedImageView *coverView;

/** title */
@property (nonatomic, strong) YYLabel *titleLabel;

/** author */
@property (nonatomic, strong) YYLabel *authorLabel;

/** updateTime */
@property (nonatomic, strong) YYLabel *updateTimeLabel;

/** latelyFollower */
@property (nonatomic, strong) YYLabel *followerLable;

/** retentionRatio */
@property (nonatomic, strong) YYLabel *retentionLabel;

/** serializeWordCount */
@property (nonatomic, strong) YYLabel *countLabel;

/** tagsView */
@property (nonatomic, strong) MSSAutoresizeLabelFlow *tagsView;

/** longIntro */
@property (nonatomic, strong) YYLabel *longIntroLabel;

@property (nonatomic, strong) YYAnimatedImageView *upView;

@property (nonatomic, assign) BOOL is_up;


@property (nonatomic, strong) UIView *underLongIntroLine;

/** Interested */
@property (nonatomic, strong) YYLabel *interestedLabel;

@property (nonatomic, strong) UIButton *moreBtn;


@end

@implementation BookDetailView

#pragma 阅读
- (void)didClickReadAction {
    
    if ([self.delegate respondsToSelector:@selector(didClickReading)]) {
        [self.delegate didClickReading];
    }
}

#pragma mark - 添加/移除书架
- (void)didClickAddAction {
    
    if ([self.delegate respondsToSelector:@selector(didClickAddShelf)]) {
        [self.delegate didClickAddShelf];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _height = 0;
        
        _is_up = NO;
        
        CGFloat topY = 20.0f;
        
        CGFloat bottomH = 30.0f; //按钮下方的空白
        
        CGFloat textH = coverH / 3;
        
        CGFloat coverWithTextSpace = 20.0f;//图片和右边文字的间距
        
        CGFloat coverWithBtnSpace = 20.0f; //图片部分和按钮部分的间距
        
        CGFloat btnSpace = 22.0f; //两个按钮的间距
        
        CGFloat btnH = 50.0f;//按钮高度
        
        CGFloat btnW = (kScreenWidth- leftX*2 - btnSpace) / 2;//按钮宽度
        
        CGFloat lineH = 10.0f;//横线高度
        
        
        //cover
        _coverView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(leftX, topY, coverW, coverH)];
        
        [self addSubview:_coverView];
        
        CGFloat textLeftX = _coverView.maxX_pro + coverWithTextSpace;
        
        CGFloat textW = kScreenWidth - textLeftX - leftX;
        
        
        //title
        _titleLabel = [YYLabel labelWithFrame:CGRectMake(textLeftX, topY, textW, textH) textFont:16 textColor:kBlackColor];
        
//        _titleLabel.text = @"大主宰";
        
        [self addSubview:_titleLabel];
        
        //author
        _authorLabel = [YYLabel labelWithFrame:CGRectMake(textLeftX, _titleLabel.maxY_pro, textW, textH) textFont:12 textColor:kgrayColor];
        
//        _authorLabel.text = @"天蚕土豆 | 异界大陆 | 456万字";
        
        [self addSubview:_authorLabel];
        
        //updateTime
        _updateTimeLabel = [YYLabel labelWithFrame:CGRectMake(textLeftX, _authorLabel.maxY_pro, textW, textH) textFont:12 textColor:kgrayColor];
        
//        _updateTimeLabel.text = @"3小时前更新";
        
        [self addSubview:_updateTimeLabel];
        
        
        //追更新
        _afterBtn = [UIButton buttonWithFrame:CGRectMake(leftX, _coverView.maxY_pro + coverWithBtnSpace, btnW, btnH) titleFont:nil titleColor_normal:kNormalColor titleColor_highlighted:nil backgroundColor:nil borderColor:[UIColor colorWithRed:0.36 green:0.27 blue:0.34 alpha:1.00] borderWidth:1.0f cornerRadius:5.0f];
        
        [_afterBtn setTitle:@"+ 追更新" forState:UIControlStateNormal];
        
        [_afterBtn addTarget:self action:@selector(didClickAddAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_afterBtn];
        
        //开始阅读
        _readingBtn = [UIButton buttonWithFrame:CGRectMake(_afterBtn.maxX_pro + btnSpace, _coverView.maxY_pro + coverWithBtnSpace, btnW, btnH) titleFont:nil titleColor_normal:KWhiteColor titleColor_highlighted:nil backgroundColor:[UIColor colorWithRed:0.36 green:0.27 blue:0.34 alpha:1.00] borderColor:nil borderWidth:0 cornerRadius:5.0f];
        
        [_readingBtn setTitle:@"开始阅读" forState:UIControlStateNormal];
        
        [_readingBtn addTarget:self action:@selector(didClickReadAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_readingBtn];
        
        //一条横线
        UIView *oneLine = [[UIView alloc] initWithFrame:CGRectMake(0, _readingBtn.maxY_pro + bottomH, kScreenWidth, lineH)];
        
        oneLine.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        
        [self addSubview:oneLine];
        
        //追书==label
        
        CGFloat threeLabelW = kScreenWidth / 3;
        
        CGFloat threeLabelH = 80.0f; //设置三个label的高度
        
        NSArray *threeTitles = @[@"追书人数\n暂无数据", @"读者留存率\n暂无数据", @"更新字数/天\n暂无数据"];
        
        for (int i = 0; i < threeTitles.count; i++) {
            YYLabel *label = [[YYLabel alloc] init];
            
            if (i == 0) {
                _followerLable = label;
            } else if (i == 1) {
                _retentionLabel = label;
            } else {
                _countLabel = label;
            }
            
            // label根据文字自适应高度
            label.numberOfLines = 0;
            
            label.lineBreakMode = NSLineBreakByWordWrapping;
            
            // 设置label的行间距
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:threeTitles[i]];
            attributedString.font = FONT_SIZE(14);
            attributedString.color = kgrayColor;
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:8];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [threeTitles[i] length])];
            [label setAttributedText:attributedString];
            [label sizeToFit];
            
            label.textAlignment = NSTextAlignmentCenter;
            
            
            label.frame = CGRectMake(i * threeLabelW, oneLine.maxY_pro, threeLabelW, threeLabelH);
            
            [self addSubview:label];
        }
        
        
        //下划线
        UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(leftX, _followerLable.maxY_pro, kScreenWidth - leftX*2, 0.5)];
        
        underLine.backgroundColor = kLineColor;
        
        [self addSubview:underLine];
        
        //_longIntroLabel
        _longIntroLabel = [YYLabel new];
        
        [self addSubview:_longIntroLabel];
        
        //_underLongIntroLine
        _underLongIntroLine = [UIView new];
        _underLongIntroLine.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        [self addSubview:_underLongIntroLine];
        
        //_interestedLabel
        _interestedLabel = [YYLabel new];
        _interestedLabel.font = FONT_SIZE(16);
        _interestedLabel.textColor = kBlackColor;
        
        [self addSubview:_interestedLabel];
        
        //listBtn
        _moreBtn = [UIButton new];
        [_moreBtn setTitleColor:kgrayColor forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = FONT_SIZE(15);
        [self addSubview:_moreBtn];
        
    }
    
    return self;
}

#pragma mark - MSSAutoresizeLabelFlowDelegate
//接收到MSSAutoresizeLabelFlow的最终高度height,这里设置代理，因为tagView布局延时
- (void)autoLabelHeight:(CGFloat)height {
    @weakify(self);
    if (_model.tags.count > 0) {
        
        UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(leftX, _tagsView.maxY_pro, kScreenWidth - leftX*2, 0.5)];
        
        underLine.backgroundColor = kLineColor;
        
        [self addSubview:underLine];

        if (_shorIntro.length > 0) {
            
            YYTextLayout *layout = [_longIntroLabel layoutWithTitle:_shorIntro maxSize:CGSizeMake(kScreenWidth - leftX*2, HUGE) maximumNumberOfRows:0 textFont:FONT_SIZE(14) textColor:kNormalColor lineSpace:5];
            
            _longIntroLabel.size = layout.textBoundingSize;
            
            _longIntroLabel.origin = CGPointMake(leftX, underLine.maxY_pro+15);
            
            _longIntroLabel.textLayout = layout;
            
            if (![_model.longIntro isEqualToString:_shorIntro]) {
                //添加图片
                _upView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"bd_arrow_down"]];
                
                [self addSubview:_upView];
                
                [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(weak_self).with.offset(-leftX);
                    make.bottom.mas_equalTo(weak_self.longIntroLabel);
                    make.size.mas_equalTo(CGSizeMake(13, 7));
                }];
            }
            
            _height = _longIntroLabel.maxY_pro + 50;
            
            [_longIntroLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagLabel)]];
            
        } else {
            _height = _tagsView.maxY_pro + 50;
        }
    } else {
        
        if (_shorIntro.length > 0) {
            
            YYTextLayout *layout = [_longIntroLabel layoutWithTitle:_shorIntro maxSize:CGSizeMake(kScreenWidth - leftX*2, HUGE) maximumNumberOfRows:0 textFont:FONT_SIZE(14) textColor:kNormalColor lineSpace:5];
            
            _longIntroLabel.size = layout.textBoundingSize;
            
            _longIntroLabel.origin = CGPointMake(leftX, _followerLable.maxY_pro+15);
            
            _longIntroLabel.textLayout = layout;
            
            if (![_model.longIntro isEqualToString:_shorIntro]) {
                //添加图片
                _upView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"bd_arrow_down"]];
                
                [self addSubview:_upView];
                
                @weakify(self);
                [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(weak_self).with.offset(-leftX);
                    make.bottom.mas_equalTo(weak_self.longIntroLabel);
                    make.size.mas_equalTo(CGSizeMake(13, 7));
                }];
            }
            
            _height = _longIntroLabel.maxY_pro + 50;
            
            [_longIntroLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagLabel)]];
            
        } else {
            
            _longIntroLabel.frame = CGRectMake(leftX, _followerLable.maxY_pro + 15, kScreenWidth, 1);
            _longIntroLabel.hidden = YES;
            
            _height = _longIntroLabel.maxY_pro + 50;
        }
        
    }
    
    
    _underLongIntroLine.frame = CGRectMake(0, _longIntroLabel.maxY_pro + 5, kScreenWidth, 8);
    
    //recommentView
    
//    /book/51d11e782de6405c45000068/recommend
    
    
    [Http GET:NSStringFormat(@"%@/book/%@/recommend",SERVERCE_HOST,_model._id) parameters:nil success:^(id responseObject) {
        
        BooksListModel *model = [BooksListModel modelWithDictionary:responseObject];
        
        if (model.books.count > 0) {
            weak_self.interestedLabel.text = @"你可能感兴趣";
            
            weak_self.interestedLabel.frame = CGRectMake(leftX, _underLongIntroLine.maxY_pro, kScreenWidth - leftX*2, 50);
        }
        
        weak_self.recommentView = [[RecommendView alloc] initWithFrame:CGRectMake(leftX, _interestedLabel.maxY_pro, kScreenWidth - leftX*2, 1) datas:model.books];
        
        weak_self.recommentView.delegate = weak_self;
        
        [weak_self addSubview:weak_self.recommentView];
        
        if ([weak_self.delegate respondsToSelector:@selector(bookDetailViewHeight:)]) {
            [weak_self.delegate bookDetailViewHeight:_height];
        }

    } failure:^(NSError *error) {
        weak_self.height = weak_self.interestedLabel.maxY_pro + 50;
        
        if ([weak_self.delegate respondsToSelector:@selector(bookDetailViewHeight:)]) {
            [weak_self.delegate bookDetailViewHeight:_height];
        }
        
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];

    }];
}

#pragma mark - RecommendViewDelegate
- (void)RecommendViewDelegateSuccess {
    
    @weakify(self);
    [_moreBtn addTarget:self action:@selector(didclickMoreBooks) forControlEvents:UIControlEventTouchDown];
    [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weak_self.mas_right).with.offset(-leftX);
        make.centerY.mas_equalTo(weak_self.interestedLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, weak_self.interestedLabel.height/2));
    }];
    
    self.height = self.recommentView.maxY_pro + 50;
    
    if ([self.delegate respondsToSelector:@selector(bookDetailViewHeight:)]) {
        [self.delegate bookDetailViewHeight:_height];
    }
}

- (void)didclickMoreBooks {
    if ([self.delegate respondsToSelector:@selector(didClickMoreBooks)]) {
        [self.delegate didClickMoreBooks];
    }
}

- (void)didClickWithBookModel:(BooksListItemModel *)model {
    
    if ([self.delegate respondsToSelector:@selector(didClickWithRecommendBookModel:)]) {
        [self.delegate didClickWithRecommendBookModel:model];
    }
}

#pragma mark - label's touch
- (void)tagLabel {
    
    if (NO ==_is_up) {
        YYTextLayout *layout = [_longIntroLabel layoutWithTitle:_model.longIntro maxSize:CGSizeMake(kScreenWidth - leftX*2, HUGE) maximumNumberOfRows:0 textFont:FONT_SIZE(14) textColor:kNormalColor lineSpace:5];
        
        _longIntroLabel.size = layout.textBoundingSize;
        
        _longIntroLabel.textLayout = layout;
        
        _is_up = YES;
    } else {
        YYTextLayout *layout = [_longIntroLabel layoutWithTitle:_shorIntro maxSize:CGSizeMake(kScreenWidth - leftX*2, HUGE) maximumNumberOfRows:0 textFont:FONT_SIZE(14) textColor:kNormalColor lineSpace:5];
        
        _longIntroLabel.size = layout.textBoundingSize;
        
        _longIntroLabel.textLayout = layout;
        
        _is_up = NO;
    }
    
    _underLongIntroLine.origin = CGPointMake(0, _longIntroLabel.maxY_pro+5);
    
    _interestedLabel.origin = CGPointMake(leftX, _underLongIntroLine.maxY_pro);
    
    _recommentView.origin = CGPointMake(leftX, _interestedLabel.maxY_pro);
    
    _height = _recommentView.maxY_pro + 50;
    
    if ([self.delegate respondsToSelector:@selector(bookDetailViewHeight:)]) {
        [self.delegate bookDetailViewHeight:_height];
    }
    
    @weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        weak_self.upView.layer.transform = CATransform3DMakeRotation(weak_self.is_up ? M_PI:0, 1, 0, 0);
    }];
}



- (void)setModel:(BookDetailModel *)model {
    
    _model = model;
    
    BOOL res = [SQLiteTool isTableOK:model._id];
    
    if (res) {
        [_afterBtn setTitle:@"- 不追了" forState:UIControlStateNormal];
        
        BookShelfModel *shelfModel = [SQLiteTool getBookWithTableName:model._id];
        
        if ([shelfModel.chapter integerValue] > 0 || [shelfModel.page integerValue] > 0) {
            [_readingBtn setTitle:@"继续阅读" forState:UIControlStateNormal];
        }
    }
    
    [_coverView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",statics_URL,model.cover]] placeholderImage:[UIImage imageNamed:@"default_book_cover"]];
    
    _titleLabel.text = model.title;
    
    NSString *str = [NSString stringWithFormat:@"%@ | %@ | %@",model.author,model.cat,[model getBookWordCount]];
    
    NSMutableAttributedString *titleAttri = [[NSMutableAttributedString alloc] initWithString:str];
    titleAttri.font = FONT_SIZE(12);
    titleAttri.color = kgrayColor;
    [titleAttri setColor:[UIColor colorWithRed:0.71 green:0.13 blue:0.13 alpha:1.00] range:NSMakeRange(0, model.author.length)];
    
    _authorLabel.attributedText = titleAttri;
    
    
    if (model.isSerial) {
        _updateTimeLabel.text = [[[DateTools shareDate] getUpdateStringWith:[DateTools dateFromString:model.updated dateformatter:kCustomDateFormat]] stringByAppendingString:@"更新"];
    } else {
        _updateTimeLabel.text = @"已完结";
    }
    
    _followerLable.text = [NSString stringWithFormat:@"追书人数\n%zi",model.latelyFollower];
    
    if (model.retentionRatio > 0) {
        _retentionLabel.text = [NSString stringWithFormat:@"读者留存率\n%@",model.retentionRatio];
    } else {
        _retentionLabel.text = @"读者留存率\n暂未统计";
    }
    
    if (model.serializeWordCount > 0) {
        _countLabel.text = [NSString stringWithFormat:@"更新字数/天\n%zi",model.serializeWordCount];
    } else {
        _countLabel.text = @"更新字数/天\n暂未统计";
    }
    
    
    if (model.tags.count > 0) {
        _tagsView = [[MSSAutoresizeLabelFlow alloc] initWithFrame:CGRectMake(leftX, _countLabel.maxY_pro+1, kScreenWidth - leftX*2, 50) titles:model.tags selectedHandler:^(NSUInteger index, NSString *title) {
            NSLog(@"%@",title);
        }];
        
        _tagsView.delegate = self;
        
        [self addSubview:_tagsView];
    } else {
        
        //这里要调用下这个方法，如果tags没有元素的话就会错乱
        [self autoLabelHeight:0];
    }
}

@end
