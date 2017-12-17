//
//  BYMeViewController.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/6.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYMeViewController.h"
#import "BYSettingViewController.h"
#import "BYSquareCell.h"
#import <AFNetworking/AFNetworking.h>
#import "BYSquareItem.h"
#import <MJExtension/MJExtension.h>

//#import <SafariServices/SafariServices.h>

#import "BYWebViewController.h"

static NSString * const ID = @"cell";

static NSInteger cols = 4;
static CGFloat margin = 1;
#define itemWH  (BYScreenW - (cols - 1) * margin) / cols


@interface BYMeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *squareItems;
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation BYMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setupNavBar];
    
    // 设置tableView底部试图
    [self setupFooterView];
    
    // 请求数据
    [self loadData];
    
    // 设置间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    
    // 自增，自减
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(BYNavMaxY - 25, 0, BYTabBarH, 0);
   
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

#pragma mark - 请求数据
- (void)loadData{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    
    [mgr GET:BYCommonUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        //[responseObject writeToFile:@"/Users/zhangjian/Desktop/ios 大神之路/oc项目/数据/square.plist" atomically:YES];
        //NSLog(@"%@",responseObject);
        
        NSArray *square_list = responseObject[@"square_list"];
        
        _squareItems = [BYSquareItem mj_objectArrayWithKeyValuesArray:square_list];
        
        // 处理数据， 填补空缺
        [self resolveData];
        
        // 计算有多少行
        NSInteger count = _squareItems.count;
        NSInteger rows = (count - 1) / cols + 1;
        
        // 计算 collectionView 的高度
        self.collectionView.by_height = rows * itemWH + (rows - 1) * margin;
        
        // 设置tableView滚动范围： 自己计算          (重新设置，才能自己计算 static)
        self.tableView.tableFooterView = self.collectionView;
        
        [_collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 处理数据，填补空缺
- (void)resolveData {
    NSInteger count = _squareItems.count;
    NSInteger rest  = count % cols;
    if (rest) {
        rest = cols - rest;
        for (NSInteger i = 0; i < rest; i++) {
            BYSquareItem *item = [[BYSquareItem alloc]init];
            [self.squareItems addObject:item];
        }
    }
}

#pragma mark - 设置tableView底部试图
- (void)setupFooterView {
    
    /*
        1. 初始化流水布局
        2. cell 必须要注册
        3. cell 必须自定义
     */
    
    // 设置流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    
    // 创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    collectionView.scrollEnabled = NO;
    self.tableView.tableFooterView = collectionView;
    
    _collectionView = collectionView;
    
    
    // 注册cell
    collectionView.dataSource = self;
    _collectionView.delegate = self;

    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BYSquareCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma mark - 设置导航条
- (void)setupNavBar {
    
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(nightClick:)];
    
    UIBarButtonItem *setttingItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(settingClick)];
    
    self.navigationItem.rightBarButtonItems = @[setttingItem,nightItem];
    
    self.navigationItem.title = @"我的";
}

- (void)settingClick {
    
    // 跳转到设置
    BYSettingViewController *settingVc = [[BYSettingViewController alloc]init];
    settingVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)nightClick:(UIButton*)btn {
    btn.selected = ! btn.selected;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _squareItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //BYLog(@"%@",NSStringFromCGRect(collectionView.frame));
    
    BYSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.item = _squareItems[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    BYSquareItem *item = _squareItems[indexPath.item];
    
    if (![item.url containsString:@"http"]) {
        return;
    }
    // ios 9.0 才有效
    //NSURL *url = [NSURL URLWithString:item.url];
    //SFSafariViewController *safariVc = [[SFSafariViewController alloc]initWithURL:url];
    //[self presentViewController:safariVc animated:YES completion:nil];
    
    BYWebViewController *webVc = [[BYWebViewController alloc]init];
    webVc.url = [NSURL URLWithString:item.url];
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
