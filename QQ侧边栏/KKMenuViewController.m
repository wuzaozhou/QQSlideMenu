//
//  KKMenuViewController.m
//  QQ侧边栏
//
//  Created by 吴灶洲 on 2017/7/18.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

#import "KKMenuViewController.h"

@interface KKMenuViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;
//菜单宽度
@property (nonatomic, assign, readonly) CGFloat menuWidth;
//留白宽度
@property (nonatomic, assign, readonly) CGFloat emptyWidth;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, assign) CGPoint originalPoint;
@end

//菜单的显示区域占屏幕宽度的百分比
static CGFloat MenuWidthScale = 0.8f;
//遮罩层最高透明度
static CGFloat MaxCoverAlpha = 0.3;
//动画时长
static NSTimeInterval AnimationDuration = 0.25;

@implementation KKMenuViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController {
    self = [super init];
    if (self) {
        _rootViewController = rootViewController;
        _leftViewController = leftViewController;
        _rightViewController = rightViewController;
        [self addChildViewController:rootViewController];
        [self.view addSubview:rootViewController.view];
        [rootViewController didMoveToParentViewController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_leftViewController != nil) {
        [self addChildViewController:_leftViewController];
        [self.view insertSubview:_leftViewController.view atIndex:0];
        [_leftViewController didMoveToParentViewController:self];
    }
    
    if (_rightViewController != nil) {
        [self addChildViewController:_rootViewController];
        [self.view insertSubview:_rightViewController.view atIndex:0];
        [_rightViewController didMoveToParentViewController:self];
    }
    
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    _pan.delegate = self;
    [self.view addGestureRecognizer:_pan];
    
    _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0;
    _coverView.hidden = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_coverView addGestureRecognizer:tap];
    [_rootViewController.view addSubview:_coverView];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLeftVCFrame];
    [self updateRigthVCFrame];
}
/** 更新左边栏frame */
- (void)updateLeftVCFrame {
    _leftViewController.view.center = CGPointMake((CGRectGetMinX(_rootViewController.view.frame) + self.emptyWidth)/2, _leftViewController.view.center.y);
}

/** 更新右边栏frame */
- (void)updateRigthVCFrame {
    _rightViewController.view.center = CGPointMake((self.view.bounds.size.width + CGRectGetMaxX(_rootViewController.view.frame) - self.emptyWidth)/2, _rightViewController.view.center.y);
}

#pragma mark - 点击遮罩层
// 点击遮罩层
- (void)tap {
    [self showRootViewController];
}

#pragma mark 拖拽方法
-(void)pan:(UIPanGestureRecognizer*)pan{

    switch (pan.state) {
            //记录起始位置 方便拖拽移动
        case UIGestureRecognizerStateBegan:
            _originalPoint = _rootViewController.view.center;
            break;
        case UIGestureRecognizerStateChanged:
            [self panChanged:pan];
            break;
            //滑动结束后自动归位
        case UIGestureRecognizerStateEnded:
            if (CGRectGetMinX(_rootViewController.view.frame) > self.menuWidth/2) {
                [self showLeftViewController];
            }else if (CGRectGetMaxX(_rootViewController.view.frame) < self.menuWidth/2 + self.emptyWidth){
                [self showRightViewController];
            }else{
                [self showRootViewController];
            }
            break;
            
        default:
            break;
    }
}

