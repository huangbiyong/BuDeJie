//
//  UIView+Frame.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/7.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

+ (instancetype)by_viewFromXib {
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (void)setBy_width:(CGFloat)by_width {
    CGRect rect = self.frame;
    rect.size.width = by_width;
    self.frame = rect;
}

- (CGFloat)by_width {
    return self.frame.size.width;
}

- (void)setBy_height:(CGFloat)by_height {
    CGRect rect = self.frame;
    rect.size.height = by_height;
    self.frame = rect;
}

- (CGFloat)by_height {
    return self.frame.size.height;
}

- (void)setBy_x:(CGFloat)by_x {
    CGRect rect = self.frame;
    rect.origin.x = by_x;
    self.frame = rect;
}

- (CGFloat)by_x {
    return self.frame.origin.x;
}

- (void)setBy_y:(CGFloat)by_y {
    CGRect rect = self.frame;
    rect.origin.y = by_y;
    self.frame = rect;
}

- (CGFloat)by_y {
    return self.frame.origin.y;
}

- (void)setBy_centerX:(CGFloat)by_centerX {
    CGPoint center = self.center;
    center.x = by_centerX;
    self.center = center;
}

- (CGFloat)by_centerX {
    return self.center.x;
}

- (void)setBy_centerY:(CGFloat)by_centerY {
    CGPoint center = self.center;
    center.y = by_centerY;
    self.center = center;
}

- (CGFloat)by_centerY {
    return self.center.y;
}



@end













