//
//  BYFileTool.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/11.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYFileTool.h"

@implementation BYFileTool


#pragma mark - 计算文件夹下的子文件大小
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger totalSize))completion {
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 判断是否存在，并判断是否是文件夹
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    // 如果文件不存在 或 不是文件夹  抛出异常
    if (!isExist || !isDirectory) {
        NSException *excp = [NSException exceptionWithName:@"PathError" reason:@"文件不存在 或 不是文件夹" userInfo:nil
                             ];
        [excp raise];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 获取子文件 (包含二级，三级路径都会拿到)
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
        
        NSInteger totalSize = 0;
        
        for (NSString *subPath in subPaths) {
            // 拼接文件全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            // 判断隐藏文件
            if ([filePath containsString:@".DS"]) {
                continue;
            }
            
            // 判断是否存在，并判断是否是文件夹
            BOOL isDirectory;
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            
            if (!isExist || isDirectory) {
                continue;
            }
            
            NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
            NSInteger fileSize = [attr fileSize];
            totalSize += fileSize;
        }
        
        // 回调
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(totalSize);
            }
        });
        
    });

    //return totalSize;
}


#pragma mark - 删除文件夹下面的子文件
+ (void)removeFileFromDirectory:(NSString*)directoryPath {
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 判断是否存在，并判断是否是文件夹
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    // 如果文件不存在 或 不是文件夹  抛出异常
    if (!isExist || !isDirectory) {
        NSException *excp = [NSException exceptionWithName:@"PathError" reason:@"文件不存在 或 不是文件夹" userInfo:nil
                             ];
        [excp raise];
    }
    
    // 获取cache 文件下的所有文件，不包含子路径的子路径（即二级，三级文件）,
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subPaths) {
        // 拼接全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        
        // 删除文件
        [mgr removeItemAtPath:filePath error:nil];
    }
    
}


@end
