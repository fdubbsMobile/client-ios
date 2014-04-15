//
//  XLCPostSummary.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-13.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>


@class XLCPostMetaData;


@interface XLCPostSummary : NSObject

@property (strong, nonatomic) XLCPostMetaData *metaData;

@property (strong, nonatomic) NSString *count;
@property (strong, nonatomic) NSString *markSign;

@property BOOL sticky;
@property BOOL nonReply;

@end