//拖拽方法
-(void)panChanged:(UIPanGestureRecognizer*)pan{
    //拖拽的距离
    CGPoint translation = [pan translationInView:self.view];
    //移动主控制器
    _rootViewController.view.center = CGPointMake(_originalPoint.x + translation.x, _originalPoint.y);
    //判断是否设置了左右菜单
    if (!_rightViewController && CGRectGetMinX(_rootViewController.view.frame) <= 0 ) {
        _rootViewController.view.frame = self.view.bounds;
    }
    if (!_leftViewController && CGRectGetMinX(_rootViewController.view.frame) >= 0) {
        _rootViewController.view.frame = self.view.bounds;
    }
    //滑动到边缘位置后不可以继续滑动
    if (CGRectGetMinX(_rootViewController.view.frame) > self.menuWidth) {
        _rootViewController.view.center = CGPointMake(_rootViewController.view.bounds.size.width/2 + self.menuWidth, _rootViewController.view.center.y);
    }
    if (CGRectGetMaxX(_rootViewController.view.frame) < self.emptyWidth) {
        _rootViewController.view.center = CGPointMake(_rootViewController.view.bounds.size.width/2 - self.menuWidth, _rootViewController.view.center.y);
    }
    //判断显示左菜单还是右菜单
    if (CGRectGetMinX(_rootViewController.view.frame) > 0) {
        //显示左菜单
        [self.view sendSubviewToBack:_rightViewController.view];
        //更新左菜单位置
        [self updateLeftVCFrame];
        //更新遮罩层的透明度
        _coverView.hidden = false;
        _coverView.alpha = CGRectGetMinX(_rootViewController.view.frame)/self.menuWidth * MaxCoverAlpha;
    }else if (CGRectGetMinX(_rootViewController.view.frame) < 0){
        //显示右菜单
        [self.view sendSubviewToBack:_leftViewController.view];
        //更新右侧菜单的位置
        [self updateRigthVCFrame];
        //更新遮罩层的透明度
        _coverView.hidden = false;
        _coverView.alpha = (CGRectGetMaxX(self.view.frame) - CGRectGetMaxX(_rootViewController.view.frame))/self.menuWidth * MaxCoverAlpha;
    }
}

#pragma mark PanDelegate
//设置拖拽响应范围、设置Navigation子视图不可拖拽
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //设置Navigation子视图不可拖拽
    if ([_rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)_rootViewController;
        if (navigationController.viewControllers.count > 1 && navigationController.interactivePopGestureRecognizer.enabled) {
            return NO;
        }
    }
    //如果Tabbar的当前视图是UINavigationController，设置UINavigationController子视图不可拖拽
    if ([_rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarController = (UITabBarController*)_rootViewController;
        UINavigationController *navigationController = tabbarController.selectedViewController;
        if ([navigationController isKindOfClass:[UINavigationController class]]) {
            if (navigationController.viewControllers.count > 1 && navigationController.interactivePopGestureRecognizer.enabled) {
                return NO;
            }
        }
    }
    //设置拖拽响应范围
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        //拖拽响应范围是距离边界是空白位置宽度
        CGFloat actionWidth = [self emptyWidth];
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        if (point.x <= actionWidth || point.x > self.view.bounds.size.width - actionWidth) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}


#pragma mark - 显示/隐藏方法
/** 显示主试图 */
- (void)showRootViewController {
    [UIView animateWithDuration:AnimationDuration animations:^{
        CGRect frame = _rootViewController.view.frame;
        frame.origin.x = 0;
        _rootViewController.view.frame = frame;
        [self updateLeftVCFrame];
        [self updateRigthVCFrame];
        _coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        _coverView.hidden = YES;
    }];
}

/** 显示左边视图 */
- (void)showLeftViewController {
    if (_leftViewController == nil) return;
    [self.view sendSubviewToBack:_rightViewController.view];
    _coverView.hidden = NO;
    [UIView animateWithDuration:AnimationDuration animations:^{
        _rootViewController.view.center = CGPointMake(_rootViewController.view.bounds.size.width/2 + self.menuWidth, _rootViewController.view.center.y);
        _leftViewController.view.frame = self.view.bounds;
        _coverView.alpha = MaxCoverAlpha;
    } completion:^(BOOL finished) {
        
    }];
}

/** 显示左边视图 */
-(void)showRightViewController {
    if (!_rightViewController) {return;}
    _coverView.hidden = NO;
    [self.view sendSubviewToBack:_leftViewController.view];
    [UIView animateWithDuration:AnimationDuration animations:^{
        _rootViewController.view.center = CGPointMake(_rootViewController.view.bounds.size.width/2 - self.menuWidth, _rootViewController.view.center.y);
        _rightViewController.view.frame = self.view.bounds;
        _coverView.alpha = MaxCoverAlpha;
    }];
}

//菜单宽度
-(CGFloat)menuWidth{
    return MenuWidthScale * self.view.bounds.size.width;
}
//空白宽度
-(CGFloat)emptyWidth{
    return self.view.bounds.size.width - self.menuWidth;
}

@end









