//
//  BYTopicVideoView.m
//  BuDeJie
//
//  Created by biyong Huang on 2017/12/16.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYTopicVideoView.h"
#import "BYTopic.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>

@interface BYTopicVideoView()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;

@end


@implementation BYTopicVideoView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
}


- (void)setTopic:(BYTopic *)topic
{
    _topic = topic;
    
    // 设置图片
    self.placeholderView.hidden = NO;
    [self.imgView by_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        
        self.placeholderView.hidden = YES;
    }];
    
    // 播放数量
    if (topic.playcount >= 10000) {
        self.playcountLabel.text = [NSString stringWithFormat:@"%.1f万播放", topic.playcount / 10000.0];
    } else {
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    }
    // %04d : 占据4位，多余的空位用0填补
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.videotime / 60, topic.videotime % 60];
}

@end



