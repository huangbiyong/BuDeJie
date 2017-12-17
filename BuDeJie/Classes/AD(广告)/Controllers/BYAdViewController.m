//
//  BYAdViewController.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/7.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYAdViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BYADItem.h"
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>

#import "BYTabBarController.h"


#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"


@interface BYAdViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;


@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) UIImageView *adImgView;
@property (nonatomic, strong) BYADItem *item;



@end

@implementation BYAdViewController

- (IBAction)jumpClick:(id)sender {
    BYTabBarController *tabBarVc = [[BYTabBarController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
    [_timer invalidate];
}


- (UIImageView *)adImgView {
    if (_adImgView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [self.adView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
        
        imageView.userInteractionEnabled = YES;
        
        
        _adImgView = imageView;
    }
    
    return _adImgView;
}

// 点击广告界面调用
- (void)tap
{
    // 跳转到界面 => safari
    NSURL *url = [NSURL URLWithString:_item.ori_curl];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 设置启动页图片
    [self setupLaunchImages];
    
    // 加载广告数据
    [self loadAdData];
    
    // 创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
    
}

#pragma mark - 定时器
- (void)timerChange {
    
    static NSInteger i = 3;
    if (i == 0) {
        [self jumpClick:nil];
    }
    i--;
    
    [_jumpBtn setTitle:[NSString stringWithFormat:@"跳转 (%ld)",i] forState:UIControlStateNormal];
}

#pragma mark - 请求广告数据
- (void)loadAdData {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = code2;
    
    [mgr GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //NSLog(@"%@",responseObject);
        
        NSArray *ads = responseObject[@"ad"];
        if (ads.count > 0) {
            
            NSDictionary *adDict = [ads lastObject];
            
            // 字典转模型
            _item = [BYADItem mj_objectWithKeyValues:adDict];
            
            // 创建展示图片
            CGFloat height = BYScreenW / _item.w * _item.h;
            
            self.adImgView.frame = CGRectMake(0, 0, BYScreenW, height);
            
            // 加载图片
            [self.adImgView sd_setImageWithURL:[NSURL URLWithString:_item.w_picurl]];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark - 设置启动图片
- (void)setupLaunchImages {
    
    if (iphone6P) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    } else if (iphone6) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    } else if (iphone5) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-568h"];
    } else if (iphone4) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-700"];
    } else {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    }
}














@end
