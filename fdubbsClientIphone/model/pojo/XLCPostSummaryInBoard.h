//
//  XLCPostSummaryInBoard.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-11.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCBoardMetaData.h"

@interface XLCPostSummaryInBoard : NSObject

@property (strong, nonatomic) XLCBoardMetaData *boardMetaData;
@property (strong, nonatomic) NSArray *postSummaryList;

@property NSUInteger startPostNum;
@property NSUInteger postCount;

@end
