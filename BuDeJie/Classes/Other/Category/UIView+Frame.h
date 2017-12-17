//
//  UIView+Frame.h
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/7.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property CGFloat by_width;
@property CGFloat by_height;
@property CGFloat by_x;
@property CGFloat by_y;
@property CGFloat by_centerX;
@property CGFloat by_centerY;


+ (instancetype)by_viewFromXib;

@end
