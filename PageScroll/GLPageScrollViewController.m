//
//  GLPageScrollViewController.m
//  LexanderA-ScrollDemo
//
//  Created by admin on 2019/4/26.
//  Copyright © 2019 历山大亚. All rights reserved.
//

#import "GLPageScrollViewController.h"

@interface GLPageScrollViewController ()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger gl_count;

@property (nonatomic, strong) NSMutableDictionary * viewControllers;

@property (nonatomic, assign) CGFloat contentY;

@end

@implementation GLPageScrollViewController

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewControllers = [NSMutableDictionary dictionary];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadContentView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"%s",__FUNCTION__);
    for (NSInteger i = self.pageIndex - 1; i <= self.pageIndex + 1; i+=2) {
        if (i >= 0 && i < self.gl_count) {
            GLPageInnerViewController * vc = [self.viewControllers objectForKey:@(i)];
            vc.contentView.contentOffset = CGPointMake(0, self.contentY);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    pagingEnabled 为 true时 decelerate永远是true
//    pagingEnabled 为 false时
//    如果还有滑动的趋势那decelerate是true，并且会调用scrollViewWillBegin(DidEnd)Decelerating
//    如果已停止了那decelerate是false。
    NSLog(@"%s  %@",__FUNCTION__,decelerate?@"YES":@"NO");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%s",__FUNCTION__);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%s",__FUNCTION__);
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    if ([self.delegate respondsToSelector:@selector(pageViewController:willShowInnerWithIndex:)]) {
        [self.delegate pageViewController:self willShowInnerWithIndex:index];
    }
    [self layoutWithIndex:index];
    if ([self.delegate respondsToSelector:@selector(pageViewController:didShowInnerWithIndex:)]) {
        [self.delegate pageViewController:self didShowInnerWithIndex:index];
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //如果setContentOffset:animation: 的animation设置为yes时，该方法才会被回调
    NSLog(@"%s",__FUNCTION__);
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self layoutWithIndex:index];
}

#pragma mark - public
- (void)loadContentSubView{
    if ([self.delegate respondsToSelector:@selector(willLayoutContentSubView:)]) {
        [self.delegate willLayoutContentSubView:self];
    }
    NSInteger count = 0;
    if ([self.dataSource respondsToSelector:@selector(innersWithPageViewController:)]) {
        count = [self.dataSource innersWithPageViewController:self];
    }
    self.gl_count = count;
    self.contentView.contentSize = CGSizeMake(self.contentView.frame.size.width * count, 0);
    if (_headerView == nil && [self.dataSource respondsToSelector:@selector(headViewForPageViewController:)]) {
        GLPageScrollHeadView * headView = [self.dataSource headViewForPageViewController:self];
        [self.view addSubview:headView];
        _headerView = headView;
    }
    [self layoutWithIndex:self.pageIndex];
    if ([self.delegate respondsToSelector:@selector(didLayoutContentSubView:)]) {
        [self.delegate didLayoutContentSubView:self];
    }
}

- (GLPageInnerViewController *)innerPageViewControllerWithIndex:(NSInteger)index{
    GLPageInnerViewController * vc = [self.viewControllers objectForKey:@(index)];
    if (vc == nil) {
        if ([self.dataSource respondsToSelector:@selector(pageViewController:innerWithIndex:)]) {
            vc = [self.dataSource pageViewController:self innerWithIndex:index];
            [self addChildViewController:vc];
            __weak typeof(self) weakSelf = self;
            vc.contentYChangeBlock = ^(CGFloat contentY) {
                [weakSelf contentYDidChange:contentY];
            };
            vc.refreshBlock = ^(GLPageInnerViewController *vc, BOOL flag) {
                [weakSelf refreshDataWithVC:vc refresh:flag];
            };
            [self.viewControllers setObject:vc forKey:@(index)];
            [self.contentView addSubview:vc.view];
            CGRect rect = self.contentView.bounds;
            rect.origin.x = index * self.contentView.frame.size.width;
            vc.view.frame = rect;
            vc.contentView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height, 0, 0, 0);
            if ([vc.contentView isKindOfClass:[UITableView class]]) {
                [vc.contentView setContentOffset:CGPointMake(0, -self.headerView.frame.size.height)];
            }
        }
    }
    return vc;
}

#pragma mark - private
- (void)contentYDidChange:(CGFloat)contentY{
    CGFloat mY = self.headerView.frame.size.height + contentY;
    NSLog(@".....%f",mY);
    CGRect rect = self.headerView.frame;
    rect.origin.y = -mY;
    self.headerView.frame = rect;
    self.headerView.offsetY = mY;
    self.contentY = contentY;
    if ([self.delegate respondsToSelector:@selector(pageViewController:didScrollWithOffsetY:)]) {
        [self.delegate pageViewController:self didScrollWithOffsetY:mY];
    }
}

- (void)layoutWithIndex:(NSInteger)index{
    GLPageInnerViewController * vc = [self innerPageViewControllerWithIndex:index];
    self.pageIndex = index;
    if (vc) {
        vc.contentView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height, 0, 0, 0);
    }
}

- (void)reloadData{
    for (UIViewController * vc in _viewControllers.allValues) {
        [vc removeFromParentViewController];
        [vc.view removeFromSuperview];
    }
    _viewControllers = [NSMutableDictionary dictionary];
    [self loadContentSubView];
}

- (void)refreshDataWithVC:(GLPageInnerViewController *)pageVC refresh:(BOOL)isRefresh{
    __block NSInteger index = -1;
    [self.viewControllers enumerateKeysAndObjectsUsingBlock:^(NSNumber * key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj == pageVC) {
            index = key.integerValue;
            *stop = true;
        }
    }];
    if (index >= 0) {
        if (isRefresh) {
            if ([self.delegate respondsToSelector:@selector(pageViewController:startRefreshWithIndex:)]) {
                [self.delegate pageViewController:self startRefreshWithIndex:index];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(pageViewController:stopRefreshWithIndex:)]) {
                [self.delegate pageViewController:self stopRefreshWithIndex:index];
            }
        }
        
    }
}

- (void)loadContentView{
    if (_contentView == nil) {
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator= NO;
        scrollView.pagingEnabled = YES;
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:scrollView];
        _contentView = scrollView;
    }
}

#pragma mark - getter setter
- (void)setPageIndex:(NSInteger)pageIndex{
    if (pageIndex == _pageIndex) {
        return;
    }
    if (_contentView) {
        BOOL flag = labs(_pageIndex - pageIndex) <= 1;
        CGPoint contentOffset = CGPointMake(_contentView.frame.size.width * pageIndex, 0);
        [_contentView setContentOffset:contentOffset animated:flag];
        GLPageInnerViewController * vc = [self innerPageViewControllerWithIndex:pageIndex];
        vc.contentView.contentOffset = CGPointMake(0, self.contentY);
    }
    _pageIndex = pageIndex;
}

@end
