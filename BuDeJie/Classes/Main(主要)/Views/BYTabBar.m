//
//  BYTabBar.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/6.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYTabBar.h"
//#import "UIView+Frame.h"

@interface BYTabBar ()

@property (nonatomic, weak) UIButton *plusButton;

// 上次点击的按钮
@property (nonatomic, weak) UIControl *previousClicked;


@end

@implementation BYTabBar

- (UIButton *)plusButton {
    if (_plusButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [btn sizeToFit];
        [self addSubview:btn];
        
        _plusButton = btn;
    }
    return _plusButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 跳转tabBarButton 位置
    NSInteger count = self.items.count;
    CGFloat btnW = self.by_width / (count+1);
    CGFloat btnH = self.by_height;
    CGFloat x = 0;
    NSInteger i = 0;
    
    for (UIView *tabBarButton in self.subviews) {
        
        // UITabBarButton 是 addChildViewController 自动添加的item
        //NSLog(@"%@",tabBarButton);
        
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i == 2) {
                i += 1;
            }
            
            x = i * btnW;
            tabBarButton.frame = CGRectMake(x, 0, btnW, btnH);
            
            UIControl *tempTabBarButton = (UIControl *)tabBarButton;
            [tempTabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            // 因为 layoutSubviews 会 跳用多次，在使用过程中
            if (i == 0 && self.previousClicked == nil) {
                self.previousClicked = tempTabBarButton;
            }
            
            i ++;
        }
    }
    
    // 调整发布按钮的位置
    self.plusButton.center = CGPointMake(self.by_width * 0.5, self.by_height * 0.5);
}


- (void)tabBarButtonClick:(UIControl *)tabBarButton {
    
    // 监听重复点击同一个按钮
    if (tabBarButton == self.previousClicked) {
        //NSLog(@"%s",__func__);
        
        // 发出通知，告知外界tabBarButton被重复点击了
        [[NSNotificationCenter defaultCenter] postNotificationName:BYTabBarButtonDidRepeatClickNotification object:nil];
    }
    
    self.previousClicked = tabBarButton;
}



@end






























