//
//  BYFastLoginView.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/8.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYFastLoginView.h"

@implementation BYFastLoginView

+ (instancetype)fastLoginView {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
