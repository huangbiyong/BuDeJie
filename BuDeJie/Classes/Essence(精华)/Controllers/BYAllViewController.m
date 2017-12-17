//
//  BYAllViewController.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/12.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYAllViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "BYTopic.h"

#import "BYTopicCell.h"


// 枚举写法一
/*
typedef enum {
    BYTopicTypeAll = 1,      // 所有
    BYTopicTypePicture = 10, // 图片
    BYTopicTypeWord = 29,    // 段子
    BYTopicTypeVoice = 31,   // 声音
    BYTopicTypeVideo = 41    // 视频
} BYTopicType;
*/






@interface BYAllViewController ()

/** 帖子数组 */
@property (nonatomic, strong) NSMutableArray<BYTopic*> *topics;
/** 上一页的时间 **/
@property (nonatomic, strong) NSString *maxtime;
/** 请求网络数据的manager **/
@property (nonatomic, strong) AFHTTPSessionManager *manager;


/** 下拉刷新控件 */
@property (nonatomic, weak) UIView *header;
/** 下拉刷新控件里面的文字 */
@property (nonatomic, weak) UILabel *headerLabel;
/** 下拉刷新控件时候正在刷新 */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;

/** 上拉刷新控件 */
@property (nonatomic, weak) UIView *footer;
/** 上拉刷新控件里面的文字 */
@property (nonatomic, weak) UILabel *footerLabel;
/** 上拉刷新控件时候正在刷新 */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;

@end

@implementation BYAllViewController

static NSString * const BYTopicCellId = @"BYTopicCellId";

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 不允许自动修改UIScrollView的内边距
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
    self.tableView.contentInset = UIEdgeInsetsMake(BYNavMaxY + BYTitlesView, 0, BYTabBarH, 0);
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.rowHeight = 200;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYTopicCell class]) bundle:nil] forCellReuseIdentifier:BYTopicCellId];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:BYTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:BYTitleButtonDidRepeatClickNotification object:nil];
     
    [self setupRefresh];

    // 一进入就自动刷新
    [self headerBeginRefreshing];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupRefresh {
    
    // header
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, -50, self.tableView.by_width, 50);
    self.header = header;
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = header.bounds;
    headerLabel.backgroundColor = [UIColor redColor];
    headerLabel.text = @"下拉可以刷新";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:headerLabel];
    self.headerLabel = headerLabel;
    
    //self.tableView.tableHeaderView = header;
    [self.tableView addSubview:header];
    
    
    // footer
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, self.tableView.by_width, 35);
    self.footer = footer;
    
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.frame = footer.bounds;
    footerLabel.backgroundColor = [UIColor redColor];
    footerLabel.text = @"上拉可以加载更多";
    footerLabel.textColor = [UIColor whiteColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:footerLabel];
    self.footerLabel = footerLabel;
    
    self.tableView.tableFooterView = footer;
    
}

#pragma mark - 监听
/*
    tabBarButton 重复点击监听
 */
- (void)tabBarButtonDidRepeatClick {
    
    // 判断当前是否是精华控制器
    if (self.view.window == nil) return;
    
    // 判断是否是all 试图
    if (self.tableView.scrollsToTop == NO) return;
    
    NSLog(@"%s",__func__);
    
    [self headerBeginRefreshing];
}

/*
 tabBarButton 重复点击监听
 */
