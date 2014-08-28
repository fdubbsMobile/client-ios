//
//  XLCMailSummaryViewCell.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-8-28.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLCMailSummaryViewCell : UITableViewCell

@property NSUInteger index;

@property (strong, nonatomic) IBOutlet UILabel *senderLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
