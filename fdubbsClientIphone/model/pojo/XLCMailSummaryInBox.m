//
//  XLCMailSummaryInBox.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCMailSummaryInBox.h"
#import "XLCMailSummary.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCMailSummaryInBox


+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCMailSummaryInBox class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"start_mail_num" : @"startMailNum",
                                                        @"total_count" : @"totalCount",
                                                        @"mail_count" : @"mailCount"
                                                        }];
    
    RKRelationshipMapping* mailSummaryRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"mail_summary_list"
                                                                                               toKeyPath:@"mailSummaryList"
                                                                                             withMapping:[XLCMailSummary objectMapping]];
    
    [objectMapping addPropertyMapping:mailSummaryRSMapping];
    
    return objectMapping;
}

@end
