//
//  XLCFriend.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCFriend.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCFriend

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCFriend class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"user_id" : @"userId",
                                                        @"nick" : @"nick",
                                                        @"last_login_ip" : @"lastLoginIp",
                                                        @"last_action" : @"lastAction",
                                                        @"idle_time" : @"idleTime",
                                                        @"desc" : @"desc"
                                                        }];
    
    return objectMapping;
}

@end
