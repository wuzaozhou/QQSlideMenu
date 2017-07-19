# QQSlideMenu
模仿QQ侧边栏  
1、如果主控制是UITabBarController页面push做法
//获取RootViewController     
UITabBarController *tabbarVC = (UITabBarController *)self.menuVc.rootViewController;     
UINavigationController *nav = (UINavigationController *)tabbarVC.selectedViewController;     
[nav pushViewController:vc animated:false];
2、如果住控制器UINavigationController页面push做法
UINavigationController *nav = (UINavigationController *)self.menuVc;
[nav pushViewController:vc animated:false];
