//
//  DirectoryCell.h
//  Novel
//
//  Created by th on 2017/3/1.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseCell.h"

@interface DirectoryCell : BaseCell

+ (instancetype)cellWithTalbeView:(UITableView *)tableView;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) NSString *title;

@end
