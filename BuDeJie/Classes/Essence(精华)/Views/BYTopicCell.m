//
//  BYTopicCell.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/14.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYTopicCell.h"
#import "BYTopic.h"
#import "BYTopicVideoView.h"
#import "BYTopicVoiceView.h"
#import "BYTopicPictureView.h"

#import <UIImageView+WebCache.h>

@interface BYTopicCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;

/* 中间控件 */
/** 图片控件 */
@property (nonatomic, weak) BYTopicPictureView *pictureView;
/** 声音控件 */
@property (nonatomic, weak) BYTopicVoiceView *voiceView;
/** 视频控件 */
@property (nonatomic, weak) BYTopicVideoView *videoView;

@end


@implementation BYTopicCell

#pragma mark - 懒加载
- (BYTopicPictureView *)pictureView
{
    if (!_pictureView) {
        BYTopicPictureView *pictureView = [BYTopicPictureView by_viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (BYTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        BYTopicVoiceView *voiceView = [BYTopicVoiceView by_viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (BYTopicVideoView *)videoView
{
    if (!_videoView) {
        BYTopicVideoView *videoView = [BYTopicVideoView by_viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (void)setTopic:(BYTopic *)topic {
    _topic = topic;
    
    UIImage *placeholder = [UIImage by_circleImageWithNamed:@"defaultUserIcon"];
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (!image) return ;
        self.profileImageView.image = [image by_circleImage];
    }];
    
    self.nameLabel.text = topic.name;
    self.passtimeLabel.text = topic.passtime;
    self.text_label.text = topic.text;
    
    [self setupButtonTitle:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repostButton number:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton number:topic.comment placeholder:@"评论"];
    
    // 最热评论
    if (topic.top_cmt.count) { //有最热评论
        self.topCmtView.hidden = NO;
        
        NSDictionary *cmt = topic.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) { // 语音评论
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@",username,content];
        
    }else {  //没有最热评论
        self.topCmtView.hidden = YES;
    }
    
    // 中间的内容
    if (topic.type == BYTopicTypePicture) { // 图片
        self.pictureView.hidden = NO;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        self.pictureView.topic = topic;
    } else if (topic.type == BYTopicTypeVoice) { // 声音
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.videoView.hidden = YES;
    } else if (topic.type == BYTopicTypeVideo) { // 视频
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
    } else if (topic.type == BYTopicTypeWord) { // 段子
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.topic.type == BYTopicTypePicture) { // 图片
        self.pictureView.frame = self.topic.middleFrame;
    } else if (self.topic.type == BYTopicTypeVoice) { // 声音
        self.voiceView.frame = self.topic.middleFrame;
    } else if (self.topic.type == BYTopicTypeVideo) { // 视频
        self.videoView.frame = self.topic.middleFrame;
    }
}



- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString*)placeholder {
    
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万",number/10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%ld",number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= BYMargin;
    [super setFrame:frame];
}

@end
