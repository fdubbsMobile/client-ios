//
//  XLCPostReplies.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-5-24.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLCPostReplies : NSObject

@property (strong, nonatomic) NSString *boardId;
@property (strong, nonatomic) NSString *mainPostId;
@property (strong, nonatomic) NSString *lastReplyId;
@property BOOL hasMore;

@property (strong, nonatomic) NSArray *replies;

@end
