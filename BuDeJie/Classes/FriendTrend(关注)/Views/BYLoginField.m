//
//  BYLoginField.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/9.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYLoginField.h"
#import "UITextField+Placeholder.h"

@implementation BYLoginField

/*
     1.文本框光标变成白色
     2.文本框开始编辑的时候，占位文字颜色变为白色
 
     所以需要自己封装一个输入框(UITextField)
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置光标的颜色为白色
    self.tintColor = [UIColor whiteColor];
    
    // 监听文本框编辑：1. 代理  2.通知  3.target(推荐使用)
    
    // 开始编辑
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    
    // 结束编辑
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    // 设置默认placeHolder
    self.placeholderColor = [UIColor lightGrayColor];
}

- (void)textBegin {
    // 方法一
    /*
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
     
        self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.placeholder attributes:attrs];
     */
    
    // 方法二
    self.placeholderColor = [UIColor whiteColor];
}

- (void)textEnd {
    // 方法一
    /*
         NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
         attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
     
         self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.placeholder attributes:attrs];
     */
    
    
    // 方法二
    self.placeholderColor = [UIColor lightGrayColor];
}







@end
