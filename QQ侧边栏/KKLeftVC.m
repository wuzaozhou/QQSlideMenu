//
//  KKLeftVC.m
//  QQ侧边栏
//
//  Created by 吴灶洲 on 2017/7/18.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

#import "KKLeftVC.h"
#import "UIViewController+KKMenuVC.h"
#import "KKMenuViewController.h"

@interface KKLeftVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation KKLeftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = @"ViewController";
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.hidesBottomBarWhenPushed = YES;
    //获取RootViewController
    UITabBarController *tabbarVC = (UITabBarController *)self.menuVc.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabbarVC.selectedViewController;
    [nav pushViewController:vc animated:false];
    
    
    //显示主视图
    [self.menuVc showRootViewController];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end





