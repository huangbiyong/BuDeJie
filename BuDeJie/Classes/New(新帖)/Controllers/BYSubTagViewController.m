//
//  BYSubTagViewController.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/8.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYSubTagViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BYSubTagItem.h"
#import <MJExtension/MJExtension.h>

#import "BYSubTagCell.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString * const ID = @"cell";

@interface BYSubTagViewController ()

@property (nonatomic, strong) NSArray *subTags;

@property (nonatomic, weak) AFHTTPSessionManager *mgr;

@end

@implementation BYSubTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSubTagData];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BYSubTagCell" bundle:nil] forCellReuseIdentifier:ID];

    self.title = @"推荐标签";
    
    // 设置分割线，全屏占领：  清空tableView分割线内边距   清空cell的默认的约束边缘
    // 方案一：自定义分割线
    // 方案二：系统属性（iOS8才支持）
    // self.tableView.separatorInset = UIEdgeInsetsZero;
    
    // 方案三：万能方法（重写cell 的setFrame）
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = BYColor(220, 220, 220);
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
}

// 可能网络慢，界面退出时，需要取消请求，否则浪费资源
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 销毁请求指示
    [SVProgressHUD dismiss];
    
    // 取消请求
    [_mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
}

#pragma mark - 请求数据
- (void)loadSubTagData {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    _mgr = mgr;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";
    
    [mgr GET:BYCommonUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        //NSLog(@"%@",responseObject);
        
        //[responseObject writeToFile:@"/Users/zhangjian/Desktop/ios 大神之路/oc项目/数据/subTag.plist" atomically:YES];
        
        _subTags = [BYSubTagItem mj_objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return _subTags.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _subTags.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYSubTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    BYSubTagItem *item = _subTags[indexPath.row];
    cell.item = item;
    
    return cell;
}

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
