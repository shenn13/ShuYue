//
//  RecommendView.m
//  Novel
//
//  Created by th on 2017/2/14.
//  Copyright © 2017年 th. All rights reserved.
//

#import "RecommendView.h"

@interface RecommendView()<RecommendCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
//
//@property (nonatomic, strong) UICollectionViewFlowLayout *customLaout;

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, assign) CGFloat colSpace;

@end

@implementation RecommendView

// 注意const的位置
static NSString *const cellId = @"RecommendViewID";
static NSString *const headerId = @"RecommendViewHeaderID";
static NSString *const footerId = @"RecommendViewFooterID";

- (instancetype)initWithFrame:(CGRect)frame datas:(NSArray *)datas {
    
    if (self = [super initWithFrame:frame]) {
        //数据源
        _datas = datas;
        
        
        //自定义布局对象
        UICollectionViewFlowLayout *customLaout = [[UICollectionViewFlowLayout alloc] init];
        
        //每个cell格子的宽高
        customLaout.itemSize = CGSizeMake(recomentItemW, recomentItemH);
        
        _colSpace = (frame.size.width - recomentItemW*4) / 3;
        
        customLaout.minimumLineSpacing = _colSpace; //行间距
        customLaout.minimumInteritemSpacing = _colSpace; //列间距
        
        //滚动方向
        customLaout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:customLaout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.showsVerticalScrollIndicator = NO;
        
        //禁止滚动
        _collectionView.scrollEnabled = NO;
        
        _collectionView.dataSource = self;
        
        _collectionView.delegate = self;
        
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:[RecommendCell class] forCellWithReuseIdentifier:cellId];
     
    }
    return self;
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.model = _datas[indexPath.item];
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
//选中某个item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didClickWithBookModel:)]) {
        [self.delegate didClickWithBookModel:_datas[indexPath.item]];
    }
    
}

- (void)RecommendCellDelegateWithHeieght:(CGFloat)height {
    //每个cell格子的宽高
    
    self.size =  CGSizeMake(self.width, height);
    self.origin = CGPointMake(self.x_pro, self.y_pro);
    
    self.collectionView.frame = self.bounds;
    
    if ([self.delegate respondsToSelector:@selector(RecommendViewDelegateSuccess)]) {
        [self.delegate RecommendViewDelegateSuccess];
    }
}

@end
