//
//  ThenmeVC.m
//  Novel
//
//  Created by shen on 17/3/29.
//  Copyright © 2017年 th. All rights reserved.
//

#import "ThenmeVC.h"
#import "ThemeVCCell.h"

@interface ThenmeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UICollectionView *_collectView;
    NSArray *_dataArr;
}

@end

@implementation ThenmeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"背景设置";
    [self createCollectViewView];
}

-(void)createCollectViewView{
    
    _dataArr = @[@"day_mode_bg",@"green_mode_bg",@"pink_mode_bg",@"sheepskin_mode_bg",@"violet_mode_bg",@"water_mode_bg",@"weekGreen_mode_bg",@"weekPink_mode_bg",@"yellow_mode_bg",@"body_bg",@"body_bg3",@"body_bg4"];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64, kScreenWidth, kScreenHeight - 64) collectionViewLayout:layout];
    _collectView.delegate=self;
    _collectView.dataSource=self;
    _collectView.backgroundColor = [UIColor whiteColor];
    [_collectView registerClass:[ThemeVCCell class] forCellWithReuseIdentifier:@"ThemeCellID"];
    [self.view addSubview:_collectView];
}

#pragma mark --UICollectionViewDelegate

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth - 60)/3, 120);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ThemeVCCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThemeCellID" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleName.text = @"默认";
    }else{
        [cell.titleName setHidden:YES];
    }
    cell.imageView.image = [UIImage imageNamed:_dataArr[indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self change:_dataArr[indexPath.row]];
    [SVProgressHUD showSuccessWithStatus:@"背景设置成功"];
    [SVProgressHUD dismissWithDelay:1.5];
    
    [_collectView reloadData];
    
}

-(void)change:(NSString *)pic {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UIImage *image = [UIImage imageNamed:pic];
    NSData *imageData = UIImageJPEGRepresentation(image, 100);
    [defaults setObject:imageData forKey:@"wall"];
    [defaults synchronize];
    
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
