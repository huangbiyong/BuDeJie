//
//  BYADItem.h
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/7.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYADItem : NSObject

@property (nonatomic, strong) NSString *w_picurl; // 广告图片地址
@property (nonatomic, strong) NSString *ori_curl; // 广告链接

@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;

@end
