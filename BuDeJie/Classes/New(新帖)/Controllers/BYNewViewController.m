//
//  BYNewViewController.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/6.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYNewViewController.h"
#import "BYSubTagViewController.h"


@interface BYNewViewController ()

@end

@implementation BYNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self setupNavBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:BYTabBarButtonDidRepeatClickNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听
/*
 重复点击监听
 */
- (void)tabBarButtonDidRepeatClick {
    
    if (self.view.window == nil) return;
    
    NSLog(@"%s",__func__);
}


#pragma mark - 设置导航条
- (void)setupNavBar {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(tagSubClick)];
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

- (void)tagSubClick {
    BYSubTagViewController *tagVc = [[BYSubTagViewController alloc]init];
    [self.navigationController pushViewController:tagVc animated:YES];
}



@end
