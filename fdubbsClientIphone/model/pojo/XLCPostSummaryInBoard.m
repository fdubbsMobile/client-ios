//
//  XLCPostSummaryInBoard.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-11.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCPostSummaryInBoard.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCPostSummaryInBoard

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCPostSummaryInBoard class]];
    
    
    RKRelationshipMapping* boardMetaDataRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"board_meta_data"
                                                                                                 toKeyPath:@"boardMetaData"
                                                                                               withMapping:[XLCBoardMetaData objectMapping]];
    
    
    RKRelationshipMapping* postSummaryListRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"post_summary_list"
                                                                                                  toKeyPath:@"postSummaryList"
                                                                                                withMapping:[XLCPostSummary objectMapping]];
    
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                                    @"start_post_num" : @"startPostNum",
                                                                    @"post_count" : @"postCount"
                                                                    }];
    
    [objectMapping addPropertyMapping:boardMetaDataRSMapping];
    [objectMapping addPropertyMapping:postSummaryListRSMapping];
    
    return objectMapping;
}

@end
