//
//  BYLoginRegisterView.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/8.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYLoginRegisterView.h"

@interface BYLoginRegisterView()

@property (weak, nonatomic) IBOutlet UIButton *loginRegisterButton;



@end

@implementation BYLoginRegisterView

+ (instancetype)loginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

+ (instancetype)registerView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 获取当前的背景图片
    UIImage *image = _loginRegisterButton.currentBackgroundImage;
    
    // 表示只拉升中心点
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    [_loginRegisterButton setBackgroundImage:image forState:UIControlStateNormal];
    
}

@end
