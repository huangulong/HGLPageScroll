//
//  GLPageInnerViewController.m
//  LexanderA-ScrollDemo
//
//  Created by admin on 2019/4/26.
//  Copyright © 2019 历山大亚. All rights reserved.
//

#import "GLPageInnerViewController.h"

const CGFloat GLPageInnerRefreshHeight = 54;

@interface GLPageInnerViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation GLPageInnerViewController

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    _refreshContentY = GLPageInnerRefreshHeight;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.contentYChangeBlock) {
        self.contentYChangeBlock(scrollView.contentOffset.y);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y + scrollView.contentInset.top + self.refreshContentY < 0) {
        [self startReresh];
    }
}

#pragma mark - private
- (UIScrollView *)contentView{
    if (_tableView) {
        return _tableView;
    }else{
        return _collectionView;
    }
}

- (void)reloadData{
    if (_tableView) {
        [_tableView reloadData];
    }
    if (_collectionView) {
        [_collectionView reloadData];
    }
}

- (void)startReresh{
    NSLog(@"可以刷新了");
    if (self.refreshBlock) {
        self.refreshBlock(self, true);
    }
}

- (void)stopRefresh{
    if (self.refreshBlock) {
        self.refreshBlock(self, false);
    }
}

#pragma mark - getter setter
- (UITableView *)tableView{
    if (_tableView == nil) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        [self.view addSubview:tableView];
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
        }
        _tableView = tableView;
    }
    return _tableView;
}

- (UICollectionViewLayout *)customCollectionLayout{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    CGFloat col = 4;
    CGFloat padding = 8;
    CGFloat width = (self.view.frame.size.width - (col - 1) * padding + 8 * 2)/col;
    layout.minimumInteritemSpacing = padding;
    layout.minimumLineSpacing = padding;
    layout.itemSize = CGSizeMake(width, width);
    
    return layout;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewLayout * layout = [self customCollectionLayout];
        UICollectionView * v = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        v.dataSource = self;
        v.delegate = self;
        v.alwaysBounceVertical = true;
        [v registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.view addSubview:v];
        if (@available(iOS 11.0, *)) {
            v.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView = v;
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
