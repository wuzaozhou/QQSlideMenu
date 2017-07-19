# QQSlideMenu
模仿QQ侧边栏  如果住控制是UITabBarController页面跳转做法//获取RootViewController     UITabBarController *tabbarVC = (UITabBarController *)self.menuVc.rootViewController;     UINavigationController *nav = (UINavigationController *)tabbarVC.selectedViewController;     [nav pushViewController:vc animated:false];
