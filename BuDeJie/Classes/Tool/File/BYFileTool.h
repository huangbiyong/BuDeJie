//
//  BYFileTool.h
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/11.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYFileTool : NSObject

/**
 *  删除文件夹所有文件
 *
 *  @param directoryPath 文件夹路径
 */
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger totalSize))completion;

/**
 *  删除文件夹所有文件
 *
 *  @param directoryPath 文件夹路径
 */
+ (void)removeFileFromDirectory:(NSString*)directoryPath;

@end
