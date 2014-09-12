//
//  XLCPostReplies.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-5-24.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCObjectMappingProtocol.h"


@interface XLCPostReplies : NSObject <XLCObjectMappingProtocol>

@property  NSString *boardId;
@property  NSString *mainPostId;
@property  NSString *lastReplyId;
@property BOOL hasMore;

@property  NSArray *replies;

@end
