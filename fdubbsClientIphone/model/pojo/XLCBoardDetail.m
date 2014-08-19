//
//  XLCBoardDetail.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-6-11.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCBoardDetail.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCBoardDetail

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCBoardDetail class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                             @"category" : @"category",
                                                             @"is_directory" : @"isDirectory",
                                                             @"has_unread_post" : @"hasUnreadPost"
                                                             }];
    RKRelationshipMapping* boardMetaDataRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"board_meta_data"
                                                                                                toKeyPath:@"metaData"
                                                                                              withMapping:[XLCBoardMetaData objectMapping]];
    
    [objectMapping addPropertyMapping:boardMetaDataRSMapping];
    
    return objectMapping;
}

@end
