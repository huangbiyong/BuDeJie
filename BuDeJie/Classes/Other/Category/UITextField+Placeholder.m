//
//  UITextField+Placeholder.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/9.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "UITextField+Placeholder.h"
#import <objc/message.h>

static NSString * const placeholderColorKey = @"placeholderColor";

@implementation UITextField (Placeholder)

+ (void)load {
    
    /*
        由于先设置 placeholderColor 再设置 placeholder 会出现bug，不会渲染，
        所以使用交换方法，当设置placeholder 时， 重新设置 placeholderColor
     */
    
    
    // 交换方法
    Method setPlaceholder = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setBY_Placeholder = class_getInstanceMethod(self, @selector(setBY_Placeholder:));
    
    method_exchangeImplementations(setPlaceholder, setBY_Placeholder);
    
}


- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    // 添加成员变量
    objc_setAssociatedObject(self, &placeholderColorKey, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = placeholderColor;
//
//    self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.placeholder attributes:attrs];
//
    
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, &placeholderColorKey);
}


// 设置占位文字
// 设置占位文字颜色
- (void)setBY_Placeholder:(NSString *)placeholder {
    // 实际调用 [self setPlaceholder:placeholder]
    [self setBY_Placeholder:placeholder];
    
    self.placeholderColor = self.placeholderColor;
}


@end


