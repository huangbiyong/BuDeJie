//
//  BYTabBarController.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/6.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYTabBarController.h"
#import "BYEssenceViewController.h"
#import "BYFriendTrendViewController.h"
#import "BYMeViewController.h"
#import "BYNewViewController.h"
#import "BYPublishViewController.h"

#import "BYNavigationController.h"

#import "UIImage+Image.h"
#import "BYTabBar.h"



@interface BYTabBarController ()

@end

@implementation BYTabBarController

// 只执行一次
+ (void)load {
    
    // 获取整个应用程序下的UITabBarItem
    //UITabBarItem *item = [UITabBarItem appearance];
    
    // 获取哪个类中UITabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    // 设置按钮的选中颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    // 设置字体大小： 只有设置正常状态下，才会有效果
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:13.0f];
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 设置控制器
    [self setupAllChildViewController];
    
    // 设置tabbar 按钮
    [self setupTabBarAllButton];
    
    // 自定义tabbar
    [self setupTabBar];
    
}

#pragma mark - 自定义tabBar
- (void)setupTabBar {
    BYTabBar *tabBar = [[BYTabBar alloc]init];
    [self setValue:tabBar forKey:@"tabBar"];
}

#pragma mark - 添加控制器
- (void)setupAllChildViewController {
    
    // 精华
    BYEssenceViewController *essenceVc = [[BYEssenceViewController alloc]init];
    BYNavigationController *nav = [[BYNavigationController alloc]initWithRootViewController:essenceVc];
    [self addChildViewController:nav];
    
    // 新帖
    BYNewViewController *newVc = [[BYNewViewController alloc]init];
    BYNavigationController *nav1 = [[BYNavigationController alloc]initWithRootViewController:newVc];
    [self addChildViewController:nav1];
    
    /*
    BYPublishViewController *publishVc = [[BYPublishViewController alloc]init];
    [self addChildViewController:publishVc];
    */
    
    // 关注
    BYFriendTrendViewController *ftVc = [[BYFriendTrendViewController alloc]init];
    BYNavigationController *nav3 = [[BYNavigationController alloc]initWithRootViewController:ftVc];
    [self addChildViewController:nav3];
    
    // 我
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([BYMeViewController class]) bundle:nil];
    
    BYMeViewController *meVc = [storyboard instantiateInitialViewController];
    BYNavigationController *nav4 = [[BYNavigationController alloc]initWithRootViewController:meVc];
    [self addChildViewController:nav4];
}

#pragma mark - 设置tabbar
- (void)setupTabBarAllButton {
    
    BYNavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"精华";
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    nav.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"tabBar_essence_click_icon"];
    
    
    BYNavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"新帖";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"tabBar_new_click_icon"];
    
    /*
    BYPublishViewController *publishVc = self.childViewControllers[2];
    publishVc.tabBarItem.image = [UIImage imageOriginalWithName:@"tabBar_publish_icon"];
    publishVc.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_publish_click_icon"];
    */
     
    BYNavigationController *nav3 = self.childViewControllers[2];
    nav3.tabBarItem.title = @"关注";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"tabBar_friendTrends_click_icon"];
    
    BYNavigationController *nav4 = self.childViewControllers[3];
    nav4.tabBarItem.title = @"我";
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav4.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"tabBar_me_click_icon"];
    
}


















@end
