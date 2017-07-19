//
//  ViewController.m
//  QQ侧边栏
//
//  Created by 吴灶洲 on 2017/7/18.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

#import "ViewController.h"
#import "KKLeftVC.h"
#import "UIViewController+KKMenuVC.h"
#import "KKMenuViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"左边" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右边" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
}

- (void)leftAction {
    [self.menuVc showLeftViewController];
}

- (void)rightAction {
    [self.menuVc showRightViewController];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
