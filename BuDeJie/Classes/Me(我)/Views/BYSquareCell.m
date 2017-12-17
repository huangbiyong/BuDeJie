//
//  BYSquareCell.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/9.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYSquareCell.h"
#import "BYSquareItem.h"
#import <UIImageView+WebCache.h>

@interface BYSquareCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation BYSquareCell

- (void)setItem:(BYSquareItem *)item {
    _item = item;
    
    _nameLabel.text = item.name;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.icon]];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
