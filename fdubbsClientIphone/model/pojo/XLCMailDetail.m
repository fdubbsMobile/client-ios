//
//  XLCMailDetail.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCMailDetail.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCMailDetail

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCMailDetail class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"source" : @"source",
                                                        @"ip" : @"ip",
                                                        @"content" : @"content"
                                                        }];
    
    RKRelationshipMapping* mailMetaDataRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"mail_meta_data"
                                                                                              toKeyPath:@"mailMetaData"
                                                                                            withMapping:[XLCMailMetaData objectMapping]];
    
    [objectMapping addPropertyMapping:mailMetaDataRSMapping];
    
    return objectMapping;
}

@end
