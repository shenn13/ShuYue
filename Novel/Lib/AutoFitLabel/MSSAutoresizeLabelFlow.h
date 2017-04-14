//
//  MSSAutoresizeLabelFlow.h
//  MSSAutoresizeLabelFlow
//
//  Created by Mrss on 15/12/26.
//  Copyright © 2015年 expai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedHandler)(NSUInteger index,NSString *title);


@protocol MSSAutoresizeLabelFlowDelegate <NSObject>

- (void)autoLabelHeight:(CGFloat)height;

@end

@interface MSSAutoresizeLabelFlow : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titlesz
              selectedHandler:(selectedHandler)handler;

- (void)insertLabelWithTitle:(NSString *)title
                     atIndex:(NSUInteger)index
                    animated:(BOOL)animated;

- (void)insertLabelsWithTitles:(NSArray *)titles
                     atIndexes:(NSIndexSet *)indexes
                      animated:(BOOL)animated;

- (void)deleteLabelAtIndex:(NSUInteger)index
                  animated:(BOOL)animated;

- (void)deleteLabelsAtIndexes:(NSIndexSet *)indexes
                     animated:(BOOL)animated;

- (void)reloadAllWithTitles:(NSArray *)titles;

@property (nonatomic, weak) id<MSSAutoresizeLabelFlowDelegate> delegate;

@end




