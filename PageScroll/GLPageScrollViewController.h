//
//  GLPageScrollViewController.h
//  LexanderA-ScrollDemo
//
//  Created by admin on 2019/4/26.
//  Copyright © 2019 历山大亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPageInnerViewController.h"
#import "GLPageScrollHeadView.h"
@class GLPageScrollViewController;
@protocol GLPageScrollViewControllerDelegate <NSObject>

@optional
//contentView 即将布局
- (void)willLayoutContentSubView:(GLPageScrollViewController *)pageViewController;
//contentView 完成布局
- (void)didLayoutContentSubView:(GLPageScrollViewController *)pageViewController;

//contentView.indexView 的偏移量
- (void)pageViewController:(GLPageScrollViewController *)pageViewController didScrollWithOffsetY:(CGFloat)offsetY;

//contentView.indexView 开始刷新
- (void)pageViewController:(GLPageScrollViewController *)pageViewController startRefreshWithIndex:(NSInteger)index;

//contentView.indexView 结束刷新
- (void)pageViewController:(GLPageScrollViewController *)pageViewController stopRefreshWithIndex:(NSInteger)index;

//contentView.indexView 将要显示
- (void)pageViewController:(GLPageScrollViewController *)pageViewController willShowInnerWithIndex:(NSInteger)index;

//contentView.indexView 已然显示
- (void)pageViewController:(GLPageScrollViewController *)pageViewController didShowInnerWithIndex:(NSInteger)index;

@end

@protocol GLPageScrollViewControllerDataSource <NSObject>

- (NSInteger )innersWithPageViewController:(GLPageScrollViewController *)pageViewController;

- (GLPageInnerViewController *)pageViewController:(GLPageScrollViewController *)pageViewController innerWithIndex:(NSInteger)index;

@optional
- (GLPageScrollHeadView *)headViewForPageViewController:(GLPageScrollViewController *)pageViewController;

@end

@interface GLPageScrollViewController : UIViewController

@property (nonatomic, weak) id<GLPageScrollViewControllerDelegate> delegate;

@property (nonatomic, weak) id<GLPageScrollViewControllerDataSource> dataSource;

@property (nonatomic, weak, readonly) GLPageScrollHeadView * headerView;

@property (nonatomic, weak, readonly) UIScrollView * contentView;

//布局contentView的子视图
- (void)loadContentSubView;

@property (nonatomic, assign) NSInteger pageIndex;

- (GLPageInnerViewController *)innerPageViewControllerWithIndex:(NSInteger)index;

//只会重新加载viewcontroller里面的视图， 不会重新调用headerView生成的代理
//如果需要重新加载headerView需要 [self.headerView removeFromSuperView];
- (void)reloadData;

@end