- (void)titleButtonDidRepeatClick {
    
    // 做得事情一样，这样写为以后方便扩展
    [self tabBarButtonDidRepeatClick];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    self.footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return self.topics[indexPath.row].cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    BYTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:BYTopicCellId];
    cell.topic = self.topics[indexPath.row];;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"contentSize: %@",NSStringFromCGSize(self.tableView.contentSize));
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollView代理方法
/*
    手松开的瞬间
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    //if (self.isHeaderRefreshing) return;
    
    CGFloat offsetY = -(self.tableView.contentInset.top + self.header.by_height);
    if (self.tableView.contentOffset.y <= offsetY) {
        [self headerBeginRefreshing];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 处理header
    [self dealHeader];
    
    // 处理footer
    [self dealFooter];
}

#pragma mark - 处理header
- (void)dealHeader {
    
    if (self.isHeaderRefreshing) return;
    
    // 当scrollView 的偏移量y值 <= offsetY 时，代表header已经完全出现
    CGFloat offsetY = -(self.tableView.contentInset.top + self.header.by_height);
    if (self.tableView.contentOffset.y <= offsetY) {
        //
        self.headerLabel.text = @"松开立即刷新";
        self.headerLabel.backgroundColor = [UIColor grayColor];
    }else {
        self.headerLabel.text = @"下拉可以刷新";
        self.headerLabel.backgroundColor = [UIColor redColor];
    }
}

#pragma mark - 处理footer
- (void)dealFooter {
    
    // 还没任何内容的时候，不需要判断
    if (self.tableView.contentSize.height == 0) return;
    
    // 如果正在刷新，直接返回
    //if (self.isFooterRefreshing) return;
    
    // 当scrollView的偏移量y值 >= offsetY时，代表footer 已经完全出现
    CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.by_height;
    
    // footer 已经完全出现 ， 并且是往下拖拽
    if (self.tableView.contentOffset.y >= offsetY && self.tableView.contentOffset.y > -(self.tableView.contentInset.top)) {
        [self footerBeginRefreshing];
    }
}

#pragma mark - header
- (void)headerBeginRefreshing {
    
    if (self.isHeaderRefreshing) return;
    
    // 进入下拉刷新状态
    self.headerLabel.text = @"正在刷新数据...";
    self.headerLabel.backgroundColor = [UIColor blueColor];
    self.headerRefreshing = YES;
    
    // 增加内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top += self.header.by_height;
        self.tableView.contentInset = insets;
        
        // 修改偏移量
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, -insets.top);
    }];
    
    // 发送请求给服务器，下拉刷新数据
    NSLog(@"发送请求给服务器，下拉刷新数据");
    
    [self loadNewTopics];
    
}

- (void)headerEndRefreshing {
    // 结束刷新
    self.headerRefreshing = NO;
    
    // 减小内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top -= self.header.by_height;
        self.tableView.contentInset = insets;
    }];
}

#pragma mark - footer
- (void)footerBeginRefreshing {
    
    // 如何正在上拉刷新，直接返回
    if (self.isFooterRefreshing) return;
    
    // 进入上拉刷新状态
    self.footerRefreshing = YES;
    self.footerLabel.text = @"正在加载更多数据...";
    self.footerLabel.backgroundColor = [UIColor blueColor];
    
    // 发送请求给服务器
    NSLog(@"发送请求给服务器 - 加载更多数据");
    
    [self loadMoreTopics];
}

- (void)footerEndRefreshing {
    // 结束刷新
    self.footerRefreshing = NO;
    self.footerLabel.text = @"上拉可以加载更多";
    self.footerLabel.backgroundColor = [UIColor redColor];
}


#pragma mark - 加载数据
/*
    下拉刷新
 */
- (void)loadNewTopics {
    
    // 取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @"41";
    
    [self.manager GET:BYCommonUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 获取最后一页的 时间
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 获取模型数组
        self.topics = [BYTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新
        [self.tableView reloadData];
        
        // 结束刷新
        [self headerEndRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [self headerEndRefreshing];
        
        // 任务被取消 （我们主动取消的 -99）
        if (error.code != -999) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试!"];
        }
        
    }];
}

/*
    上拉数据, 加载更多数据
 */
- (void)loadMoreTopics {
    
    // 取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @"41";
    parameters[@"maxtime"] = self.maxtime;
    
    [self.manager GET:BYCommonUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 获取最后一页的 时间
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 获取模型数组
        [self.topics addObjectsFromArray:[BYTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        
        // 刷新
        [self.tableView reloadData];
        
        // 结束刷新
        [self footerEndRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [self footerEndRefreshing];
        
        // 任务被取消 （我们主动取消的 -99）
        if (error.code != -999) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试!"];
        }
    }];
}



@end
