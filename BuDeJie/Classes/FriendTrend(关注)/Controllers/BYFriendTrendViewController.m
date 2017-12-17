//
//  BYFriendTrendViewController.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/6.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYFriendTrendViewController.h"
#import "BYLoginRegisterViewController.h"

#import "UITextField+Placeholder.h"

@interface BYFriendTrendViewController ()

@property (weak, nonatomic) IBOutlet UITextField *testField;

@end

@implementation BYFriendTrendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _testField.placeholderColor = [UIColor greenColor];
    _testField.placeholder = @"123";
    
    [self setupNavBar];
}




#pragma mark - 点击登录注册
- (IBAction)clickLoginRegister:(UIButton *)sender {
    
    BYLoginRegisterViewController *loginRVc = [[BYLoginRegisterViewController alloc]init];
    [self presentViewController:loginRVc animated:YES completion:nil];
}

#pragma mark - 设置导航条
- (void)setupNavBar {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendsRecomment)];
    
    self.navigationItem.title = @"我的关注";
}

- (void)friendsRecomment {
    
}


@end
