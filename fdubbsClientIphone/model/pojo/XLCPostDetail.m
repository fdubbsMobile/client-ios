//
//  XLCPostDetail.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-4-22.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCPostDetail.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCPostDetail

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCPostDetail class]];
    
    RKRelationshipMapping* postMetaRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"post_meta_data"
                                                                                           toKeyPath:@"metaData"
                                                                                         withMapping:[XLCPostMetaData objectMapping]];
    
    RKRelationshipMapping* postBodyRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"body"
                                                                                           toKeyPath:@"body"
                                                                                         withMapping:[XLCContent objectMapping]];
    
    RKRelationshipMapping* postQouteRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"qoute"
                                                                                            toKeyPath:@"qoute"
                                                                                          withMapping:[XLCPostQoute objectMapping]];
    
    RKRelationshipMapping* postSignRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"sign"
                                                                                           toKeyPath:@"sign"
                                                                                         withMapping:[XLCContent objectMapping]];
    
    RKRelationshipMapping* postRepliesRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"replies"
                                                                                              toKeyPath:@"reply"
                                                                                            withMapping:[XLCPostReplies objectMapping]];
    [objectMapping addPropertyMapping:postMetaRSMapping];
    
    [objectMapping addPropertyMapping:postBodyRSMapping];
    [objectMapping addPropertyMapping:postQouteRSMapping];
    [objectMapping addPropertyMapping:postSignRSMapping];
    [objectMapping addPropertyMapping:postRepliesRSMapping];
    
    return objectMapping;
}

@end
