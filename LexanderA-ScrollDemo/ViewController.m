//
//  ViewController.m
//  LexanderA-ScrollDemo
//
//  Created by admin on 2019/4/26.
//  Copyright © 2019 历山大亚. All rights reserved.
//

#import "ViewController.h"
#import "GLPageScrollDemoViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)buttonClick2:(id)sender {
    GLPageScrollDemoViewController * vc = [[GLPageScrollDemoViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)buttonClick1:(id)sender {
    GLPageScrollDemoViewController * vc = [[GLPageScrollDemoViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.view addSubview:nav.view];
    [self addChildViewController:nav];
//    [self presentViewController:nav animated:YES completion:nil];
}


@end
