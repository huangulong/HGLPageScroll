//
//  GLPageInnerViewController.h
//  LexanderA-ScrollDemo
//
//  Created by admin on 2019/4/26.
//  Copyright © 2019 历山大亚. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat GLPageInnerRefreshHeight;

@interface GLPageInnerViewController : UIViewController

// contentView is below View(collectionView or tableView)
@property (nonatomic, weak, readonly) UIScrollView * contentView;

@property (nonatomic, weak) UICollectionView * collectionView;
//创建collectionView时会用到下面的layout方法
- (UICollectionViewLayout *)customCollectionLayout;

@property (nonatomic, weak) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, copy) void(^contentYChangeBlock)(CGFloat contentY);

//需要刷新时的偏移量 默认是54
@property (nonatomic, assign) CGFloat refreshContentY;

@property (nonatomic, copy) void(^refreshBlock)(GLPageInnerViewController * vc, BOOL flag);

//视图重绘
- (void)reloadData;
//接口调用
- (void)startReresh;

- (void)stopRefresh;

@end
