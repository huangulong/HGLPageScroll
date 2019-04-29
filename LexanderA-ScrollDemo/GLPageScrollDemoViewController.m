//
//  GLPageScrollDemoViewController.m
//  LexanderA-ScrollDemo
//
//  Created by admin on 2019/4/28.
//  Copyright © 2019 历山大亚. All rights reserved.
//

#import "GLPageScrollDemoViewController.h"
#import "GLPageInnerDemoViewController.h"

@interface GLPageScrollDemoViewController ()<GLPageScrollViewControllerDataSource,GLPageScrollViewControllerDelegate>

@property (nonatomic, strong) UIButton * closeButton;

@property (nonatomic, strong) UIActivityIndicatorView * indicatorView;

@end

@implementation GLPageScrollDemoViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    self.navigationItem.title = @"demo";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    [self loadContentSubView];
}

#pragma mark - GLPageScrollViewControllerDataSource
- (NSInteger)innersWithPageViewController:(GLPageScrollViewController *)pageViewController{
    return 4;
}

- (GLPageInnerViewController *)pageViewController:(GLPageScrollViewController *)pageViewController innerWithIndex:(NSInteger)index{
    GLPageInnerDemoViewController * vc = [[GLPageInnerDemoViewController alloc] init];
    vc.index = index;
    return vc;
}

- (GLPageScrollHeadView *)headViewForPageViewController:(GLPageScrollViewController *)pageViewController{
    GLPageScrollHeadView * view = [[GLPageScrollHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 230)];
    view.bgImageView.backgroundColor = [UIColor redColor];
    for (int i = 0; i < 4; i ++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(i * 80, 180, 80, 44)];
        [button setTitle:[NSString stringWithFormat:@"button%d",i] forState:(UIControlStateNormal)];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:button];
        
    }
    
    return view;
}

#pragma mark - GLPageScrollViewControllerDelegate
- (void)pageViewController:(GLPageScrollViewController *)pageViewController didScrollWithOffsetY:(CGFloat)offsetY{
    if (offsetY < -15) {
        if (self.indicatorView.isHidden) {
            CGRect rect = self.indicatorView.bounds;
            rect.size.width = 20;
            self.indicatorView.bounds = rect;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.indicatorView];
            self.indicatorView.hidden = NO;
        }
        CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*0.01*offsetY);
//
        self.indicatorView.transform = transform;
    }else{
        if (!self.indicatorView.isHidden && !self.indicatorView.isAnimating) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
            self.indicatorView.hidden = YES;
            self.indicatorView.transform = CGAffineTransformIdentity;
        }
//        self.indicatorView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)pageViewController:(GLPageScrollViewController *)pageViewController startRefreshWithIndex:(NSInteger)index{
    self.indicatorView.transform = CGAffineTransformIdentity;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.indicatorView];
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
}

- (void)pageViewController:(GLPageScrollViewController *)pageViewController stopRefreshWithIndex:(NSInteger)index{
    [self.indicatorView stopAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    self.indicatorView.hidden = YES;
}

- (UIButton *)closeButton{
    if (_closeButton == nil) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 20, 44, 44)];
        [button setTitle:@"close" forState:(UIControlStateNormal)];
        button.tag = -1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _closeButton = button;
    }
    return _closeButton;
}

- (UIActivityIndicatorView *)indicatorView{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        _indicatorView.hidesWhenStopped = NO;
        _indicatorView.frame = CGRectMake(0, 0, 44, 44);
    }
    return _indicatorView;
}

#pragma mark - event
- (IBAction)buttonClick:(UIButton *)sender{
    if (sender.tag == -1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    self.pageIndex = sender.tag;
}

@end
