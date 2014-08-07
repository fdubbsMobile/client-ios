//
//  XLCBoardViewCell.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-7.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLCBoardViewCell : UITableViewCell

@property NSUInteger index;
@property (strong, nonatomic) IBOutlet UILabel *description;

@end
