//
//  XLCMailMetaData.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCMailMetaData.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCMailMetaData

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCMailMetaData class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"mail_number" : @"mailNumber",
                                                        @"mail_link" : @"mailLink",
                                                        @"sender" : @"sender",
                                                        @"nick" : @"nick",
                                                        @"title" : @"title",
                                                        @"date" : @"date"
                                                        }];
    
    return objectMapping;
}

@end
