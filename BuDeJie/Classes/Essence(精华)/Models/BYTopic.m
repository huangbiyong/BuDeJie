//
//  BYTopic.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/14.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYTopic.h"

@implementation BYTopic

- (CGFloat)cellHeight {
    
    // 如果计算过，直接返回
    if (_cellHeight) return _cellHeight;
    
    // 文字的Y
    _cellHeight += 55;
    
    // 文字的高度
    CGSize constrainedToSize = CGSizeMake(BYScreenW - BYMargin * 2, MAXFLOAT);
    _cellHeight += [self.text boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]} context:nil].size.height + BYMargin;
    
    // 中间内容
    if (self.type != BYTopicTypeWord) {  // 中间有内容（图片、声音、视频）
        CGFloat middleW = constrainedToSize.width;
        CGFloat middleH = middleW * self.height / self.width;
        if (middleH >= BYScreenH) { // 显示的图片高度超过一个屏幕，就是超长图片
            middleH = 200;
            self.bigPicture = YES;
        }
        
        CGFloat middleY = _cellHeight;
        CGFloat middleX = BYMargin;
        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
        _cellHeight += middleH + BYMargin;
    }
    

    
    // 最热评论
    if (self.top_cmt.count) { //有最热评论
        // 标题
        _cellHeight += 21;
        
        // 内容
        NSDictionary *cmt = self.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) { // 语音评论
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        NSString *cmtText = [NSString stringWithFormat:@"%@ : %@",username,content];
        
        _cellHeight += [cmtText boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]} context:nil].size.height + BYMargin;
    }
    
    // 底部工具条
    _cellHeight += 35;
    
    // 底部分割线                           
    _cellHeight += BYMargin;
    
    return _cellHeight;
}

@end







