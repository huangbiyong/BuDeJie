//
//  BYTopicVoiceView.m
//  BuDeJie
//
//  Created by biyong Huang on 2017/12/16.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYTopicVoiceView.h"
#import "BYTopic.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "BYSeeBigPictureViewController.h"

@interface BYTopicVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;

@end

@implementation BYTopicVoiceView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}

/*
 查看大图
 */
- (void)seeBigPicture {
    BYSeeBigPictureViewController *seeBigVc = [[BYSeeBigPictureViewController alloc] init];
    seeBigVc.topic = _topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:seeBigVc animated:YES completion:nil];
}

- (void)setTopic:(BYTopic *)topic
{
    _topic = topic;
    
    // 占位图片
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
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.voicetime / 60, topic.voicetime % 60];
}



@end
