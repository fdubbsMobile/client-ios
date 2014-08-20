//
//  XLCMailSummary.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCMailSummary.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCMailSummary

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCMailSummary class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"is_new" : @"isNew",
                                                        @"mark_sign" : @"markSign"
                                                        }];
    
    RKRelationshipMapping* mailMetaDataRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"mail_meta_data"
                                                                                                toKeyPath:@"mailMetaData"
                                                                                              withMapping:[XLCMailMetaData objectMapping]];
    
    [objectMapping addPropertyMapping:mailMetaDataRSMapping];
    
    return objectMapping;
}

@end
