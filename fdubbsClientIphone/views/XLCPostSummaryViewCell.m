//
//  XLCPostSummaryViewCell.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCPostSummaryViewCell.h"

@interface XLCPostSummaryViewCell ()



@end

@implementation XLCPostSummaryViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *_imgView_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 2, 320, 2)];
        [_imgView_line setImage:[UIImage imageNamed:@"list_divider_line"]];
        [self.contentView addSubview:_imgView_line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

