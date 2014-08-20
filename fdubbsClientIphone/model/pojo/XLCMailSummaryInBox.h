//
//  XLCMailSummaryInBox.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCObjectMappingProtocol.h"


@interface XLCMailSummaryInBox : NSObject <XLCObjectMappingProtocol>

@property NSUInteger startMailNum;
@property NSUInteger totalCount;
@property NSUInteger mailCount;

@property (strong, nonatomic) NSArray *mailSummaryList;

@end
