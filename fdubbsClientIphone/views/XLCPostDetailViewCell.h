//
//  XLCPostDetailViewCell.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-26.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTCoreTextView.h"
#import "XLCPostDetail.h"

@interface XLCPostDetailViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *ownerLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIView *postMetadataView;

@property (nonatomic, strong) FTCoreTextView *postContentView;

//@property (strong, nonatomic) UIView *qouteView;

//@property (strong, nonatomic) UIImageView *qouteBgView;

- (void)setupWithInitialization;
- (void)setupWithPostDetail:(XLCPostDetail *)postDetail isReply:(BOOL)isReply;
- (CGFloat)getHeight;

@end
