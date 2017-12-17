//
//  UIImageView+Download.h
//  BuDeJie
//
//  Created by biyong Huang on 2017/12/17.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>
@interface UIImageView (Download)

- (void)by_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbnailImageURL placeholder:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

- (void)by_setHeader:(NSString *)headerUrl;

@end
