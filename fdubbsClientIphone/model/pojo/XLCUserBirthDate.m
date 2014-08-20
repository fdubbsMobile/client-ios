//
//  XLCUserBirthDate.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCUserBirthDate.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCUserBirthDate

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCUserBirthDate class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"year" : @"year",
                                                        @"month" : @"month",
                                                        @"day" : @"day"
                                                        }];
    
    return objectMapping;
}

@end
