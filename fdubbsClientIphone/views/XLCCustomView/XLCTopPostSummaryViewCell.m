//
//  XLCPostSummaryViewCell.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCTopPostSummaryViewCell.h"
#import "UIImage+Overlay.h"

@interface XLCTopPostSummaryViewCell ()



@end

@implementation XLCTopPostSummaryViewCell

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
    
    UIImage *replyButtonBgImage = [[UIImage imageNamed:@"reply"]
                                   imageWithOverlayColor:[UIColor colorWithRed:91/255.0 green:192/255.0 blue:222/255.0 alpha:1]];
    
    [self.replyCountButton setTitle:[NSString stringWithFormat:@"%@", postSummary.count] forState:UIControlStateNormal];
    [self.replyCountButton setBackgroundImage:replyButtonBgImage forState:UIControlStateNormal];
    //[self.replyCountButton primaryStyle];
    
    
    [self layoutOwnerLabel:[NSString stringWithFormat:@"%@", postSummary.metaData.owner]];
    [self layoutOwnerButton];
    
    [self layoutBoardLabel:[NSString stringWithFormat:@"%@版", postSummary.metaData.board]];
    
}



- (UIImage *)colorImage:(UIImage *)origImage withColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(origImage.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, (CGRect){ {0,0}, origImage.size} );
    
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, origImage.size.height);
    CGContextConcatCTM(context, flipVertical);
    CGContextDrawImage(context, (CGRect){ {0,0}, origImage.size }, [origImage CGImage]);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
    self.ownerButton.hidden = YES;
    return;
    
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

