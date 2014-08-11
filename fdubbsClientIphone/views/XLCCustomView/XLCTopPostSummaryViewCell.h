//
//  XLCPostSummaryViewCell.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCPostSummary.h"

@interface XLCTopPostSummaryViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ownerLabel;
@property (strong, nonatomic) IBOutlet UILabel *boardLabel;
@property (strong, nonatomic) IBOutlet UIButton *replyCountButton;
@property (strong, nonatomic) IBOutlet UIButton *ownerButton;
@property (weak, nonatomic) IBOutlet UIImageView *replyCountImage;

@property NSInteger rowIndex;

- (void)setUpWithPostSummary:(XLCPostSummary *)postSummary AtRow:(NSUInteger)rowNum;
@end
