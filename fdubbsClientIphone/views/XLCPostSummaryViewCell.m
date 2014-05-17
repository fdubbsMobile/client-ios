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

- (void)setUpWithPostSummary:(XLCPostSummary *)postSummary AtRow:(NSUInteger)rowNum
{
    
    self.rowIndex = rowNum;
    
    self.titleLabel.text = postSummary.metaData.title;
    [self.replyCountButton setTitle:[NSString stringWithFormat:@"%@", postSummary.count] forState:UIControlStateNormal];
    [self.replyCountButton primaryStyle];
    
    [self layoutOwnerLabel:[NSString stringWithFormat:@"%@", postSummary.metaData.owner]];
    [self layoutOwnerButton];
    
    [self layoutBoardLabel:[NSString stringWithFormat:@"%@版", postSummary.metaData.board]];
    [self layoutBoardButton];
    
}

- (void)layoutBoardLabel:(NSString *)board
{
    self.boardLabel.numberOfLines = 0;
    CGRect frame = self.boardLabel.frame;
    
    CGSize textSize = CGSizeMake(MAXFLOAT, frame.size.height);
    CGRect textRect = [board boundingRectWithSize:textSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:self.boardLabel.font}
                                          context:nil];
    
    frame.size.width = textRect.size.width;
    self.boardLabel.frame = frame;
    self.boardLabel.text = board;
}

- (void)layoutBoardButton
{
    [self.boardButton infoStyle];
    CGRect frame = self.boardButton.frame;
    frame.origin.x = self.boardLabel.frame.origin.x + self.boardLabel.frame.size.width + 5;
    
    self.boardButton.frame = frame;
}

- (void)layoutOwnerLabel:(NSString *)owner
{
    self.ownerLabel.numberOfLines = 0;
    CGRect frame = self.ownerLabel.frame;
    
    CGSize textSize = CGSizeMake(MAXFLOAT, frame.size.height);
    CGRect textRect = [owner boundingRectWithSize:textSize
                       options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{NSFontAttributeName:self.ownerLabel.font}
                       context:nil];
    
    frame.size.width = textRect.size.width;
    self.ownerLabel.frame = frame;
    self.ownerLabel.text = owner;
    
}

- (void)layoutOwnerButton
{
    [self.ownerButton successStyle];
    CGRect frame = self.ownerButton.frame;
    frame.origin.x = self.ownerLabel.frame.origin.x + self.ownerLabel.frame.size.width + 5;
    
    self.ownerButton.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

