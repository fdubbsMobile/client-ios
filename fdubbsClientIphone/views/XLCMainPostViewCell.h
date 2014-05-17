//
//  XLCPostDetailViewCell.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-26.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCPostDetailViewCell.h"

@interface XLCMainPostViewCell : XLCPostDetailViewCell

@property (strong, nonatomic) IBOutlet UILabel *ownerLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *ownerButton;
@property (strong, nonatomic) IBOutlet UILabel *boardLabel;
@property (strong, nonatomic) IBOutlet UIButton *boardButton;


@property (strong, nonatomic) IBOutlet UIView *postSubMetaView;


@property (strong, nonatomic) IBOutlet UIView *postMetadataView;

@property (nonatomic, strong) IBOutlet UIView *postContentView;

//@property (strong, nonatomic) UIView *qouteView;

//@property (strong, nonatomic) UIImageView *qouteBgView;


@end
