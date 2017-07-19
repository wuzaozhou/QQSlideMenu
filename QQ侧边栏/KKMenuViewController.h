//
//  KKMenuViewController.h
//  QQ侧边栏
//
//  Created by 吴灶洲 on 2017/7/18.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKMenuViewController : UIViewController
@property (nonatomic, strong, readonly) UIViewController *rootViewController;
/** 显示主试图 */
- (void)showRootViewController;
/** 显示左边视图 */
- (void)showLeftViewController;
/** 显示左边视图 */
-(void)showRightViewController;
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController;
@end
