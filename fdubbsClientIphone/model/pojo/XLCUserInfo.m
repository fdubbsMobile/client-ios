//
//  XLCUserInfo.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCUserInfo.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCUserInfo

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCUserInfo class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"ident" : @"ident",
                                                        @"idle_time" : @"idleTime",
                                                        @"is_visible" : @"isVisible",
                                                        @"is_web" : @"isWeb",
                                                        @"desc" : @"desc"
                                                        }];
    RKRelationshipMapping* userMetaDataRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"user_meta_data"
                                                                                                toKeyPath:@"userMetaData"
                                                                                              withMapping:[XLCUserMetaData objectMapping]];
    
    RKRelationshipMapping* userPerformanceRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"user_performance"
                                                                                               toKeyPath:@"userPerformance"
                                                                                             withMapping:[XLCUserPerformance objectMapping]];
    
    RKRelationshipMapping* userSignatureRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"user_signature"
                                                                                               toKeyPath:@"userSignature"
                                                                                             withMapping:[XLCUserSignature objectMapping]];
    
    [objectMapping addPropertyMapping:userMetaDataRSMapping];
    [objectMapping addPropertyMapping:userPerformanceRSMapping];
    [objectMapping addPropertyMapping:userSignatureRSMapping];
    
    return objectMapping;
}

@end
