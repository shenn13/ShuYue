//
//  ShelfCell.h
//  Novel
//
//  Created by th on 2017/3/6.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseCell.h"

#define ShelfCellHeight 80
#define ShelfCoverW 40
#define ShelfCoverH 50
#define ShelfCoverRx 15 //图片与右边文字间隔

@interface ShelfCell : BaseCell

+ (instancetype)cellWithTalbeView:(UITableView *)tableView;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, strong) BookShelfModel *model;

@property (nonatomic, copy) void(^CellLongPress)(UILongPressGestureRecognizer *longPress);

@end
