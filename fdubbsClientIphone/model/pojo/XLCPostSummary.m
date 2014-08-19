//
//  XLCPostSummary.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-13.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCPostSummary.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCPostSummary

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCPostSummary class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                             @"count" : @"count",
                                                             @"mark_sign" : @"markSign",
                                                             @"is_sticky" : @"sticky",
                                                             @"is_no_reply" : @"nonReply"
                                                             }];
    
    
    RKRelationshipMapping* postMetaRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"post_meta_data"
                                                                                           toKeyPath:@"metaData"
                                                                                         withMapping:[XLCPostMetaData objectMapping]];
    [objectMapping addPropertyMapping:postMetaRSMapping];
    
    return objectMapping;
}

@end
