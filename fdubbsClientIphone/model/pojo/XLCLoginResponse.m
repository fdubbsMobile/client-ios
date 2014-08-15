//
//  XLCLoginResponse.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-15.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCLoginResponse.h"

@implementation XLCLoginResponse

+ (NSDictionary*)elementToPropertyMappings
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"result_code", @"resultCode",
            @"error_message", @"errorMessage",
            @"auth_code", @"authCode",
            nil];
}

@end
