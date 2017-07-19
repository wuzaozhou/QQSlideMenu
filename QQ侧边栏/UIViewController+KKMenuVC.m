//
//  UIViewController+KKMenuVC.m
//  QQ侧边栏
//
//  Created by 吴灶洲 on 2017/7/18.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

#import "UIViewController+KKMenuVC.h"
#import "KKMenuViewController.h"

@implementation UIViewController (KKMenuVC)

//- (KKMenuViewController *)menuVc{
//    UIViewController *sldeMenu = self.parentViewController;
//    while (sldeMenu) {
//        if ([sldeMenu isKindOfClass:[KKMenuViewController class]]) {
//            return (KKMenuViewController *)sldeMenu;
//        } else if (sldeMenu.parentViewController && sldeMenu.parentViewController != sldeMenu) {
//            sldeMenu = sldeMenu.parentViewController;
//        } else {
//            sldeMenu = nil;
//        }
//    }
//    return nil;
//}

- (KKMenuViewController *)menuVc {
    UIViewController *sldeMenu = self.parentViewController;
    while (sldeMenu) {
        if ([sldeMenu isKindOfClass:[KKMenuViewController class]]) {
            return (KKMenuViewController *)sldeMenu;
        } else if (sldeMenu.parentViewController && sldeMenu.parentViewController != sldeMenu) {
            sldeMenu = sldeMenu.parentViewController;
        } else {
            sldeMenu = nil;
        }
    }
    return nil;
}


@end
