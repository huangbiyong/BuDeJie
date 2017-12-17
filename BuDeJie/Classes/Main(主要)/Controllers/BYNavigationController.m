//
//  BYNavigationController.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/7.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYNavigationController.h"

@interface BYNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation BYNavigationController

+(void)load {
    
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    // 设置 导航条字体大小
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20.0f];
    [navBar setTitleTextAttributes:attrs];
    
    // 设置导航条背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置滑动手势监听
    
    //NSLog(@"%@",self.interactivePopGestureRecognizer);
    /*
     <UIScreenEdgePanGestureRecognizer: 0x7fece3413e70; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7fece352a630>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fece3413680>)>>
     */
    
    // 1. 正常的左侧滑动返回
    self.interactivePopGestureRecognizer.delegate = self;
    
    
    // 2. 全屏滑动返回
    /**************** begin *******************/
    
    /*
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    
    pan.delegate = self;
    
    // 禁止之前手势
    self.interactivePopGestureRecognizer.enabled = NO;
     */
    
    /**************** end *******************/
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // 在栈顶不需要滑动返回，不然会导致界面假死
    // self.viewControllers.count > 1 为yes ; <=1 为no
    return self.viewControllers.count > 1;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 恢复滑动返回功能 -> 分析：把系统的返回按钮覆盖
    
    // 利用leftBarButtonItem 来实现返回按钮
    // initWithRootViewController 也会进入这个方法，所以栈顶没有返回按钮
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) title:@"返回"];;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end






