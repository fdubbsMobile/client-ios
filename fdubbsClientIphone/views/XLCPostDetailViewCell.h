//
//  XLCPostDetailViewCell.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-18.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XLCPostDetail.h"


@interface XLCPostDetailViewCell : UITableViewCell

- (void)setupWithInitialization;
- (void)setupWithPostDetail:(XLCPostDetail *)postDetail AtIndexPath:(NSIndexPath *)index;
- (CGFloat)getHeight;
- (BOOL) isForIndexPath:(NSIndexPath *)index;

@end
