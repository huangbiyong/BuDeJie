//
//  UIImage+Image.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/6.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

+(UIImage*)imageOriginalWithNamed:(NSString*)imageName {
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return image;
}

+ (instancetype)by_circleImageWithNamed:(NSString*)imageName {
    return [[self imageNamed:imageName] by_circleImage];
}

-(instancetype)by_circleImage {
    
    // 1. 开启图形上下文
    // scale 比例因素：当前点与像素比例，   0 为自动适配
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    // 2. 描述裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    // 3. 设置裁剪区域
    [path addClip];
    
    // 4. 画图片
    [self drawAtPoint:CGPointZero];
    
    // 5. 取出图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6. 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)by_circleImageNamed:(NSString *)name
{
    return [[self imageNamed:name] by_circleImage];
}

@end
