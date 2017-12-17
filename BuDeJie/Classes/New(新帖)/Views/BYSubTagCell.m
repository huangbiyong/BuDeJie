//
//  BYSubTagCell.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/8.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYSubTagCell.h"
#import "BYSubTagItem.h"
#import <UIImageView+WebCache.h>

@interface BYSubTagCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation BYSubTagCell

- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 1;
    
    [super setFrame:frame];
}


- (void)setItem:(BYSubTagItem *)item {
    _item = item;
    
    _nameLabel.text = item.theme_name;
    
    // 设置订阅人数
    NSString *numStr = [NSString stringWithFormat:@"%@人订阅",item.sub_number];
    NSInteger num = item.sub_number.integerValue;
    
    if (num >= 10000) {
        CGFloat numF = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f人订阅",numF];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    
    _numLabel.text = numStr;
    
    [self setupIconView];
}

- (void)setupIconView {
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_item.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        // 1. 开启图形上下文
        // scale 比例因素：当前点与像素比例，   0 为自动适配
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
        
        // 2. 描述裁剪区域
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        // 3. 设置裁剪区域
        [path addClip];
        
        // 4. 画图片
        [image drawAtPoint:CGPointZero];
        
        // 5. 取出图片
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 6. 关闭上下文
        UIGraphicsEndImageContext();
        
        _iconView.image = image;
        
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // iOS7，iOS8 会导致帧数变低，iOS9已经修复，  所以如果你的app支持ios7, ios8 可以使用上下文方式
    //_iconView.layer.cornerRadius = 58/2.0;
    //_iconView.layer.masksToBounds = YES;
    
    
    //分割线全屏占领 iOS8.0 ；  ios10以上基本不用设置
    //self.layoutMargins = UIEdgeInsetsZero;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
