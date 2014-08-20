//
//  XLCUserBaiscProfile.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCUserBaiscProfile.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCUserBaiscProfile

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCUserBaiscProfile class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"online_time" : @"onlineTime",
                                                        @"register_date" : @"registerDate"
                                                        }];
    
    RKRelationshipMapping* userMetaDataRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"user_meta_data"
                                                                                               toKeyPath:@"userMetaData"
                                                                                             withMapping:[XLCUserMetaData objectMapping]];
    
    RKRelationshipMapping* userBirthDateRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"birth_date"
                                                                                                  toKeyPath:@"birthDate"
                                                                                                withMapping:[XLCUserBirthDate objectMapping]];
    
    [objectMapping addPropertyMapping:userMetaDataRSMapping];
    [objectMapping addPropertyMapping:userBirthDateRSMapping];
    
    return objectMapping;
}

@end
