//
//  BYEssenceViewController.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/6.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYEssenceViewController.h"
#import "BYTitleButton.h"

#import "BYAllViewController.h"
#import "BYVideoViewController.h"
#import "BYVoiceViewController.h"
#import "BYPictureViewController.h"
#import "BYWordViewController.h"

@interface BYEssenceViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) BYTitleButton *previousButton;

@property (nonatomic, weak) UIView *titleUnderlineView;

@end

@implementation BYEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];

    // 初始化子控制器
    [self setupAllChildVcs];
    
    // 设置导航条
    [self setupNavBar];
    
    // 设置scrollView
    [self setupScrollView];
    
    // 设置标题栏
    [self setupTitlesView];
}

#pragma mark - 初始化子控制器
- (void)setupAllChildVcs {
    
    [self addChildViewController:[[BYAllViewController alloc] init]];
    [self addChildViewController:[[BYVideoViewController alloc] init]];
    [self addChildViewController:[[BYVoiceViewController alloc] init]];
    [self addChildViewController:[[BYPictureViewController alloc] init]];
    [self addChildViewController:[[BYWordViewController alloc] init]];
}

#pragma mark - 设置scrollView
- (void)setupScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
    scrollView.frame = self.view.bounds;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO;  //点击状态栏，这个scrollView不会滚动到最顶部
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    // 不允许自动修改UIScrollView的内边距
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    
    // 添加子控制器view
    NSInteger count = self.childViewControllers.count;
    CGFloat scrollViewW = scrollView.by_width;

    scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);
}

#pragma mark - 设置标题栏
- (void)setupTitlesView {
    UIView *titleView = [[UIView alloc]init];
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    titleView.frame = CGRectMake(0, 64, self.view.by_width, 35);
    [self.view addSubview:titleView];
    
    self.titleView = titleView;
    
    // 设置标题栏按钮
    [self setupTitleButtons];
    
    // 添加下划线
    [self setupTitleUnderline];
    
    // 添加第0个子控制器
    [self addChildViewToScrollView:0];
    
}

- (void)setupTitleButtons {
    // 文字
    NSArray *titles = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    NSInteger count = titles.count;
    
    // 标题按钮尺寸
    CGFloat titleButtonW = self.titleView.by_width / count;
    CGFloat titleButtonH = self.titleView.by_height;
    
    // 创建按钮
    for (NSInteger i = 0; i < count; i ++) {
        BYTitleButton *titleButton = [[BYTitleButton alloc]init];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleView addSubview:titleButton];
        
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        
        // 设置不同状态下的颜色
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        //[titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        //[titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
}

- (void)setupTitleUnderline {
    // 主要获取按钮的文字和颜色
    BYTitleButton *firstTitleBtn = self.titleView.subviews.firstObject;
    
    // 下划线
    UIView *titleUnderLine = [[UIView alloc]init];
    titleUnderLine.by_height = 2;
    titleUnderLine.by_y = self.titleView.by_height - titleUnderLine.by_height;
    titleUnderLine.backgroundColor = [firstTitleBtn titleColorForState:UIControlStateSelected];
    [self.titleView addSubview:titleUnderLine];
    self.titleUnderlineView = titleUnderLine;
    
    // 默认第一个选中
    firstTitleBtn.selected = YES;
    self.previousButton = firstTitleBtn;
    
    [firstTitleBtn.titleLabel sizeToFit];
    self.titleUnderlineView.by_width = firstTitleBtn.titleLabel.by_width + 10;
    self.titleUnderlineView.by_centerX = firstTitleBtn.by_centerX;

}

#pragma mark - 添加第index 个子控制器的view到scrollView
- (void)addChildViewToScrollView:(NSUInteger)index {
    UIView *childView = self.childViewControllers[index].view;
    
    // 说明已经加过了
    // 方法一
    if (childView.superview) return;
    
    // 方法二
    //if (childView.window) return;
    
    // 方法三
    // if (self.childViewControllers[index].isViewLoaded) return;
    
    CGFloat scrollViewW = self.scrollView.by_width;
    
    childView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.scrollView.by_height);
    [self.scrollView addSubview:childView];
}

#pragma mark - 设置导航条
- (void)setupNavBar {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:nil action:nil];
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

#pragma mark - 监听
- (void)titleButtonClick:(BYTitleButton*)button {

    // 重复点击标题按钮
    if (self.previousButton == button) {
        //NSLog(@"%s",__func__);
        
        // 发送重复点击通知
        [[NSNotificationCenter defaultCenter] postNotificationName:BYTitleButtonDidRepeatClickNotification object:nil];
    }
    
    // 处理标题按钮
    [self dealTitleButtonClick:button];
    
}
// 游戏
- (void)game {
    
}
// 随机
- (void)random {
    
}

// 处理按钮
- (void)dealTitleButtonClick:(BYTitleButton *)button {
    self.previousButton.selected = NO;
    self.previousButton = button;
    self.previousButton.selected = YES;
    
    // 索引
    NSInteger index = button.tag;
    
    // 处理下划线
    [UIView animateWithDuration:0.25 animations:^{
        // 滑动下划线
        self.titleUnderlineView.by_width = button.titleLabel.by_width + 10;
        self.titleUnderlineView.by_centerX = button.by_centerX;
        
        // 滚动scrollView
        CGFloat offset = self.scrollView.by_width * index;
        self.scrollView.contentOffset = CGPointMake(offset, self.scrollView.contentOffset.y);
        
    } completion:^(BOOL finished) {
        // 添加view
        [self addChildViewToScrollView:index];
    }];
    
    
    // 设置index为止对应的tableView.scrollToTop = YES 其他都设置为NO
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        if (!childVc.isViewLoaded) continue;
        
        UIScrollView *scrollView = (UIScrollView*)childVc.view;
        scrollView.scrollsToTop = (i == index);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / BYScreenW;
    
    BYTitleButton *button = self.titleView.subviews[index];
    //[self titleButtonClick:button];
    
    [self dealTitleButtonClick:button];
}


@end

























