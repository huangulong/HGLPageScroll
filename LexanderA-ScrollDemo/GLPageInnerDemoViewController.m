//
//  GLPageInnerDemoViewController.m
//  LexanderA-ScrollDemo
//
//  Created by admin on 2019/4/28.
//  Copyright © 2019 历山大亚. All rights reserved.
//

#import "GLPageInnerDemoViewController.h"

@interface GLPageInnerDemoViewController ()

@end

@implementation GLPageInnerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadLocalData];
    if (self.index % 2 == 1) {
        self.tableView.backgroundColor = [UIColor whiteColor];
    }else{
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    [self startReresh];
}

- (void)startReresh{
    [super startReresh];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random_uniform(4.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dataArray = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
        [self reloadData];
        [self stopRefresh];
    });
}

- (void)loadLocalData{
    
}

@end
