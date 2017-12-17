//
//  BYFastButton.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/8.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYFastButton.h"

@implementation BYFastButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置图片的位置
    self.imageView.by_y = 0;
    self.imageView.by_centerX = self.by_width * 0.5;
    
    // 设置标题位置
    self.titleLabel.by_y = self.by_height - self.titleLabel.by_height;
    
    // 计算文字高度， 设置label的宽度
    [self.titleLabel sizeToFit]; //自动计算文字宽度
    
    self.titleLabel.by_centerX = self.by_width * 0.5;
}

@end
