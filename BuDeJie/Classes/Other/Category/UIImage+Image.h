//
//  UIImage+Image.h
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/6.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

+ (UIImage*)imageOriginalWithNamed:(NSString*)imageName;

+ (instancetype)by_circleImageWithNamed:(NSString*)imageName;

- (instancetype)by_circleImage;

+ (instancetype)by_circleImageNamed:(NSString *)name;

@end
