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


@interface BYAllViewController ()

@end

@implementation BYAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (BYTopicType)type {
    return BYTopicTypeAll;
}



@end
