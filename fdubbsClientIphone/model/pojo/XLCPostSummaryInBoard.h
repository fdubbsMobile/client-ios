//
//  XLCPostSummaryInBoard.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-11.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCBoardMetaData.h"
#import "XLCPostSummary.h"
#import "XLCObjectMappingProtocol.h"

@interface XLCPostSummaryInBoard : NSObject <XLCObjectMappingProtocol>

@property (strong, nonatomic) XLCBoardMetaData *boardMetaData;
@property (strong, nonatomic) NSArray *postSummaryList;

@property NSUInteger startPostNum;
@property NSUInteger postCount;

@end
