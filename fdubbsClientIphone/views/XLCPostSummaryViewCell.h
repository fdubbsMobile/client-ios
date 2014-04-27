//
//  XLCPostSummaryViewCell.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLCPostSummaryViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *replyCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *onwerLabel;
@property (strong, nonatomic) IBOutlet UILabel *boardLabel;

@property NSInteger rowIndex;

@end
