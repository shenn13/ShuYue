//
//  SummaryCell.h
//  Novel
//
//  Created by th on 2017/3/9.
//  Copyright © 2017年 th. All rights reserved.
//

#define SummaryCellHeight 80

#import "BaseCell.h"
#import "SummaryModel.h"

@interface SummaryCell : BaseCell

+ (instancetype)cellWithTalbeView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, strong) SummaryModel *model;

@end
