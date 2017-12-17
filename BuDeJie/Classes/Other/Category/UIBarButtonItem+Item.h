//
//  UIBarButtonItem+Item.h
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/7.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)

+ (UIBarButtonItem *)itemWithImage:(UIImage*)image highImage:(UIImage*)highImage target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithImage:(UIImage*)image selImage:(UIImage*)selImage target:(id)target action:(SEL)action;


+ (UIBarButtonItem *)backItemWithImage:(UIImage*)image highImage:(UIImage*)highImage target:(id)target action:(SEL)action title:(NSString*)title;

@end
