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


// 自绘分割线
/*
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(c, [[UIColor redColor] CGColor]);
    CGContextSetLineWidth(c, 1);
    
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0.0f, rect.size.height-1/2);
    CGContextAddLineToPoint(c, rect.size.width, rect.size.height-1/2);
    CGContextStrokePath(c);
}
 */
/*
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 10));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 10));
}
*/
/*
- (void)drawRect:(CGRect)rect
{
    NSLog(@"redraw");
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
}
*/
@end

