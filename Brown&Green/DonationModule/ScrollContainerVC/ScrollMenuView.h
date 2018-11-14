//
//  ScrollMenuView.h
//  Brown&Green
//
//  Created by Anand on 12/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollMenuViewDelegate <NSObject>

- (void)scrollMenuViewSelectedIndex:(NSInteger)index;

@end

@interface ScrollMenuView : UIView
@property (nonatomic, weak) id <ScrollMenuViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *itemTitleArray;
@property (nonatomic, strong) NSArray *itemViewArray;

@property (nonatomic, strong) UIColor *viewbackgroudColor;
@property (nonatomic, strong) UIFont *itemfont;
@property (nonatomic, strong) UIColor *itemTitleColor;
@property (nonatomic, strong) UIColor *itemSelectedTitleColor;
@property (nonatomic, strong) UIColor *itemIndicatorColor;

- (void)setShadowView;

- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio isNextItem:(BOOL)isNextItem toIndex:(NSInteger)toIndex;

- (void)setItemTextColor:(UIColor *)itemTextColor
    seletedItemTextColor:(UIColor *)selectedItemTextColor
            currentIndex:(NSInteger)currentIndex;

@end