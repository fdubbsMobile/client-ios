//
//  XLCPostQoute.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-5-24.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCPostQoute.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCPostQoute

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCPostQoute class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                           @"owner" : @"owner",
                                                           @"content" : @"content"
                                                           }];
    
    return objectMapping;
}

@end
