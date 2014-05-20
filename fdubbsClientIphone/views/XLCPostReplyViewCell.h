//
//  XLCPostReplyViewCell.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-18.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCPostDetailViewCell.h"

@interface XLCPostReplyViewCell : XLCPostDetailViewCell
@property (strong, nonatomic) IBOutlet UIView *postMetadataView;
@property (strong, nonatomic) IBOutlet UIView *postContentView;
@property (strong, nonatomic) IBOutlet UILabel *ownerLabel;
@property (strong, nonatomic) IBOutlet UIButton *ownerButton;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;


@property (strong, nonatomic) UIView *postQouteView;



@end
