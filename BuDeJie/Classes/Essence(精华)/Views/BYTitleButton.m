//
//  BYTitleButton.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/12.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYTitleButton.h"

@implementation BYTitleButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}


// 没有高亮状态
- (BOOL)isHighlighted {
    return NO;
}

@end
