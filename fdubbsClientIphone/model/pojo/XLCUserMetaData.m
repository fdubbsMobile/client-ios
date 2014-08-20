//
//  XLCUserMetaData.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCUserMetaData.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCUserMetaData

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCUserMetaData class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"user_id" : @"userId",
                                                        @"nick" : @"nick",
                                                        @"gender" : @"gender",
                                                        @"last_login_ip" : @"lastLoginIp",
                                                        @"post_count" : @"postCount",
                                                        @"login_count" : @"loginCount",
                                                        @"horoscope" : @"horoscope",
                                                        @"last_login_time" : @"lastLoginTime"
                                                        }];
    
    return objectMapping;
}

@end
