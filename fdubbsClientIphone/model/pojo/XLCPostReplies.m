//
//  XLCPostReplies.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-5-24.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCPostReplies.h"
#import "XLCPostDetail.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCPostReplies

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCPostReplies class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                             @"board_id" : @"boardId",
                                                             @"main_post_id" : @"mainPostId",
                                                             @"last_reply_id" : @"lastReplyId",
                                                             @"has_more" : @"hasMore"
                                                             }];
    
    RKRelationshipMapping* postReplyRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"post_reply_list"
                                                                                            toKeyPath:@"replies"
                                                                                          withMapping:[XLCPostDetail objectMapping]];
    [objectMapping addPropertyMapping:postReplyRSMapping];
    
    return objectMapping;
}

@end
