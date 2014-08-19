//
//  XLCLogoutResponse.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-19.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCLogoutResponse.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCLogoutResponse

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCLogoutResponse class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                          @"result_code" : @"resultCode",
                                                          @"error_message" : @"errorMessage"
                                                          }];
    
    return objectMapping;
}

@end
