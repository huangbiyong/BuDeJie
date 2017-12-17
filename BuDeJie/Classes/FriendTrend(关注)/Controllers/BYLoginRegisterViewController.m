//
//  BYLoginRegisterViewController.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/8.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYLoginRegisterViewController.h"
#import "BYLoginRegisterView.h"
#import "BYFastLoginView.h"


@interface BYLoginRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadCons;


@end

@implementation BYLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 登录试图
    BYLoginRegisterView *loginView = [BYLoginRegisterView loginView];
    [_middleView addSubview:loginView];
    
    // 注册试图
    BYLoginRegisterView *registerView = [BYLoginRegisterView registerView];
    [_middleView addSubview:registerView];

    // 快速登录试图
    BYFastLoginView *fastLoginView = [BYFastLoginView fastLoginView];
    [_bottomView addSubview:fastLoginView];
    
    /*
       1.文本框光标变成白色
       2.文本框开始编辑的时候，占位文字颜色变为白色
     
       所以需要自己封装一个输入框(UITextField)
     */
    
}

// view 从xib加载，要在这个方法里重新布局
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    BYLoginRegisterView *loginView = self.middleView.subviews[0];
    loginView.frame = CGRectMake(0, 0, self.middleView.by_width * 0.5, self.middleView.by_height);
    
    BYLoginRegisterView *registerView = self.middleView.subviews[1];
    registerView.frame = CGRectMake(self.middleView.by_width * 0.5, 0, self.middleView.by_width * 0.5, self.middleView.by_height);
    
    BYFastLoginView *fastLoginView = self.bottomView.subviews[0];
    fastLoginView.frame = CGRectMake(0, 0, self.bottomView.by_width, self.bottomView.by_height);
}

#pragma mark - 顶部逻辑

- (IBAction)closeClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registerClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    _leadCons.constant = _leadCons.constant == 0 ? -self.middleView.by_width * 0.5:0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
